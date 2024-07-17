//
//  PRPoetrysBeiSongResultController.swift
//  PEPRead
//
//  Created by sunShine on 2024/3/18.
//  Copyright © 2024 PEP. All rights reserved.
//

import Foundation
import Kingfisher

class PRPoetrysBeiSongResultController: BaseAncientPoetryViewController{
    
    @IBOutlet weak var bgImg: UIImageView!
    
    @IBOutlet weak var audioPlayBtn: UIImageView!
    
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    @IBOutlet weak var poetryPicture: UIImageView!
    
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    
    
    @IBOutlet weak var playBgView: UIView!
    
    @IBOutlet weak var playImg: UIImageView!
    
    var progressView = PRCircularProgressView()
    var bgImgUrl = ""
    
    var currentPoetryModel = PoetryModel()
    
    var score = 0
    var audioPath = ""
    let fileManager = FileManager.default
    let audioPlayer = PRPoetryPlayer()
    
    var isPlayTag = false
    
    var fileName = ""
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nav = self.navigationController as? BaseAncientPoetryNavigation{
            nav.isLimitPopGesture = true
            nav.navigationPopDelegate = self
        }
    }
    
//    var shareManager: PRShareManager = PRShareManager()
    
    //FIXME返回的时候跳过之前的背诵页,,
    // 重新背诵,返回动作
    override func viewDidLoad() {
        self.title = "背诵"
        self.removeScrollView = true
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        if bgImgUrl.count > 0{
            bgImg.kf.setImage(with: URL(string: bgImgUrl))
        }
        //章节+ 诗id 作为key,存贮到本地
        let key = currentPoetryModel.chapter_id + "poetryPictureKey"
        let cache = ImageCache.default
        if cache.isCached(forKey: key) {
            cache.retrieveImage(forKey: key) {[weak self] result in
                guard let self = self  else { return  }
                switch result {
                   case .success(let value):
                    self.poetryPicture.image = value.image
                    let tempImgView = UIImageView(image: value.image)
                    let height = (WIDTH_SWIFT - 32)*tempImgView.frame.size.height/tempImgView.frame.size.width
                    self.contentViewH.constant = height
                    
                   case .failure(let error):
                       print(error)
                   }
            }
        }
        
      
        
        
        audioPlayer.delegate = self
        
        if score == 1 {
            star1.image = UIImage(named: "pr_icon_poetry_star")
            star2.image = UIImage(named: "pr_icon_poetry_unstar")
            star3.image = UIImage(named: "pr_icon_poetry_unstar")
        }else if score == 2{
            star1.image = UIImage(named: "pr_icon_poetry_star")
            star2.image = UIImage(named: "pr_icon_poetry_star")
            star3.image = UIImage(named: "pr_icon_poetry_unstar")
            
        }else if score == 3{
            star1.image = UIImage(named: "pr_icon_poetry_star")
            star2.image = UIImage(named: "pr_icon_poetry_star")
            star3.image = UIImage(named: "pr_icon_poetry_star")
        }
        else{
            star1.image = UIImage(named: "pr_icon_poetry_unstar")
            star2.image = UIImage(named: "pr_icon_poetry_unstar")
            star3.image = UIImage(named: "pr_icon_poetry_unstar")
        }
        
        let frame = playImg.frame
        progressView = PRCircularProgressView(frame: CGRect(x: frame.origin.x - 4, y: frame.origin.y - 4, width: 68, height: 68))
        progressView.lineColor = UIColor.init(hexString: "#FF8C9D")
        playBgView.insertSubview(progressView, belowSubview: playImg)
    }
    
    @IBAction func clickPlayAudioBtn(_ sender: Any) {
        if audioPlayer.isPlaying(){
            audioPlayer.pause()
            progressView.pauseAnimation()
            playImg.image = UIImage(named: "pr_icon_sdk_gsc_replay")
        }else{
            if isPlayTag  && audioPlayer.isPaused(){
                audioPlayer.resume()
                progressView.resumeAnimation()
                
                playImg.image = UIImage(named: "pr_icon_sdk_gsc_stop")
            }else{
                
                if fileManager.fileExists(atPath: audioPath){
                    //播放
                    audioPlayer.playOnly(url: URL(fileURLWithPath: audioPath))
                    isPlayTag = true
                    playImg.image = UIImage(named: "pr_icon_sdk_gsc_stop")
                }else{
//                    showPEPToast("录音文件不存在")
                }
            }
            
        }
        
    }
    
    @IBAction func clickRetryBtn(_ sender: Any) {
        //发通知
        NotificationCenter.default.post(name: .PRPoetryRetryBeisong, object: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
}
extension PRPoetrysBeiSongResultController: PRPoetryPlayerDelegate{
    func audioPlayerTimeControlStatusChanged(_ audioPlayer: AVPlayer, status: AVPlayer.TimeControlStatus) {
        switch status {
                case .paused:
                   //动画在暂停
                    print("")
                    
            
                case .playing:
                    //动画开始
                    if let duration = self.audioPlayer.onlyPlayItem?.duration{
                        let seconds = CMTimeGetSeconds(duration)
                        if !(progressView.isDrawing()) {
                            progressView.startAnimation(duration: seconds)
                        }
                        
                    }
                    
                default:
                    break
                }
    }
    
    func audioPlayer(_ audioPlayer: PRPoetryPlayer, didUpdateProgress progress: Float, _ currentTime: Int) {
        print("kkk进度-\(progress)+++时间戳\(currentTime)")
    }
    
   
    
    // 播放完成通知处理方法
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else {
            return
        }
        
        if self.isViewControllerVisible(self) && playerItem == audioPlayer.player?.currentItem {
            print("跟读音频播放完成")
            playImg.image = UIImage(named: "pr_icon_sdk_gsc_replay")
            progressView.resetAnimation()
            isPlayTag = false
        }
    }
    
    func audioPlayer(_ audioPlayer: PRPoetryPlayer, didFailWithError error: Error?) {
            
    }
}
extension PRPoetrysBeiSongResultController: PCNavigationControllerPopDelegate{
    func navigationBarShouldPopViewController(_ nvigationController: UINavigationController!, onBackBarButtonAction backBarButtonItem: UIBarButtonItem!) {
        
        for viewController in self.navigationController?.viewControllers ?? [] {
            if viewController is PRPoetryModuleViewController {
                // 返回到 A 控制器
                self.navigationController?.popToViewController(viewController, animated: true)
                break
            }
        }
    }
}
