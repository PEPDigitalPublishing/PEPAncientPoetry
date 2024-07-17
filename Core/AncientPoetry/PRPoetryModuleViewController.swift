//
//  PRPoetryModuleViewController.swift
//  PEPRead
//
//  Created by sunShine on 2023/8/22.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
import SwiftyJSON
import Kingfisher

enum poetryStyle: Int{
    case Tangpoetry = 1, SongCi, YuanQu, Wen, Tangpoetry_needConfig, Tangpoetry_dontNeedConfig, QinYuanChunXue = 10, JianJia
}
enum entertype: Int{
    case app = 1, sdk
}
@objcMembers
class PRPoetryModuleViewController : BaseAncientPoetryViewController {
    var enType :entertype = .app
    var outerSpace: CGFloat {
        get{
            if isiPad
            {
                return 25.0
            }else{
                return 25.0
            }
        }
    }
    var contentPadding: CGFloat {
        get{
            if isiPad
            {
                return 25.0
            }else{
                return 25.0
            }
        }
    }
    var contentMargins: CGFloat {
        get{
            if isiPad
            {
                return 32.0
            }else{
                return 32.0
            }
        }
    }
    
   
    
    
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    var style: poetryStyle = .Tangpoetry
    var bgImgUrl = ""
    @IBOutlet weak var menuStackView: UIStackView!
    
    @IBOutlet weak var shangxiView: UIView!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var genduView: UIView!
    
    @IBOutlet weak var bensongView: UIView!
    
    @IBOutlet weak var ywLine: UIView!
    
    @IBOutlet weak var sxLine: UIView!
    @IBOutlet weak var videoLine: UIView!
    
    @IBOutlet weak var gdLine: UIView!
    
    @IBOutlet weak var bsLine: UIView!
    
    
    var playerCtrl: PRAudioPlayerControl!
    var bookID = ""
    //听课文-购买逻辑需要
    var is_TKW = false
    var textBookID = ""
    var textBookName = ""
    var expages = 0
    var titlePages = 0
    
    var compatibleModel = VoiceCourseModel()
    var currentTime: Int = 0 {
        didSet{
        
            if isShow && hidePlayerOnlyOnce && currentTime >= 4{
                hidePlayerOnlyOnce = false
                self.clickUPBtn("")
            }
        }
    }
    var duration = 0
    var countDownIndex = 0
    
    var currentPoetryModel = PoetryModel()
    
    @IBOutlet weak var bgImgV: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
    @IBOutlet weak var bottomHC: NSLayoutConstraint!
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bgViewBottomH: NSLayoutConstraint!
    
    @IBOutlet weak var poetryScrollview: UIScrollView!
    var isShow = true
    
    var infoDataDic: [String: PRPoetryInfoRootClass] = [:]
    
    var popView_now: LSTPopView?
    var currentIndex = 0 {
        didSet{
            let poetryModel = dataArray[currentIndex]
            currentPoetryModel = poetryModel
            
            self.compatibleModel.currentAudioIndex = UInt(currentIndex)
            self.bookID = poetryModel.book_id
            style = poetryStyle(rawValue: poetryModel.genre) ?? .Tangpoetry
            
            bgImgUrl = poetryModel.bgImgUrl
            if let view = popView_now{
                view.dismiss()
            }
            
        }
    }
    var dataArray = Array<PoetryModel>(){
        didSet{
            for (index, model) in dataArray.enumerated(){
                if model.path == currentPoetryModel.path{
                    currentIndex = index
                }
            }
            //整理数据
            changeDataModel()
           
            
        }
    }
    var dataNSArray: NSArray {
        get{
            let arr = NSMutableArray()
            for model in dataArray{
                arr.add(model)
            }
            return arr.copy() as! NSArray
        }
    }
    var infoData : PRPoetryInfoRootClass? {
        didSet{
            configData()
        }
    }
    var hidePlayerOnlyOnce = false
    var titleWordViewArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
    var orderWordViewArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
    var contentWordViewArr: Array<Array<Array<PRPoetrySingleTextView>>> = Array<Array<Array<PRPoetrySingleTextView>>>()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerCtrl.playerEngine.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
        
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance.init()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.clear
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                       NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            
            let navbar = self.navigationController?.navigationBar
            navbar?.tintColor = UIColor.white
            navbar?.barTintColor = UIColor.white
            navbar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                          NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.barTintColor = UIColor.theme
        }
        self.resetGSCNavBarStyle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.ambient)
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
        if #available(iOS 13.0, *) {
            
            let appearance = UINavigationBarAppearance.init()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.clear
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                       NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            
            let navbar = self.navigationController?.navigationBar
            navbar?.tintColor = UIColor.white
            navbar?.barTintColor = UIColor.white
            navbar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                          NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.barTintColor = UIColor.clear
        }
        self.showGSCNavBarStyle()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nav = self.navigationController as? BaseAncientPoetryNavigation{
            nav.isLimitPopGesture = true
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeScrollView = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled  = false
//        UserDefaults.standard.setValue(1, forKey: "kLocalMusicPlayModeKey")
        self.title = "古诗词"
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoti(notification:)), name: NSNotification.Name(rawValue: PRNotificationNameClickPoetryword), object: nil)
        createGLayer()
        
        configAudioPlayer()
        requestData()
        hidePlayerOnlyOnce = true
        let swip = UISwipeGestureRecognizer()
        swip.direction = .left
        swip.addTarget(self, action: #selector(swipAction(swip:)))
        self.view.addGestureRecognizer(swip)
        let swip1 =    UISwipeGestureRecognizer()
        swip1.direction = .right
        swip1.addTarget(self, action: #selector(swipAction(swip:)))
        self.bgView.addGestureRecognizer(swip1)
        
        
        
        if enType == .sdk{
            genduView.isHidden = false
            bensongView.isHidden = false
        }else{
            genduView.isHidden = true
            bensongView.isHidden = true
        }
        
        self.navigationBar.title.text = "古诗词"
        self.viewTop.constant = CGFloat(64)
        self.view.setNeedsLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        

    }
    
   
    @objc func swipAction(swip: UISwipeGestureRecognizer){
        if swip.direction == .left
        {
            let index = PoetryPlayViewController.findTrueNextAudioItem(Int32(currentIndex), dataArr: dataNSArray as? [PoetryModel])
            
            currentIndex = index
            requestData()
            changeCountTime()
        }else{
            
            let index = PoetryPlayViewController.findTruePreAudioItem(Int32(currentIndex), dataArr: dataNSArray as? [PoetryModel])
            
            currentIndex = index
            requestData()
            changeCountTime()
        }
    }
   
   
    override func requestData() {
        
//        let params = ["file_name": currentPoetryModel.fileName as String]
       
        
        if let info = infoDataDic[currentPoetryModel.fileName] {
            self.infoData = info
            print("使用缓存")
            if let videoUrl = self.infoData?.mp4src.url, videoUrl.count > 0 {
                self.videoView.isHidden = true
            }else{
                self.videoView.isHidden = true
            }
        }else{
            print("不使用缓存")
//            if (YSAudioUserManager.share().isLogin() == false) {
//                return
//            }
            let accessToken: String = YSAudioUserManager.share().getAccessToken() ;
//            let userID: String = YSAudioUserManager.share().getUserInfoModel().user_id
            let userID: String = "10007"
            let urlStr = ServerAPI.PR_API_poetryInfo.rawValue.replacingOccurrences(of: "<userid>", with: userID)
            let tempUrl = urlStr + "?access_token=\(accessToken)"
            let finUrl = URLString(with: tempUrl)
           
            self.showLoadingView()
            
            let urlParams = ["file_name": currentPoetryModel.fileName as String, "flag": 0] as [String : Any]
            
            Networking.postDic(with: finUrl, params: urlParams) { [weak self] response in
                self?.hideLoadingView()
                
                let model = PRPoetryInfoRootClass.init(fromJson: JSON(response))
                
                if model.id.count > 0 {
                    print("")
                    self?.infoData = model
                    self?.infoDataDic[self?.currentPoetryModel.fileName ?? ""] = model
                    if let videoUrl = self?.infoData?.mp4src.url, videoUrl.count > 0 {
                        self?.videoView.isHidden = true
                    }else{
                        self?.videoView.isHidden = true
                    }
                }else{
                    
                }
            } fail: { [weak self] error in
                self?.hideLoadingView()
                
            }
        }
 
        requestAudioUrl()
        
        if currentPoetryModel.bgImgUrl.count > 0{
            bgImgV.kf.setImage(with: URL(string: currentPoetryModel.bgImgUrl))
        }
    }
    func requestAudioUrl(){
        if !YSAudioUserManager.share().isLogin(){
            return
        }
        let accessToken: String = UserDefaults.standard.value(forKey: "access_token_Key") as! String
//        let userID: String = YSAudioUserManager.share().getUserInfoModel().user_id
        let userID: String = "10007"
        let urlStr = ServerAPI.PR_API_poetryInfo.rawValue.replacingOccurrences(of: "<userid>", with: userID)
        let tempUrl = urlStr + "?access_token=\(accessToken)"
        let finUrl = URLString(with: tempUrl)
        
        if let signedPath = currentPoetryModel.signedPath, signedPath.hasPrefix("http"){
            self.configPlayerData()
            
        }else{
            if currentPoetryModel.path.count <= 0{return}
            let urlParams = ["file_name": currentPoetryModel.path as String, "flag": 1] as [String : Any]
           
            Networking.postDic(with: finUrl, params: urlParams) { [weak self] response in
                
                let dic = response as! [String: Any]
                if let url_signature = dic["url_signature"] as? String, url_signature.count > 0{
                    let model = self?.dataArray[self?.currentIndex ?? 0]
                   
                    model?.signedPath = url_signature
                    self?.configPlayerData()
                }else{
//                    showPEPToast("音频数据异常")
//                    
                }
            } fail: { [weak self] error in
              print("")
//                showPEPToast("音频数据异常")
            }
        }
        
    }
    func configPlayerData(){
    
        changePlayerData()
        
    }
    func changePlayerData(){
        
        let model = dataArray[currentIndex]
        playerCtrl.playAudio(withURLString: model.signedPath)
    }
    func changeDataModel(){
        
        compatibleModel = VoiceCourseModel()
        let arrM: NSMutableArray =  NSMutableArray()
        for pretry in dataArray{
            let model = AudioModel()
            model.title = pretry.title
            model.url = pretry.path;
            model.duration = pretry.duration;
            model.audioId = pretry.chapter_id;
            model.is_trueUrl = true
            arrM.add(model)
        }
        if arrM.count > 0{
            compatibleModel.audios = (arrM.copy() as! [AudioModel])
        }
    }
    
    func configData() {

//        config view
        if currentPoetryModel.chapter_id == "gsc_9a_1"{
            //沁园春雪
            style = .QinYuanChunXue
        }
        if currentPoetryModel.chapter_id == "gsc_8b_2"{
            
            style = .JianJia
        }
        
        switch style {
        case .Tangpoetry:
            configTangpoetry()
        case .SongCi:
            configSongci()
        case .Tangpoetry_needConfig:
            configTangpoetry()
        case .Tangpoetry_dontNeedConfig:
            configTangpoetry()
        case .YuanQu:
            configSongci()
        case .Wen:
            configSongci()
        case .QinYuanChunXue:
            configTangpoetry()
        case .JianJia:
            configTangpoetry()
        }
        
           
        
    }
    
    
    
    
    @IBAction func clickAppreciationBtn(_ sender: Any) {
        guard let info = infoData else{
            return
        }
        let storyBoard = UIStoryboard(name: "PRPoetryModuleAppreciationVC", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PRPoetryModuleAppreciationVC") as! PRPoetryModuleAppreciationVC
        vc.infoData = infoData
        vc.style = style
        vc.bgImgUrl = currentPoetryModel.bgImgUrl
        vc.currentPoetryModel = currentPoetryModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickVideoBtn(_ sender: Any) {
        
        guard let videoUrl = infoData?.mp4src.url else {
//            showPEPToast("当前古诗词没有视频数据!")
            return
        }
        let params = ["file_name": videoUrl, "flag": 1] as [String : Any]
        self.showLoadingView()
        Networking.postDic(with: URLString(with: .PR_API_poetryInfo), params: params) { [weak self] response in
            self?.hideLoadingView()
            let dic = response as! [String: Any]
            
            if let url_signature = dic["url_signature"] as? String, url_signature.count > 0{
                let vc = PRWebVideoViewController.init()
                //获取视频地址
                vc.is_poetry = true
                let model = PRWebVideoModuleModel()
                model.videoUrl = url_signature
                model.code = self?.infoData?.id ?? ""
                model.title = self?.infoData?.poem.title.name ?? ""
                vc.model = model
                self?.navigationController?.pushViewController(vc, animated: true)
            }else{
//                showPEPToast("没有视频数据")
            }
            
            
        } fail: { [weak self] error in
            self?.hideLoadingView()
            
        }
        
        
    }
    
    @IBAction func clickGenDuBtn(_ sender: Any) {

            
        //获取音频
        //去获取真实地址
        //去下载
        //去播放
        let storyBoard = UIStoryboard(name: "PRPoetryGenDuController", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PRPoetryGenDuController") as! PRPoetryGenDuController
        vc.infoData = infoData
        vc.style = style
        vc.bgImgUrl = currentPoetryModel.bgImgUrl
        vc.currentPoetryModel = currentPoetryModel
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    @IBAction func clickBeiSongBtn(_ sender: Any) {
        
        //章节+ 诗id 作为key,存贮到本地
//        let key = currentPoetryModel.chapter_id + "poetryPictureKey"
//        let cache = ImageCache.default
//        
//        
//        if cache.isCached(forKey: key) {
//            let path = cache.cachePath(forKey: key)
//            print("kk-已经缓存--path\(path)")
            
            let storyBoard = UIStoryboard(name: "PRPoetrysBeiSongController", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PRPoetrysBeiSongController") as! PRPoetrysBeiSongController
            vc.infoData = infoData
            vc.style = style
            vc.bgImgUrl = currentPoetryModel.bgImgUrl
            vc.currentPoetryModel = currentPoetryModel
            self.navigationController?.pushViewController(vc, animated: true)
//           return
//        }
//        showPEPToast("正在准备数据...")
//        TYSnapshotScroll.screenSnapshot(self.poetryScrollview) { [weak self] screenShotImage in
//            guard let self = self else {return}
//            guard let image = screenShotImage else {
//                return
//            }
//            guard let chapterId = self.currentPoetryModel.chapter_id else {
//                return
//            }
//            cache.store(image, forKey: key)
//            print("kk-当前在缓存")
//            let storyBoard = UIStoryboard(name: "PRPoetrysBeiSongController", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "PRPoetrysBeiSongController") as! PRPoetrysBeiSongController
//            vc.infoData = infoData
//            vc.style = style
//            vc.bgImgUrl = currentPoetryModel.bgImgUrl
//            vc.currentPoetryModel = currentPoetryModel
//            self.navigationController?.pushViewController(vc, animated: true)
//
//
//        }

    }
    
    
    
    @IBAction func clickUPBtn(_ sender: Any) {
        if isShow{
            isShow = false
            bottomHC.constant = -CGFloat(160)
            bgViewBottomH.constant = 60
            self.view.setNeedsUpdateConstraints()
            playerView.alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5) {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }else{
            isShow = true
            bottomHC.constant = 0.0
            bgViewBottomH.constant = 160
            self.view.setNeedsUpdateConstraints()
            playerView.alpha = 1.0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5) {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
        
        
    }
    

    func createGLayer(){

        let gradeLayer = CAGradientLayer()
        let whiteColor = UIColor.white
        gradeLayer.colors = [whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(0.0).cgColor]
        gradeLayer.locations = [0.7, 0.99]
        gradeLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradeLayer.endPoint = CGPoint.init(x: 0, y: 1)
        gradeLayer.cornerRadius = 15
        bgView.setNeedsLayout()
        bgView.layoutIfNeeded()
        gradeLayer.frame = bgView.bounds
        
        bgView.layer.insertSublayer(gradeLayer, at: 0)
    }
}
extension PRPoetryModuleViewController{
    func configTangpoetry(){
        
        for subView in contentView.subviews{
            subView.removeFromSuperview()
        }
        let titleV = UIView.init()
        contentView.addSubview(titleV)
        titleV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(outerSpace)
            make.right.equalToSuperview().offset(-outerSpace)
        }
        //标题自带
        
        if let text = infoData?.poem.title.name{
            let textData = PRPoetrySingleTextData(style: .title, section: 1, row: 0, fontColor: "#000000", fontSize: 28.0, spacing: 2.0, poetryStyle: style)
            
            let vStackView = PRPoetryVStackView.init(style: textData)
            titleV.addSubview(vStackView)
            vStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                
            }
            
            let annotion: [PRPoetryInfoAnnotation] = infoData?.poem.title.annotation ?? []
            let arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
            
            var wordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
            for strArr in arr{
                
                let titleS = PRPoetryHStackView.init(styleData: textData)
                vStackView.addArrangedSubview(titleS)
                var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
                
                
                for i in strArr{
                    let wordView = PRPoetrySingleTextView.init(textInfo: i, data: textData)
                    subWordArr.append(wordView)
                    titleS.addArrangedSubview(wordView)

                }
                wordArr.append(subWordArr)
                
            }
            titleWordViewArr = wordArr
            print("")
        }
        
        
        let poetV = UIView.init()
        poetV.backgroundColor = .clear
        contentView.addSubview(poetV)
        poetV.snp.makeConstraints { make in
            make.top.equalTo(titleV.snp_bottom).offset(0)
            make.left.equalToSuperview().offset(outerSpace)
            make.right.equalToSuperview().offset(-outerSpace)
        }
        let poetTextData = PRPoetrySingleTextData(style: .poet, section: 2, row: 0, fontColor: "#666666", fontSize: 18, spacing: 1.0, poetryStyle: style)
        let poetS = PRPoetryHStackView.init(styleData: poetTextData)
        poetV.addSubview(poetS)
        
        if let text = infoData?.poem.poet.name, text.count > 0{
            poetS.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            for char in text{
                let temp: PRPoetryInfoWordModel =  PRPoetryInfoWordModel(textData: poetTextData, content: "", position: .single, str: String(char))
                
                let wordView = PRPoetrySingleTextView.init(textInfo: temp, data: poetTextData)
                poetS.addArrangedSubview(wordView)
                wordView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(0)
                    make.bottom.equalToSuperview()
                }
            }
        }else{
            poetS.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(0)
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        
        //序- 开头空两格字符
        let orderV = UIView.init()
        contentView.addSubview(orderV)
//        
//        if infoData?.isorder ?? false {
//            
//            orderV.snp.makeConstraints { make in
//                make.top.equalTo(poetV.snp_bottom).offset(27)
//                make.left.equalToSuperview().offset(outerSpace)
//                make.right.equalToSuperview().offset(-outerSpace)
//            }
//            let textData = PRPoetrySingleTextData(style: .order, section: 0, row: 0, fontColor: "#888888", fontSize: 20, spacing: 4, poetryStyle: style)
//            let vStackView = PRPoetryVStackView.init(style: textData)
//            orderV.addSubview(vStackView)
//            vStackView.snp.makeConstraints { make in
//                make.top.bottom.equalToSuperview()
//                make.centerX.equalToSuperview()
//            }
//            let orderContent = infoData?.poem.content.first
//            if let text = orderContent?.label{
//               
//                let annotion: [PRPoetryInfoAnnotation] = orderContent?.annotation ?? []
//                let arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
//                var wordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
//
//                for strArr in arr{
//
//                    let contentS = PRPoetryHStackView.init(styleData: textData)
//                    vStackView.addArrangedSubview(contentS)
//                    var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
//                    for i in strArr{
//                        let wordView = PRPoetrySingleTextView.init(textInfo: i, data: textData)
//                        subWordArr.append(wordView)
//                        contentS.addArrangedSubview(wordView)
//
//                    }
//                    wordArr.append(subWordArr)
//                    or = wordArr
//
//                }
//
//            }
//            
//        }
        orderV.snp.makeConstraints { make in
            make.top.equalTo(poetV.snp_bottom).offset(0)
            make.left.equalToSuperview().offset(outerSpace)
            make.right.equalToSuperview().offset(-outerSpace)
        }
        
        
        //正文- 
        
        let contentV = UIView.init()
        contentView.addSubview(contentV)
        if let contentArr = infoData?.poem.content {
            
            
        contentV.snp.makeConstraints { make in
            make.top.equalTo(orderV.snp_bottom).offset(15)
            make.left.equalToSuperview().offset(36)
            make.right.equalToSuperview().offset(-14)
            make.bottom.lessThanOrEqualToSuperview().offset(-1)
        }
            
            
            let textData = PRPoetrySingleTextData(style: .content, section: 0, row: 0, fontColor: "#212121", fontSize: 24, spacing: 4, poetryStyle: style)
            let vStackView = PRPoetryVStackView.init(style: textData)
            contentV.addSubview(vStackView)
            vStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            var wordArr: Array<Array<Array<PRPoetrySingleTextView>>> = Array<Array<Array<PRPoetrySingleTextView>>>()
            for contentNum in 0...contentArr.count - 1 {
                print("段数--\(contentNum)")
                if infoData?.isorder ?? false {
                    //有序
                    if contentNum == 0 {continue}
                    
                }
                let orderContent = infoData?.poem.content[contentNum]
               
                if let text = orderContent?.label{
                    
                    
                    let annotion: [PRPoetryInfoAnnotation] = orderContent?.annotation ?? []
                    let arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
                    var sectionWordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
                    for strArr in arr{
    
                        let contentS = PRPoetryHStackView.init(styleData: textData)
                        vStackView.addArrangedSubview(contentS)
                        var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
                        for i in strArr{
                            let wordView = PRPoetrySingleTextView.init(textInfo: i, data: textData)
                            subWordArr.append(wordView)
                            contentS.addArrangedSubview(wordView)
    
                        }
                        sectionWordArr.append(subWordArr)
                       
                        var tempBlankRow = false
                        if style == .QinYuanChunXue{
                            for tempSubStr in strArr{
                                if tempSubStr.str == "娆"{
                                    tempBlankRow = true
                                }
                            }
                        }
                        if style == .JianJia{
                            for tempSubStr in strArr{
                                if tempSubStr.str == "央"{
                                    tempBlankRow = true
                                }
                            }
                            for tempSubStr in strArr{
                                if tempSubStr.str == "坻"{
                                    tempBlankRow = true
                                }
                            }
                            for tempSubStr in strArr{
                                if tempSubStr.str == "沚"{
                                    tempBlankRow = true
                                }
                            }
                        }
                        
                        if tempBlankRow {
                            let contentS = PRPoetryHStackView.init(styleData: textData)
                            vStackView.addArrangedSubview(contentS)
                            var nullWordModel = PRPoetryInfoWordModel(textData: textData, content: "", position: .normal, str: "卍")
                            let wordView = PRPoetrySingleTextView.init(textInfo: nullWordModel, data: textData)
                            contentS.addArrangedSubview(wordView)
                        }
    
                    }
                    wordArr.append(sectionWordArr)
                    
                }
                
            }
            contentWordViewArr = wordArr
            
        }else{
            contentV.snp.makeConstraints { make in
                make.top.equalTo(orderV.snp_bottom).offset(0)
                make.left.equalToSuperview().offset(25)
                make.right.equalToSuperview().offset(-25)
                make.bottom.equalToSuperview()
            }
        }
    
    }
    
    
    func configSongci(){
        
        for subView in contentView.subviews{
            subView.removeFromSuperview()
        }
        let titleV = UIView.init()
        titleV.backgroundColor = .clear
        contentView.addSubview(titleV)
        titleV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(outerSpace)
            make.right.equalToSuperview().offset(-outerSpace)
        }
        //标题自带
        if let text = infoData?.poem.title.name{
            let textData = PRPoetrySingleTextData(style: .title, section: 1, row: 0, fontColor: "#000000", fontSize: 28.0, spacing: 2.0, poetryStyle: style)
            let vStackView = PRPoetryVStackView.init(style: textData)
            titleV.addSubview(vStackView)
            vStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                
            }
            let annotion: [PRPoetryInfoAnnotation] = infoData?.poem.title.annotation ?? []
            let arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
            var wordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()

            for strArr in arr{
                
                let titleS = PRPoetryHStackView.init(styleData: textData)
                vStackView.addArrangedSubview(titleS)
                var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
                
                for i in strArr{
                    let wordView = PRPoetrySingleTextView.init(textInfo: i, data: textData)
                    subWordArr.append(wordView)
                    titleS.addArrangedSubview(wordView)

                }
                wordArr.append(subWordArr)
                
            }
            titleWordViewArr = wordArr
            print("")

        }
        
        
        let poetV = UIView.init()
        poetV.backgroundColor = .clear
        contentView.addSubview(poetV)
        poetV.snp.makeConstraints { make in
            make.top.equalTo(titleV.snp_bottom).offset(0)
            make.left.equalToSuperview().offset(outerSpace)
            make.right.equalToSuperview().offset(-outerSpace)
        }
        let poetTextData = PRPoetrySingleTextData(style: .poet, section: 0, row: 0, fontColor: "#666666", fontSize: 18, spacing: 1.0, poetryStyle: style)
        let poetS = PRPoetryHStackView.init(styleData: poetTextData)
        poetV.addSubview(poetS)
        poetS.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        if let text = infoData?.poem.poet.name, text.count > 0{
            for char in text{
                
                let temp: PRPoetryInfoWordModel =  PRPoetryInfoWordModel(textData: poetTextData, content: "", position: .single, str: String(char))
                let wordView = PRPoetrySingleTextView.init(textInfo: temp, data: poetTextData)
                poetS.addArrangedSubview(wordView)
                wordView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(22)
                    make.bottom.equalToSuperview()
                }
            }
        }
        
        //序- 开头空两格字符
        
        let orderV = UIView.init()
        contentView.addSubview(orderV)
        
        if infoData?.isorder ?? false {
            
            orderV.snp.makeConstraints { make in
                make.top.equalTo(poetV.snp_bottom).offset(21)
                make.left.equalToSuperview().offset(outerSpace)
                make.right.equalToSuperview().offset(-outerSpace)
            }
            let textData = PRPoetrySingleTextData(style: .order, section: 0, row: 0, fontColor: "#888888", fontSize: 20, spacing: 4, poetryStyle: style)
            let vStackView = PRPoetryVStackView.init(style: textData)
            orderV.addSubview(vStackView)
            vStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            let orderContent = infoData?.poem.content.first
            if let text = orderContent?.label{
                
                let annotion: [PRPoetryInfoAnnotation] = orderContent?.annotation ?? []
                let arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
                var wordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()

                for strArr in arr{

                    let contentS = PRPoetryHStackView.init(styleData: textData)
                    vStackView.addArrangedSubview(contentS)
                    var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
                    for i in strArr{
                        let wordView = PRPoetrySingleTextView.init(textInfo: i, data: textData)
                        subWordArr.append(wordView)
                        contentS.addArrangedSubview(wordView)

                    }
                    wordArr.append(subWordArr)
                    

                }
                orderWordViewArr = wordArr
            }
            
        }else{
            orderV.snp.makeConstraints { make in
                make.top.equalTo(poetV.snp_bottom).offset(0)
                make.left.equalToSuperview().offset(outerSpace)
                make.right.equalToSuperview().offset(-outerSpace)
            }
        }
        
        //正文- 开头空两格字符
        
        let contentV = UIView.init()
        contentView.addSubview(contentV)
        if let contentArr = infoData?.poem.content {
            
            contentV.snp.makeConstraints { make in
                make.top.equalTo(orderV.snp_bottom).offset(21)
                make.left.equalToSuperview().offset(contentPadding)
                make.right.equalToSuperview().offset(-contentPadding)
                make.bottom.lessThanOrEqualToSuperview().offset(-1)
            }
            let textData = PRPoetrySingleTextData(style: .content, section: 1, row: 0, fontColor: "#212121", fontSize: 24, spacing: 4, poetryStyle: style)
            let vStackView = PRPoetryVStackView.init(style: textData)
            contentV.addSubview(vStackView)
            vStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            var wordArr: Array<Array<Array<PRPoetrySingleTextView>>> = Array<Array<Array<PRPoetrySingleTextView>>>()
            for contentNum in 0...contentArr.count - 1 {
                print("段数--\(contentNum)")
                if infoData?.isorder ?? false {
                    //有序
                    if contentNum == 0 {continue}
                    
                }
                let orderContent = infoData?.poem.content[contentNum]
               
                if let text = orderContent?.label{
                    
                    
                    let annotion: [PRPoetryInfoAnnotation] = orderContent?.annotation ?? []
                    let arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
                    var sectionWordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
                    for strArr in arr{
    
                        let contentS = PRPoetryHStackView.init(styleData: textData)
                        vStackView.addArrangedSubview(contentS)
                        var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
                        for i in strArr{
                            let wordView = PRPoetrySingleTextView.init(textInfo: i, data: textData)
                            subWordArr.append(wordView)
                            contentS.addArrangedSubview(wordView)
    
                        }
                        sectionWordArr.append(subWordArr)
                       
    
                    }
                    wordArr.append(sectionWordArr)
                    
                }
                
            }
            contentWordViewArr = wordArr
            
        }else{
            contentV.snp.makeConstraints { make in
                make.top.equalTo(orderV.snp_bottom).offset(0)
                make.left.equalToSuperview().offset(contentPadding)
                make.right.equalToSuperview().offset(-contentPadding)
                make.bottom.equalToSuperview()
            }
        }
        
        
        
    }
}
extension PRPoetryModuleViewController{
    func getFinalWordResult(str: String, textData: PRPoetrySingleTextData, annotion: [PRPoetryInfoAnnotation]) -> Array<Array<PRPoetryInfoWordModel>>{
        var textStr = str
        if textData.poetryStyle == .SongCi && textData.style == .content {
            textStr = "卍卍" + str
        }
        if textData.poetryStyle == .SongCi && textData.style == .order {
            textStr = "卍卍" + str
        }
        let tempArr = resetWordData(str: textStr, textData: textData, annotion: annotion)
        if textData.style == .title{
            return tempArr
        }
        var result = checktextArr(sectionArr: tempArr, textData: textData)
        var arr = result.arr
        while !result.isFinish{
            print("kk-while检查一次")
            result = checktextArr(sectionArr: result.arr, textData: textData)
            arr = result.arr
        }
        return arr
    }
    
    //词样式
    func resetWordData(str: String, textData: PRPoetrySingleTextData, annotion: [PRPoetryInfoAnnotation]) -> Array<Array<PRPoetryInfoWordModel>>{
        var sectionArr = Array<Array<PRPoetryInfoWordModel>>()
        //宋词的正文有所调整
        let tempMargin = textData.style == .content ? (contentMargins  + contentPadding * 2) : (outerSpace * 2 + contentMargins )
        //计算一行可以放多少字
        let wordNums = Int(WIDTH_SWIFT - tempMargin) / Int(textData.fontSize + textData.spacing)
        let lineNum = str.count / wordNums + (str.count % wordNums > 0 ? 1 : 0)
        
        if textData.poetryStyle == .Tangpoetry_needConfig && textData.style == .content && isIphone{
            var arr = Array<String>()
            //行路难特殊处理
            if self.currentPoetryModel.chapter_id == "gsc_9a_2" && str.hasPrefix("行路难"){
                arr = str.components(separatedBy: "多")
                if var temp = arr.last, arr.count > 1{
                    temp = "多" + temp
                    arr[1] = temp
                }
            }
            
            else if str.contains("，"){
                arr = str.components(separatedBy: "，")
                if var temp = arr.first{
                    temp = temp + "，"
                    arr[0] = temp
                }
    
            }else if str.contains("："){
                arr = str.components(separatedBy: "：")
                if var temp = arr.first{
                    temp = temp + "："
                    arr[0] = temp
                }
            }else if str.contains("？"){
                arr = str.components(separatedBy: "？")
                if var temp = arr.first{
                    temp = temp + "？"
                    arr[0] = temp
                }
            }
            else{
                arr.append(str)
            }
            
            
            for (index, str) in arr.enumerated(){
                var rowArr = Array<PRPoetryInfoWordModel>()
                for(subIndex, char) in str.enumerated(){
                    var trueIndex = 0
                    if index == 1{
                        trueIndex = subIndex + 1 + arr[0].count
                    }else{
                        trueIndex = subIndex + 1
                    }
                    
                    var wordModel = checkAnnotation(index: trueIndex, textData: textData,annotion: annotion)
                    wordModel.str = String(char)
                    print("是否锚点:\(wordModel.annotion ? "是" : "否")---第\(trueIndex)个字符:" + wordModel.str)
                    rowArr.append(wordModel)
                }
                
                sectionArr.append(rowArr)
            }
                
            
            
            
        }

        else if textData.style == .title && str.count > wordNums{
            //用括号分割
            if str.contains("（"){
                var arr = Array<String>()
                if str.contains("（"){
                    arr = str.components(separatedBy: "（")
                    if var temp = arr.last{
                        temp =  "（" + temp
                        arr[1] = temp
                    }
                    if arr.count == 2{
                        for (index, str) in arr.enumerated(){
                            var rowArr = Array<PRPoetryInfoWordModel>()
                            for(subIndex, char) in str.enumerated(){
                                var trueIndex = 0
                                if index == 1{
                                    trueIndex = subIndex + 1 + arr[0].count
                                }else{
                                    trueIndex = subIndex + 1
                                }
                                
                                var wordModel = checkAnnotation(index: trueIndex, textData: textData,annotion: annotion)
                                wordModel.str = String(char)
                                print("标题是否锚点:\(wordModel.annotion ? "是" : "否")---第\(trueIndex)个字符:" + wordModel.str)
                                rowArr.append(wordModel)
                            }
                            
                            sectionArr.append(rowArr)
                        }
                        
                    }
                }
            }else{
                let lineOneStr = str.prefix(str.count - 4)
                let lineTwoStr = str.suffix(4)
                let arr = [lineOneStr, lineTwoStr]
                for (index, str) in arr.enumerated(){
                    var rowArr = Array<PRPoetryInfoWordModel>()
                    for(subIndex, char) in str.enumerated(){
                        var trueIndex = 0
                        if index == 1{
                            trueIndex = subIndex + 1 + arr[0].count
                        }else{
                            trueIndex = subIndex + 1
                        }
                        
                        var wordModel = checkAnnotation(index: trueIndex, textData: textData,annotion: annotion)
                        wordModel.str = String(char)
                        print("标题是否锚点:\(wordModel.annotion ? "是" : "否")---第\(trueIndex)个字符:" + wordModel.str)
                        rowArr.append(wordModel)
                    }
                    
                    sectionArr.append(rowArr)
                }
            }

        }
        else{
        
            for line in 1...lineNum{
                var rowArr = Array<PRPoetryInfoWordModel>()
                print("第\(line)行")
                let startIndex = (line - 1) * wordNums
                let stopIndex = min(line * wordNums, str.count)
                print("第一次开始位\(startIndex)--截止\(stopIndex)")

                for i in startIndex..<stopIndex{
                    
                    let textIndex = str.index(str.startIndex, offsetBy: i)
                    var offset = 0
                    if textData.poetryStyle == .SongCi && textData.style == .content {
                        offset = 2
                    }
                    if textData.poetryStyle == .SongCi && textData.style == .order {
                        offset = 2
                    }
                    var wordModel = checkAnnotation(index: i + 1 - offset, textData: textData,annotion: annotion)
                    wordModel.str = String(str[textIndex])
                    
                    print("是否锚点\(wordModel.annotion ? "是" : "否")---第\(i)个字符:" + String(str[textIndex]))
                    rowArr.append(wordModel)
                }
                sectionArr.append(rowArr)

            }
        }
        
        return sectionArr
    }
    func checktextArr(sectionArr: Array<Array<PRPoetryInfoWordModel>>, textData: PRPoetrySingleTextData) -> (isFinish: Bool, arr: Array<Array<PRPoetryInfoWordModel>>){
        var row = 0
        var isFinish = true
        for (index, rowArr) in sectionArr.enumerated(){
            if let text = rowArr.first{
                if (text.str.contains("，")) || text.str.contains("。") || text.str.contains("？") || text.str.contains("!") || text.str.contains("）") || text.str.contains("（") {
                    //调整
                    isFinish = false
                    row = index
                    //这里把上一行的字拿到下面,如果在锚点范围内,必然是行首
                    
                    break
                }
            }
            
        }
        if isFinish{
            print("kk-检查通过---")
            return(true, sectionArr)
        }else{
            print("kk-重新检查")
            //再循环
//          
            let wordNum = sectionArr.first?.count
            let nullWordModel = PRPoetryInfoWordModel(textData: textData, content: "", position: .normal, str: "卍")
                //替换
            var tempWordModel = PRPoetryInfoWordModel(textData: textData, content: "", position: .normal, str: "卍")
    
            var newSectionArr = Array<Array<PRPoetryInfoWordModel>>()
            var needChange = false
            
            for (index, rowArr) in sectionArr.enumerated(){
                var newArr = Array<PRPoetryInfoWordModel>()
                if index == row - 1{
                    for (wordIndex, subWord) in rowArr.enumerated(){
                        if wordIndex == rowArr.count - 1{
                            //当前行-1,后面每一行都移动位置
                            tempWordModel = subWord
                            newArr.append(nullWordModel)
                            needChange = true
                        }else{
                            newArr.append(subWord)
                        }
                    }
                }

                else if index >= row && needChange{
                    needChange = false
                    newArr.append(tempWordModel)
                    for (_, subWord) in rowArr.enumerated(){
                        newArr.append(subWord)
                    }
                    if newArr.count > wordNum!{
                        tempWordModel = newArr.last!
                        needChange = true
                        newArr.removeLast()
                    }
                    
                }else{
                    for (_, subWord) in rowArr.enumerated(){
                        newArr.append(subWord)
                    }
                }
                newSectionArr.append(newArr)
            }
            if needChange
            {
                newSectionArr.append([tempWordModel])
            }
            return(false, newSectionArr)
        }
    }
    func checkAnnotation(index: Int, textData: PRPoetrySingleTextData, annotion: [PRPoetryInfoAnnotation]) -> PRPoetryInfoWordModel{
        var worfModel = PRPoetryInfoWordModel(textData: textData, content: "", position: .single, str: "")
        if annotion.count > 0{
            for model in annotion{
                if let place = model.place{
                    if place.count == 1{
                        if index == model.place.first{
                            if textData.style == .title {
                                worfModel.content = model.content
                            }else{
                                worfModel.content = model.option
                            }
                            worfModel.position = .single
                            break
                        }
                    }else{
                        if index >= model.place.first ?? 0 && index <= model.place.last ?? 0{
                            if textData.style == .title {
                                worfModel.content = model.content
                            }else{
                                worfModel.content = model.option
                            }
                            
                            if index == model.place.first{
                                worfModel.position = .left
                            }else if index == model.place.last{
                                worfModel.position = .right
                            }else{
                                worfModel.position = .middle
                            }
                            break
                        }
                    }
                }
            }
            
        }
        return worfModel
    }
}
extension PRPoetryModuleViewController: PRAudioPlayerControlPlayingDelegate{
    func configAudioPlayer(){
        
        playerCtrl = Bundle.main.loadNibNamed("PRAudioPlayerControl", owner: self, options: nil)?.first as? PRAudioPlayerControl
        playerView.addSubview(playerCtrl)
        playerCtrl.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        playerCtrl.delegate = self
        
    }
    //delegate
    func audioPlayerPlayButtonStatus(_ status: Int) {
        if status == 1{
            let model = self.dataArray[currentIndex]
            PRUserDefaultManager.shareInstance().setAudioPlayTime(model.chapter_id, time: self.currentTime)
        }else{
            
        }
    }
    func audioPlayerControl(_ audioPlayerControl: AncientPoetryPlayerControl, prevButtonAction sender: UIButton) {
        guard let _ = self.view.window , self.isViewLoaded else {
            return
        }
        let index = PoetryPlayViewController.findTruePreAudioItem(Int32(currentIndex), dataArr: dataNSArray as? [PoetryModel])
        let model = dataArray[index]
        
        if is_TKW && !model.isAuth{
            //弹窗
            
            return
        }
        currentIndex = index
        requestData()
        changeCountTime()
    }
    func audioPlayerControl(_ audioPlayerControl: AncientPoetryPlayerControl, nextButtonAction sender: UIButton) {
        guard let _ = self.view.window , self.isViewLoaded else {
            return
        }
        
        let index = PoetryPlayViewController.findTrueNextAudioItem(Int32(currentIndex), dataArr: dataNSArray as? [PoetryModel])
        let model = dataArray[index]
        
        
        if is_TKW &&  !model.isAuth{
            //弹窗
            
            return
        }
        currentIndex = index
        requestData()
        changeCountTime()
    }
    func changeCountTime(){
        if self.countDownIndex == 1 || self.countDownIndex == 2 || self.countDownIndex == 3 {
            let time = PoetryPlayViewController.calculationTime(withAudioIndex: Int32(currentIndex), self.playerCtrl.audioTimes - 10, self.playerCtrl.playingMode, dataArr: dataNSArray as? [PoetryModel])
            self.playerCtrl.configCountDown(time)
        }
    }
    func audioPlayerDidFinishPlayingSuccessfully(_ flag: Bool) {
        if flag{
            let model = dataArray[currentIndex]
//            PRUserUploadModel.countProgress(withCompatibleModel: compatibleModel, bookID: bookID)
            PRUserDefaultManager.shareInstance().setAudioPlayTime(model.chapter_id, time: 0)
            PRUserDefaultManager.shareInstance().setAudioPlayProportion(model.chapter_id, time: Int(model.duration) ?? 0)
            
        }
    }
    func audioPlayerProgressTime(_ currentTime: TimeInterval, duration: TimeInterval) {
        self.currentTime = Int(currentTime)
        self.duration = Int(duration)
        let model = dataArray[currentIndex]
        PRUserDefaultManager.shareInstance().setAudioPlayTime(model.chapter_id, time: self.currentTime)
        
    }
    func audioPlayerControl(_ audioPlayerControl: AncientPoetryPlayerControl, rewindButtonAction sender: UIButton) {
        
        let seek = max(self.currentTime - 10, 0)
        self.playerCtrl.playerEngine.seek(toTime: Int32(seek))
    }
    func audioPlayerControl(_ audioPlayerControl: AncientPoetryPlayerControl, forwardButtonAction sender: UIButton) {
        let seek = min(self.currentTime + 10, self.duration)
        self.playerCtrl.playerEngine.seek(toTime: Int32(seek))
    }
    func audioPlayerControl(_ audioPlayerControl: AncientPoetryPlayerControl, currentSpeed speed: CGFloat) {
        self.playerCtrl.playerEngine.speed = speed
    }
    func audioPlayerControl(_ audioPlayerControl: AncientPoetryPlayerControl, popupMode mode: AudioPlayerPopupMode) {
        if mode == .list {
            let vc = PEPAudioClassPlayerPopupViewController.initwithType(.list)
            vc.isBuy = true
            self.compatibleModel.currentAudioIndex = UInt(currentIndex)
            vc.dataSource = self.compatibleModel
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            vc.block = {[weak self] index in
                guard let self = self else{return}
                self.dismiss(animated: true)
                let poetryModel = self.dataArray[index]
                if self.is_TKW && !poetryModel.isAuth{
                    //弹窗
                    
                    return
                }
                self.currentIndex = index
                self.requestData()
                self.changeCountTime()
                
            }
        }else if mode == .countDownOption {
            let vc = PEPAudioClassPlayerPopupViewController.initwithType(.countDownOption)
            if self.playerCtrl.countDownTimeL?.isHidden ?? false{
                vc.countDownIndex = self.countDownIndex
            }else{
                vc.countDownIndex = 0
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            vc.countDownBlock = {[weak self](countDown, index) in
                self?.countDownIndex = index
            
                var tempCountDown = 0
                
                if index == 1 || index == 2 || index == 3{
                    let option = self?.playerCtrl.playingMode
                    let time = PoetryPlayViewController.calculationTime(withAudioIndex: Int32(self!.currentIndex), index, option!, dataArr: self?.dataNSArray as? [PoetryModel])
                    tempCountDown = time - (self?.currentTime ?? 0)
                    if tempCountDown <= 0{
//                        showPEPToast("定时器添加失败")
                        return
                    }
                    self?.playerCtrl.audioTimes = index + 10
                    switch index{
                    case 1: break
//                        showPEPToast("播完当前课后关闭")
                    case 2: break
//                        showPEPToast("播完2集声音后关闭");
                    case 3: break
//                        showPEPToast("播完3集声音后关闭");
                    default:
                        break
                    }
                }else{
                    tempCountDown = countDown
                    self?.playerCtrl.audioTimes = 0
                    if tempCountDown > 0 {
//                        showPEPToast("\((tempCountDown / 60))分钟后声音关闭")
                    }
                }
                
                self?.playerCtrl.configCountDown(tempCountDown)
                self?.dismiss(animated: true)

            }
            
        }
    }
    
    func audioPlayerControl(withCountDownFinished audioPlayerControl: AncientPoetryPlayerControl) {
        self.countDownIndex = 0
    }
    func audioPlayerControl(_ audioPlayerControl: AncientPoetryPlayerControl, changePlay playMode: AudioPlayerControlPlayingMode) {
        switch playMode {
        case .singleOnce: break
//            showPEPToast("单曲播放")
        case .singleCycle: break
//            showPEPToast("单曲循环")
        case .listCycle: break
//            showPEPToast("循环播放")
        @unknown default:
            break
        }
        if (self.countDownIndex == 1 || self.countDownIndex == 2 || self.countDownIndex == 3) {
            let option = self.playerCtrl.playingMode
            
            let time = PoetryPlayViewController.calculationTime(withAudioIndex: Int32(self.currentIndex), self.playerCtrl.audioTimes - 10, option, dataArr: dataNSArray as? [PoetryModel])
            let countDown = time - self.currentTime
            self.playerCtrl.configCountDown(countDown)
        }
    }
    func playOrPause(){
        if self.playerCtrl.playButton?.isSelected ?? false{
            self.playerCtrl.playerEngine.pause()
        }else{
            self.playerCtrl.playerEngine.resume()
        }
    }
    
    
}

extension PRPoetryModuleViewController {
    func changeWordViewStyle(content: String, textStyle: PRPoetrySingleTextStyle){
        if textStyle == .title {
            for subArr in titleWordViewArr{
                for wordView in subArr{
                    if wordView.textInfo?.content == content{
                        
                        wordView.is_sel = true
                    }
                }
            }
        }
        if textStyle == .order {
            for subArr in orderWordViewArr{
                for wordView in subArr{
                    if wordView.textInfo?.content == content{
                        wordView.is_sel = true
                    }
                }
            }
        }
        if textStyle == .content {
            for sectionArr in contentWordViewArr{
                for subwordArr in sectionArr{
                    for wordView in subwordArr{
                        if wordView.textInfo?.content == content{
                            wordView.is_sel = true
                        }
                    }
                    
                }
            }
        }
    }
    func clearWordViewStatus(textData: PRPoetrySingleTextData){
        if textData.style == .title {
            for subArr in titleWordViewArr{
                for wordView in subArr{
                    
                    wordView.is_sel = false
                    
                }
            }
        }
        if textData.style == .order {
            for subArr in orderWordViewArr{
                for wordView in subArr{
                    
                    wordView.is_sel = false
                    
                }
            }
        }
        if textData.style == .content {

            for sectionArr in contentWordViewArr{
                for subwordArr in sectionArr{
                    for wordView in subwordArr{
                        
                        wordView.is_sel = false
                        
                    }
                    
                }
            }
        }
        
    }
    @objc func handleNoti(notification:NSNotification) {
        if let _ = self.view.window, self.isViewLoaded{
            
            let userinfo = notification.userInfo as![String:AnyObject]
            
            if let textInfo = userinfo["textInfo"] as? PRPoetryInfoWordModel {
                showTip(text: "", content: userinfo["content"] as! String, rect: userinfo["rect"] as! CGRect, textData: textInfo.textData)
                changeWordViewStyle(content: userinfo["content"] as! String, textStyle: textInfo.textData.style)
            }
            
        }else{
            print("PRPoetryModuleViewController当前不显示")
        }
       
        
    }
    func showTip(text: String, content: String, rect: CGRect, textData: PRPoetrySingleTextData) {
        
        var finWidth: CGFloat = content.pr_widthForComment(fontSize: 15, height: 20)
        var finHeight: CGFloat = 0.0
        if  finWidth > (WIDTH_SWIFT - 32.0 - 50.0 - 40) {
            //多行
            finWidth = (WIDTH_SWIFT - 32.0 - 50.0)
            
            finHeight = content.pr_heightForComment(fontSize: 15, width: (WIDTH_SWIFT - 32.0 - 50.0 - 40)) + 71.0
            
        }else{
            finWidth = finWidth + 42
            finHeight = 18 + 71
        }
        let tipView = PRPoetryShowTipView.init(frame: CGRect(x: 0, y: 0, width: Int(WIDTH_SWIFT), height: Int(finHeight)))
        tipView.finWidth = finWidth
        tipView.contentL.text = content
        tipView.positionH = rect.origin.x + 3
        let result = handlePosition(rect: CGRect(x: rect.origin.x, y: rect.origin.y, width: finWidth, height: finHeight))
        tipView.finX = result.point.x
        tipView.is_downward = result.is_downward
        let popview = LSTPopView.initWithCustomView(tipView, parentView: nil, popStyle: .fade, dismissStyle: .fade)
        popView_now = popview
        tipView.setNeedsLayout()
        tipView.layoutIfNeeded()
        popview?.hemStyle = .center
        popview?.popDuration = 0.25
        popview?.dismissDuration = 0.25
//        popview?.adjustX = result.point.x
        popview?.adjustY = result.point.y
        popview?.isClickBgDismiss = true
        popview?.bgAlpha = 0
        popview?.pop()
        popview?.popViewWillDismissBlock = {[weak self] in
            self?.clearWordViewStatus(textData: textData)
            self?.popView_now = nil
        }

    }
    func handlePosition(rect: CGRect) -> (point: CGPoint, is_downward: Bool){
        var is_downward = true
        var adjustX = rect.origin.x - WIDTH_SWIFT/2
        var adjustY = rect.origin.y - HEIGHT_SWIFT/2 - rect.size.height/2
        if adjustX > (WIDTH_SWIFT / 2) - rect.size.width/2 - 20{
            adjustX = (WIDTH_SWIFT / 2) - rect.size.width/2 - 20
            is_downward = true
        }
        if adjustX < rect.size.width/2 - (WIDTH_SWIFT / 2) + 20  {
            adjustX = rect.size.width/2 - (WIDTH_SWIFT / 2) + 20
            is_downward = true
        }
        
        
        if adjustY < -((HEIGHT_SWIFT / 2) - CGFloat(NavBarH_SWIFT) - rect.size.height/2){
            //下部
            adjustY += rect.size.height + 42 - 4 //42  单字高度
            is_downward = false
        }
        
        return (CGPoint(x: adjustX, y: adjustY), is_downward)
        
    }
}
