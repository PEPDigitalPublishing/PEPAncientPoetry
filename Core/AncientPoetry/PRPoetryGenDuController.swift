//
//  PRPoetryGenDuController.swift
//  PEPRead
//
//  Created by sunShine on 2024/1/26.
//  Copyright © 2024 PEP. All rights reserved.
//

import Foundation
import UIKit

enum currentAudioStatus: String{
    case kPoetryPlayAudioUnknown
    case kPoetryPlayOriginalAudio
    case kPoetryPlayUserAudio
}

class PRPoetryGenDuController : BaseAncientPoetryViewController {
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
    let punctuation = "，。！“”：卍[]（） ？；·"
    let tailPunctuation = "。！？"
    let otherPunctuation = "卍 "
    let contentPunctuation = "，。！“”：[]（）？；·"
    var style: poetryStyle = .Tangpoetry
    var bgImgUrl = ""
    var bookID = ""

    var infoData : PRPoetryInfoRootClass?
    var currentPoetryModel = PoetryModel()
    
    var titleWordViewArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
    var poetWordViewArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
    var orderWordViewArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
    var contentWordViewArr: Array<Array<Array<PRPoetrySingleTextView>>> = Array<Array<Array<PRPoetrySingleTextView>>>()
    
    
    var stardardPinYinArr = Array<PRPoetrySingleTextView>()
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bgImg: UIImageView!
    
    let audioPlayer = PRPoetryPlayer()
    
    var currentIndex = 0
    
    var downloadAudioArr: [String] = [String](){
        didSet{
            print("数据整合完毕,跟读")
            prepareMusic()
            
        }
    }
    var audioTimeIndex = 0
    var audioTimeArr = Array<PRPoetrySingleTextView>()
//    var wordsTimeArr = Array<PRPoetryReadTimeData>()
    var countdownTimer: PRPoetryCountdownTimer?
    
    var originIndex = 0
    var followIndex = 0
    
    var audioRecord = PRAudioRecord.init(audioFormatType: .linearPCM, sampleRate: 16000.0, channels: 0, bitsPerChannel: 16)
    var audioData:Data = Data()
    var mainPath: String? = "" //getDocumentsDirectoryFilePath
    let fileManager = FileManager.default
    var mp3FilePath = ""
    var userGenduPlaying = false
    var playAudioStatus: currentAudioStatus = .kPoetryPlayAudioUnknown
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var userAudioImg: UIImageView!
    
    @IBOutlet weak var userAudioImgBg: UIView!
    
    @IBOutlet weak var genduL: UILabel!
    
    @IBOutlet weak var genduBtn: UIButton!
    @IBOutlet weak var genduImg: UIImageView!
    
    @IBOutlet weak var waveFormView: UIView!
    
    var waveView: PRWaveFormView!
    
    var userID = ""
    
    var progressView = PRCircularProgressView()
    
    deinit {
            print("跟读页已销毁")
        }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance.init()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.theme
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        self.title = "跟读"
        self.removeScrollView = true
        configData()
        if bgImgUrl.count > 0{
            bgImg.kf.setImage(with: URL(string: bgImgUrl))
        }
        audioPlayer.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        //获取真实下载地址
        requestAudioUrl()
        
        audioRecord.delegate = self
        
        waveView = PRWaveFormView(frame: CGRect(x: 0 , y: 0, width: 250, height: 80))
        waveFormView.addSubview(waveView)
        
        if YSAudioUserManager.share().isLogin(){
            userID = YSAudioUserManager.share().getUserInfoModel().user_id
        }else{
            userID = "guest"
        }
        
        
        resultView.alpha = 0
        let mp3Path = currentPoetryModel.chapter_id + "_" + (userID) + "_gendu.mp3"
        let userRecord = checkMp3File(fileName: mp3Path)
        if userRecord.0 == true {
            resultView.alpha = 1
            mp3FilePath = userRecord.1
        }
        
        
        let frame = userAudioImg.frame
        progressView = PRCircularProgressView(frame: CGRect(x: frame.origin.x - 4, y: frame.origin.y - 4, width: 68, height: 68))
        progressView.lineColor = UIColor.init(hexString: "#FF8C9D")
        userAudioImgBg.insertSubview(progressView, belowSubview: userAudioImg)
        
        if let nav = self.navigationController as? BaseAncientPoetryNavigation{
            nav.navigationPopDelegate = self
            nav.isLimitPopGesture = true
        }
        
        
    }
    
   

    @IBAction func clickBtn(_ sender: Any) {
        
    }
    
    
    func prepareMusic(){
        let filePath = downloadAudioArr[0]
        audioPlayer.preloadAudio(from: URL(fileURLWithPath: filePath))
    }
    func playMusic() {
        let filePath = downloadAudioArr[0]
        print("路径--\(filePath)")
        audioPlayer.play(url: URL(fileURLWithPath: filePath))
        
    }
    
    
    
    @IBAction func seekTime(_ sender: Any) {
        
        audioPlayer.seek(to: sender as! TimeInterval)
    }
    
    @IBAction func clickPauseBtn(_ sender: Any) {
        audioPlayer.pause()
    }
    
    @IBAction func clickGenDuBtn(_ sender: UIButton) {
        audioRecord.requestPermission { granted in
            if !granted{
                return
            }else{
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else{return}
                    sender.isEnabled = false
                    if self.downloadAudioArr.count > 0{
                        self.playMusic()
                        self.playAudioStatus = .kPoetryPlayOriginalAudio
                    }else{
//                        showPEPToast("正在准备数据资源...")
                    }
                }
               
            }
        }
        
        
        
     
    }
    func changeToAudioPlaying(){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else{return}
            self.genduImg.image = UIImage(named: "pr_icon_poetry_GenduPerpare")
            self.genduL.text = "原声播放中，请准备"
            
        }
        
    }
    func changeToUserGendu(){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else{return}
            self.genduImg.image = UIImage(named: "pr_icon_poetry_GenduStart")
            self.genduL.text = "请跟读"
        }
       
    }
    
    @IBAction func resetGendu(_ sender: Any) {
        
        if userGenduPlaying{
            audioPlayer.stop()
            progressView.resetAnimation()
            userGenduPlaying = false
            userAudioImg.image = UIImage(named: "pr_icon_sdk_gsc_replay")
            
        }
        
        prepareMusic()
        audioTimeIndex = 0
      
        configData()
        
        self.resultView.alpha = 0
        playAudioStatus = .kPoetryPlayAudioUnknown
        
        
    }
    
    @IBAction func playUserGendu(_ sender: Any) {
        
        if userGenduPlaying{
            
            audioPlayer.pause()
            progressView.pauseAnimation()
            userGenduPlaying = false
            userAudioImg.image = UIImage(named: "pr_icon_sdk_gsc_replay")
        }else{
            if audioPlayer.isPaused() && playAudioStatus == .kPoetryPlayUserAudio{
                //复播
                audioPlayer.resume()
                progressView.resumeAnimation()
                userGenduPlaying = true
                userAudioImg.image = UIImage(named: "pr_icon_sdk_gsc_stop")
            }else{
                if fileManager.fileExists(atPath: mp3FilePath){
                    userGenduPlaying = true
                    audioPlayer.playOnly(url: URL(fileURLWithPath: mp3FilePath))
                    userAudioImg.image = UIImage(named: "pr_icon_sdk_gsc_stop")
                    playAudioStatus = .kPoetryPlayUserAudio
                }
            }
            
        }
        
    }
}
extension PRPoetryGenDuController{
    func handleTimeTag(){
        
        tagWordsTail()
        addTimeDataForWords()
        createAllWordsArr()
        calculatePunctuationTime()
        //找句号和叹号
        audioTimeArr.removeAll()
        for (i, view) in stardardPinYinArr.enumerated(){
            guard let info = view.textInfo else { continue }
            if info.rowTail {
                print("暂定点----->  " + info.str)
                audioTimeArr.append(view)
            }
        }
        
        //为了防止音频比标记时间短,不能触发录音,手动修改最后一条的数据
        if let view = audioTimeArr.last{
            if let timeData = view.textInfo?.wordTimeData{
                view.textInfo?.wordTimeData?.stopTime = timeData.contentEndTime + ((timeData.wordEndBehindTime - timeData.wordStartBehindTime)/2)
            }
//            timeData.contentEndTime = tempTimeData.wordStartBehindTime + ((tempTimeData.wordEndBehindTime - tempTimeData.wordStartBehindTime) / 2)
        }
        print("")
        //先整理 音频暂停点 标题  诗人  序和正文按照 rowTail
        
        //检测后一个字带标点,那么前一个字来处理 在拦截标点的位置去做
        
        //sort方法中把标点的时间给推算出来
        
        //动画推进的,for in strandwordArr
        
    }
    func tagWordsTail(){
        var tempTitleViewArr = Array<PRPoetrySingleTextView>()
        for sectionArr in titleWordViewArr {
            for view in sectionArr {
                guard let info = view.textInfo else { continue }
                view.textInfo?.rowTag = 1 //标题的rowTag 默认1
                if punctuation.contains(info.str){
                    continue
                }
                
                tempTitleViewArr.append(view)
            }
        }
    
        if let titleTagView = tempTitleViewArr.last {
            titleTagView.textInfo?.rowTail = true
        }
    
        if let poetTagView = poetWordViewArr.last {
            poetTagView.textInfo?.rowTail = true
        }
        
        //序
        var tempOrderAllViewArr = Array<PRPoetrySingleTextView>()
        for sectionArr in orderWordViewArr {
            for view in sectionArr {
                if otherPunctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                tempOrderAllViewArr.append(view)
            }
        }
        
        var tempOrderSectionView = Array<PRPoetrySingleTextView>()
        
        for view in tempOrderAllViewArr
        {
            guard let info = view.textInfo else { continue }
            
            if tailPunctuation.contains(info.str){
                if let last = tempOrderSectionView.last{
                    
                    last.textInfo?.rowTail = true
                    for view in tempOrderSectionView{
                        view.textInfo?.rowTag = info.wordTrueIndex //用断句的标点wordTrueIndex作为rowTag
                    }
                    view.textInfo?.rowTag = info.wordTrueIndex
                }
                tempOrderSectionView.removeAll()
                
                
                
            }else{
                tempOrderSectionView.append(view)
            }
            
        }
        print("")
        var tempContentAllViewArr = Array<PRPoetrySingleTextView>()
       
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
                    if otherPunctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    tempContentAllViewArr.append(view)
                }
            }
        }
        
        var tempContentSectionView = Array<PRPoetrySingleTextView>()
        
        for (index, view) in tempContentAllViewArr.enumerated()
        {
            guard let info = view.textInfo else { continue }
            if info.rowTag != 0{
                continue
            }
            if tailPunctuation.contains(info.str){
                if let last = tempContentSectionView.last{
                    
                    last.textInfo?.rowTail = true
                    for view in tempContentSectionView{
                        view.textInfo?.rowTag = info.wordTrueIndex //用断句的标点wordTrueIndex作为rowTag
                    }
                    view.textInfo?.rowTag = info.wordTrueIndex
                    //特殊处理  十五从军行 断句的标点后可能还会有一个标点
                    if (index + 1) < tempContentAllViewArr.count {
                        let nextView = tempContentAllViewArr[index + 1]
                        guard let nextInfo = nextView.textInfo else { continue }
                        if contentPunctuation.contains(nextInfo.str){
                            nextView.textInfo?.rowTag = info.wordTrueIndex
                        }
                        
                        
                    }
                }
                tempContentSectionView.removeAll()
                
                
            }else{
                tempContentSectionView.append(view)
            }
            
        }
        print("")
    }
    func addTimeDataForWords(){
        
        
        var needTimeDataTitleArr = Array<PRPoetrySingleTextView>()
        for sectionArr in titleWordViewArr {
            for view in sectionArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                needTimeDataTitleArr.append(view)
            }
        }
        
        //添加时间信息
        for (index, view) in needTimeDataTitleArr.enumerated(){
            if let timeUnit = infoData?.poem.title.nametime[index]{
                var timeData = PRPoetryReadTimeData()
                timeData.startTime = timeUnit.wordStartime
                timeData.stopTime = timeUnit.wordEndtime
                
                timeData.contentStartTime = timeUnit.contentStartime
                timeData.contentEndTime = timeUnit.contentEndtime
                
                timeData.wordStartHeadTime = timeUnit.eStartimeHead
                timeData.wordEndHeadTime = timeUnit.eEndtimeHead
                
                timeData.wordStartBehindTime = timeUnit.eStartimeBehind
                timeData.wordEndBehindTime = timeUnit.eEndtimeBehind
                view.textInfo?.wordTimeData = timeData
            }
        }
        var needTimeDataPoetArr = Array<PRPoetrySingleTextView>()
        for view in poetWordViewArr {
            
            if punctuation.contains(view.textInfo?.str ?? ""){
                continue
            }
            needTimeDataPoetArr.append(view)
        }
        //添加时间信息
        for (index, view) in needTimeDataPoetArr.enumerated(){
            if let timeUnit = infoData?.poem.poet.nametime[index]{
                var timeData = PRPoetryReadTimeData()
                timeData.startTime = timeUnit.wordStartime
                timeData.stopTime = timeUnit.wordEndtime
                
                timeData.contentStartTime = timeUnit.contentStartime
                timeData.contentEndTime = timeUnit.contentEndtime
                
                timeData.wordStartHeadTime = timeUnit.eStartimeHead
                timeData.wordEndHeadTime = timeUnit.eEndtimeHead
                
                timeData.wordStartBehindTime = timeUnit.eStartimeBehind
                timeData.wordEndBehindTime = timeUnit.eEndtimeBehind
                view.textInfo?.wordTimeData = timeData
            }
        }
        
        var needTimeDataOrderArr = Array<PRPoetrySingleTextView>()
        for sectionArr in orderWordViewArr {
            for view in sectionArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                needTimeDataOrderArr.append(view)

            }
        }
        //添加时间信息
        for (index, view) in needTimeDataOrderArr.enumerated(){
            if let timeUnit = infoData?.poem.content.first?.lableTime[index]{
                var timeData = PRPoetryReadTimeData()
                timeData.startTime = timeUnit.wordStartime
                timeData.stopTime = timeUnit.wordEndtime
                
                timeData.contentStartTime = timeUnit.contentStartime
                timeData.contentEndTime = timeUnit.contentEndtime
                
                timeData.wordStartHeadTime = timeUnit.eStartimeHead
                timeData.wordEndHeadTime = timeUnit.eEndtimeHead
                
                timeData.wordStartBehindTime = timeUnit.eStartimeBehind
                timeData.wordEndBehindTime = timeUnit.eEndtimeBehind
                view.textInfo?.wordTimeData = timeData
            }
        }
        
       
        //正文的文本全部叠加成一个数组,添加时间
        var contentTimeInfoArr = Array<PRPoetryInfoLableTime>()
        if let tempArr = infoData?.poem.content{
            for (index, tempContent) in tempArr.enumerated(){
                if infoData?.isorder ?? false {
                    //有序
                    if index == 0 {continue}
                    
                }
                contentTimeInfoArr += tempContent.lableTime
            }
        }
        
        var needTimeDataContentArr = Array<PRPoetrySingleTextView>()
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
            
                    if punctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    needTimeDataContentArr.append(view)
                }
            }
        }
        for (index, view) in needTimeDataContentArr.enumerated(){
            if contentTimeInfoArr.indices.contains(index){
                let timeUnit = contentTimeInfoArr[index]
                var timeData = PRPoetryReadTimeData()
                timeData.startTime = timeUnit.wordStartime
                timeData.stopTime = timeUnit.wordEndtime
                
                timeData.contentStartTime = timeUnit.contentStartime
                timeData.contentEndTime = timeUnit.contentEndtime
                
                timeData.wordStartHeadTime = timeUnit.eStartimeHead
                timeData.wordEndHeadTime = timeUnit.eEndtimeHead
                
                timeData.wordStartBehindTime = timeUnit.eStartimeBehind
                timeData.wordEndBehindTime = timeUnit.eEndtimeBehind
                view.textInfo?.wordTimeData = timeData
            }
            
        }
    
    }
    func createAllWordsArr(){
        stardardPinYinArr.removeAll()
        
        for sectionArr in titleWordViewArr {
            for view in sectionArr {
                
                if otherPunctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                stardardPinYinArr.append(view)
            }
        }
        for view in poetWordViewArr {
            
            if otherPunctuation.contains(view.textInfo?.str ?? ""){
                continue
            }
            stardardPinYinArr.append(view)
        }
        
        
        for sectionArr in orderWordViewArr {
            for view in sectionArr {
                
                if otherPunctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                stardardPinYinArr.append(view)

            }
        }
    
       
        
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
            
                    if otherPunctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    stardardPinYinArr.append(view)
                }
            }
        }
    
        
    }
    func calculatePunctuationTime(){
        for (i, view) in stardardPinYinArr.enumerated(){
            guard let info = view.textInfo else { continue }
            
            view.beisongStatus = .onlyShow
            view.textInfo?.serialNumber = i
            
            //如果是标点,去推算时间
            //预留一个index,originIndex 原文和跟读 followIndex
//            var previousView = PRPoetrySingleTextView()
//            var nextView = PRPoetrySingleTextView()
            
            if contentPunctuation.contains(info.str){

                if i == stardardPinYinArr.count - 1 {
                    //时间和最后一个字相同
                    var timeData = PRPoetryReadTimeData()
                    timeData.isPunctuation = true
                    
                    if let tempTimeData = stardardPinYinArr[i - 1].textInfo?.wordTimeData {
                        timeData.contentStartTime = tempTimeData.wordStartBehindTime
                        timeData.contentEndTime = tempTimeData.wordStartBehindTime + ((tempTimeData.wordEndBehindTime - tempTimeData.wordStartBehindTime) / 2)
                        timeData.wordEndBehindTime = timeData.contentEndTime
                    }
                    view.textInfo?.wordTimeData = timeData
                
                }
                else if i == 0 {
                    //时间和第一个字相同
                    var timeData = PRPoetryReadTimeData()
                    timeData.isPunctuation = true
                    if let tempTimeData = stardardPinYinArr[0].textInfo?.wordTimeData {
                        timeData.contentStartTime = tempTimeData.wordStartHeadTime
                        timeData.contentEndTime = tempTimeData.wordEndHeadTime
                        timeData.wordEndBehindTime = tempTimeData.wordEndBehindTime
                    }
                    view.textInfo?.wordTimeData = timeData
                }
                //中间 用前一个字 wordStartBehindTime == wordEndBehindTime默认标点0.25秒走完
                
                else{
                    var timeData = PRPoetryReadTimeData()
                    timeData.isPunctuation = true
                   
                    let lastView = stardardPinYinArr[i - 1]
                    
                    if let lastViewInfo = lastView.textInfo, lastViewInfo.rowTag == info.rowTag {
                        //同一句
//                        let nextView = stardardPinYinArr[i + 1]
//                        if let tempTimeData = lastView.textInfo?.wordTimeData {
//                            timeData.contentStartTime = tempTimeData.contentStartTime
//                            timeData.contentEndTime = tempTimeData.contentEndTime
//                            timeData.wordEndBehindTime = tempTimeData.contentEndTime
//                        }
                        if let tempTimeData = lastView.textInfo?.wordTimeData {
                            if tempTimeData.wordStartBehindTime == 0{
                                timeData.contentStartTime = tempTimeData.contentEndTime
                                timeData.contentEndTime = tempTimeData.contentEndTime
                                timeData.wordEndBehindTime = tempTimeData.contentEndTime
                            }else{
                                timeData.contentStartTime = tempTimeData.wordStartBehindTime
                                timeData.contentEndTime = tempTimeData.wordEndBehindTime
                                timeData.wordEndBehindTime = tempTimeData.wordEndBehindTime
                            }
                            
                        }
                    }else{
                        let nextView = stardardPinYinArr[i + 1]
                        if let tempTimeData = nextView.textInfo?.wordTimeData {
                            if tempTimeData.wordStartBehindTime == 0{
                                timeData.contentStartTime = tempTimeData.contentStartTime
                                timeData.contentEndTime = tempTimeData.contentStartTime
                                timeData.wordEndBehindTime = tempTimeData.contentStartTime
                            }else{
                                timeData.contentStartTime = tempTimeData.wordStartHeadTime + ((tempTimeData.wordEndHeadTime - tempTimeData.wordStartHeadTime) / 2)
                                timeData.contentEndTime = tempTimeData.wordEndHeadTime
                                timeData.wordEndBehindTime = tempTimeData.wordEndHeadTime
                            }
                            
                        }
                    }
                    
                   
                    view.textInfo?.wordTimeData = timeData
                }
                
                
            }
        }
    }
    func calculateWordsTime() -> Int{
        var time = 0
        if audioTimeIndex == 0{
            let view = audioTimeArr[audioTimeIndex]
            if let timeData = view.textInfo?.wordTimeData{
                time = timeData.wordEndBehindTime
            }
        }else{
            let previousView = audioTimeArr[audioTimeIndex - 1]
            let view = audioTimeArr[audioTimeIndex]
            if let timeData = view.textInfo?.wordTimeData, let previousTimeData = previousView.textInfo?.wordTimeData{
                time = timeData.wordEndBehindTime - previousTimeData.wordEndBehindTime
            }
        }
        print("LL-用户跟读时间限制--- " + String(time))
        return time
    }
    func calculateWordStartTime() -> Int{
        var time = 0
        if audioTimeIndex != 0{
            let previousView = audioTimeArr[audioTimeIndex - 1]
            
            if let previousTimeData = previousView.textInfo?.wordTimeData{
                time = previousTimeData.wordEndBehindTime
            }
        }
        print("LL-跟读倒计时-开始时间--- " + String(time))
        return time
    }
    
}

extension PRPoetryGenDuController{
    func requestAudioUrl(){
        showLoadingView()
        if let signedPath = currentPoetryModel.signedPath, signedPath.hasPrefix("http"){
            downloadAudioResouse()
            hideLoadingView()
        }else{
            if currentPoetryModel.path.count <= 0{return}
            let urlParams = ["file_name": currentPoetryModel.path as String, "flag": 1] as [String : Any]
           showLoadingView()
            Networking.postDic(with: URLString(with: .PR_API_poetryInfo), params: urlParams) { [weak self] response in
                self?.hideLoadingView()
                let dic = response as! [String: Any]
                if let url_signature = dic["url_signature"] as? String, url_signature.count > 0{
                    self?.currentPoetryModel.signedPath = url_signature
                    self?.downloadAudioResouse()
                }else{
//                    showPEPToast("音频资源请求异常")
                }
            } fail: { [weak self] error in
                self?.hideLoadingView()
//                showPEPToast("音频资源请求异常")
            }
        }
        
    }
    func downloadAudioResouse(){
        if let url = currentPoetryModel.signedPath {
            let arr = [url]
            showLoadingView()
            PRFileDownloadManager .downloadFile(arr) { [weak self]responseArr in
                self?.hideLoadingView()
                self?.downloadAudioArr = responseArr
            } fail: { [weak self] error in
                self?.hideLoadingView()
                print("")
            }
        }
        
    }
}
extension PRPoetryGenDuController: PRPoetryPlayerDelegate{
    func audioPlayerTimeControlStatusChanged(_ audioPlayer: AVPlayer, status: AVPlayer.TimeControlStatus) {
        if playAudioStatus == .kPoetryPlayUserAudio{
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
            
        }else{
            switch status {
                    case .paused:
                        changeToUserGendu()
                   
                    case .playing:
                        changeToAudioPlaying()
                    default:
                        break
                    }
        }
        
    }
    
    
   
    
    // 播放完成通知处理方法
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else {
            return
        }
        
        if self.isViewControllerVisible(self) && playerItem == audioPlayer.player?.currentItem {
            print("跟读音频播放完成")
            if playAudioStatus == .kPoetryPlayUserAudio{
                userGenduPlaying = false
                userAudioImg.image = UIImage(named: "pr_icon_sdk_gsc_replay")
                progressView.resetAnimation()
                playAudioStatus = .kPoetryPlayAudioUnknown
            }else{
                playAudioStatus = .kPoetryPlayAudioUnknown
            }
        }
    }
    
    func audioPlayer(_ audioPlayer: PRPoetryPlayer, didFailWithError error: Error?) {
            
    }
    //时间再不准,导致变色异常,可以试试音频预加载
    func audioPlayer(_ audioPlayer: PRPoetryPlayer, didUpdateProgress progress: Float, _ currentTime: Int) {
        if playAudioStatus == .kPoetryPlayUserAudio{return}
        
        //这里根据时间去做变色控制
        let tempTime = roundDown(currentTime)
        print("LL----时间戳--\(Int(tempTime))")
        for (_, subView) in stardardPinYinArr.enumerated(){
            guard let info = subView.textInfo else { continue }
            if info.wordTimeData?.contentStartTime == tempTime{
                if subView.genduStatus == .green {
                    return
                }
                subView.changeOriginWordColor()
                //变色中
            }else if info.wordTimeData?.contentEndTime == tempTime{
                //变色结束
//                CommonTools.printWithTimestamp("LL-变色-需要-结束")
            }
            
            
        }
        
        let view = audioTimeArr[audioTimeIndex]
        //没有执行最后一句的跟读是因为这个最后的时间没有处罚
        if tempTime == view.textInfo?.wordTimeData?.stopTime{
            if audioPlayer.player?.timeControlStatus == .playing{
                audioPlayer.pause()
                //然后开启定时器
                startUserReadCountdown()
            }
        }
        
    }
    func startUserReadCountdown(){
        let view = audioTimeArr[audioTimeIndex]
        
        if let timeData = view.textInfo?.wordTimeData{
            //计算上一句开始到结束的起始点,然后计算整个句子读的时间

            countdownTimer = PRPoetryCountdownTimer(countdown: timeData.wordEndBehindTime)
            CommonTools.printWithTimestamp("LL-用户倒计时 截止时间-- : \(timeData.wordEndBehindTime)")
            countdownTimer?.startTime = calculateWordStartTime()
            CommonTools.printWithTimestamp("LL-用户倒计时 statrTime-- : \(calculateWordStartTime())")
            countdownTimer?.callback = { [weak self]countdown in
                guard let self = self else { return }
                
                let tempTime = roundDown(countdown)
//                CommonTools.printWithTimestamp("LL-用户跟读--时间进度: \(tempTime)")
                
                for (_, subView) in stardardPinYinArr.enumerated(){
                    guard let info = subView.textInfo else { continue }
                    if info.wordTimeData?.contentStartTime == tempTime{
                        subView.changeGenduWordColor()
//                        CommonTools.printWithTimestamp("LL-用户跟读变色: \(tempTime)")
                        //变色中
                        
                    }else if info.wordTimeData?.contentEndTime == tempTime{
                        //变色结束
//                        CommonTools.printWithTimestamp("LL-用户跟读变色 -结束: \(tempTime)")
                        
                    }
                    
                    
                }
            }
            countdownTimer?.stopCallback = {[weak self] in
                guard let self = self else { return  }
                self.audioRecord.stop()
                print("用户跟读-结束后,播放声音")
                
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else{return}
                    self.waveView.resetVolumeBars()
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self.waveFormView.alpha = 0
                    })
                }
               
                
                //结束后,播放声音
                if self.audioTimeArr.indices.contains(self.audioTimeIndex + 1) {
                    self.audioTimeIndex += 1
                    //播放音频
                    self.audioPlayer.player?.play()
                }else{
                    //整合音频数据
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else{return}
                        self.saveGendu()
                        self.playAudioStatus = .kPoetryPlayAudioUnknown
                    }
                   
                    
                    print("结束")
                }
            }
            countdownTimer?.startWithAccumulation()
//            audioRecord.start(withFilePath: self.createNewFile(fileName: currentPoetryModel.chapter_id + "_gendu.wav"))
//            audioRecord.startRecord()
            audioRecord.startR()
            UIView.animate(withDuration: 0.2, animations: {
                
                self.waveFormView.alpha = 1
            })
        }
        
       
    }
    func changeWordText(view: PRPoetrySingleTextView){
        //根据rowtag,找当前句
        var wordArr = Array<PRPoetrySingleTextView>()
        for (_, subView) in stardardPinYinArr.enumerated(){
            guard let info = subView.textInfo else { continue }
            if view.textInfo?.rowTag == info.rowTag{
                //找当前句
                wordArr.append(subView)
                print("找到的当前句是--" + info.str)
            }
        }
        if wordArr.count > 0{
            //开启变色
//            for (_, subView) in wordArr.enumerated(){
//                guard let info = subView.textInfo else { continue }
//
//            }
            wordArr.first?.changeOriginWordColor()
            
        }
        
    }
    func roundDown(_ number: Int) -> Int {
        return number - (number % 10)
    }
}
extension PRPoetryGenDuController {
    func configData() {
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
        
        handleTimeTag()
    }
    
    func configTangpoetry(){
        
        let titleV = UIView.init()
        contentView.addSubview(titleV)
        titleV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(outerSpace)
            make.right.equalToSuperview().offset(-outerSpace)
        }
        //标题自带
        
        if let text = infoData?.poem.title.name{
            var textData = PRPoetrySingleTextData(style: .title, section: 1, row: 0, fontColor: "#000000", fontSize: 28.0, spacing: 2.0, poetryStyle: style)
            textData.showBottomLine = false
            
            let vStackView = PRPoetryVStackView.init(style: textData)
            titleV.addSubview(vStackView)
            vStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                
            }
            
            let annotion: [PRPoetryInfoAnnotation] = infoData?.poem.title.annotation ?? []
            let arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
            var wordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()

            for (index, strArr) in arr.enumerated(){
                
                let titleS = PRPoetryHStackView.init(styleData: textData)
                vStackView.addArrangedSubview(titleS)
                var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()

                for (subIndex, var info) in strArr.enumerated(){
                    info.section = index + 1
                    info.row = subIndex + 1
                    let wordView = PRPoetrySingleTextView.init(textInfo: info, data: textData)
                    subWordArr.append(wordView)

                    titleS.addArrangedSubview(wordView)

                }
                wordArr.append(subWordArr)

            }
            titleWordViewArr = wordArr

        }
        
        
        let poetV = UIView.init()
        poetV.backgroundColor = .clear
        contentView.addSubview(poetV)
        poetV.snp.makeConstraints { make in
            make.top.equalTo(titleV.snp_bottom).offset(0)
            make.left.equalToSuperview().offset(outerSpace)
            make.right.equalToSuperview().offset(-outerSpace)
        }
        var poetTextData = PRPoetrySingleTextData(style: .poet, section: 2, row: 0, fontColor: "#666666", fontSize: 18, spacing: 1.0, poetryStyle: style)
        poetTextData.showBottomLine = false
        let poetS = PRPoetryHStackView.init(styleData: poetTextData)
        poetV.addSubview(poetS)
        
        if let text = infoData?.poem.poet.name, text.count > 0{
            poetS.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            var poetArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
            for (index, str) in text.enumerated(){
               
                var temp: PRPoetryInfoWordModel =  PRPoetryInfoWordModel(textData: poetTextData, content: "", position: .single, str: String(str))
                temp.row = index + 1
                temp.section = 1
                let wordView = PRPoetrySingleTextView.init(textInfo: temp, data: poetTextData)
                
                poetS.addArrangedSubview(wordView)
                wordView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(0)
                    make.bottom.equalToSuperview()
                }
                poetArr.append(wordView)
            }
            poetWordViewArr = poetArr
            
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
                make.bottom.lessThanOrEqualToSuperview().offset(-50)
            }
            var textData = PRPoetrySingleTextData(style: .content, section: 0, row: 0, fontColor: "#212121", fontSize: 24, spacing: 4, poetryStyle: style)
            textData.showBottomLine = false
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
                    for (index, strArr) in arr.enumerated(){
    
                        let contentS = PRPoetryHStackView.init(styleData: textData)
                        vStackView.addArrangedSubview(contentS)
                        var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
                        //从这里,把时间的值塞到view.info.timeData中
                        
                        for (subIndex, var info) in strArr.enumerated(){
                            info.section = index + 1
                            info.row = subIndex + 1
                            info.textPart = contentNum + 1
                            
                            let wordView = PRPoetrySingleTextView.init(textInfo: info, data: textData)
                            subWordArr.append(wordView)
                            contentS.addArrangedSubview(wordView)
    
                        }
                        sectionWordArr.append(subWordArr)
                        var tempBlankRow = false
                        if style == .QinYuanChunXue{
                            for tempSubStr in strArr{
                                if tempSubStr.str == "滔"{
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
            var textData = PRPoetrySingleTextData(style: .title, section: 1, row: 0, fontColor: "#000000", fontSize: 28.0, spacing: 2.0, poetryStyle: style)
            textData.showBottomLine = false
            let vStackView = PRPoetryVStackView.init(style: textData)
            titleV.addSubview(vStackView)
            vStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                
            }
            let annotion: [PRPoetryInfoAnnotation] = infoData?.poem.title.annotation ?? []
            let arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
            var wordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
            for (index, strArr) in arr.enumerated(){
                
                let titleS = PRPoetryHStackView.init(styleData: textData)
                vStackView.addArrangedSubview(titleS)
                var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()

                for (subIndex, var info) in strArr.enumerated(){
                    info.section = index + 1
                    info.row = subIndex + 1
                    let wordView = PRPoetrySingleTextView.init(textInfo: info, data: textData)
                    subWordArr.append(wordView)

                    titleS.addArrangedSubview(wordView)

                }
                wordArr.append(subWordArr)


            }
            titleWordViewArr = wordArr

        }
        
        
        let poetV = UIView.init()
        poetV.backgroundColor = .clear
        contentView.addSubview(poetV)
        poetV.snp.makeConstraints { make in
            make.top.equalTo(titleV.snp_bottom).offset(0)
            make.left.equalToSuperview().offset(outerSpace)
            make.right.equalToSuperview().offset(-outerSpace)
        }
        var poetTextData = PRPoetrySingleTextData(style: .poet, section: 0, row: 0, fontColor: "#666666", fontSize: 18, spacing: 1.0, poetryStyle: style)
        poetTextData.showBottomLine = false
        let poetS = PRPoetryHStackView.init(styleData: poetTextData)
        poetV.addSubview(poetS)
        poetS.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        if let text = infoData?.poem.poet.name, text.count > 0{
            var poetArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
            for (index, str) in text.enumerated(){
                
                var temp: PRPoetryInfoWordModel =  PRPoetryInfoWordModel(textData: poetTextData, content: "", position: .single, str: String(str))
                temp.row = index + 1
                temp.section = 1
                let wordView = PRPoetrySingleTextView.init(textInfo: temp, data: poetTextData)
                poetS.addArrangedSubview(wordView)
                wordView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(22)
                    make.bottom.equalToSuperview()
                }
                poetArr.append(wordView)
            }
            poetWordViewArr = poetArr
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
            var textData = PRPoetrySingleTextData(style: .order, section: 0, row: 0, fontColor: "#888888", fontSize: 20, spacing: 4, poetryStyle: style)
            textData.showBottomLine = false
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

                for (index, strArr) in arr.enumerated(){

                    let contentS = PRPoetryHStackView.init(styleData: textData)
                    vStackView.addArrangedSubview(contentS)
                    var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
                    
                    for (subIndex, var info) in strArr.enumerated(){
                        info.textPart = 1
                        info.section = index + 1
                        info.row = subIndex + 1
                        let wordView = PRPoetrySingleTextView.init(textInfo: info, data: textData)
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
                make.bottom.lessThanOrEqualToSuperview().offset(-20)
            }
            var textData = PRPoetrySingleTextData(style: .content, section: 1, row: 0, fontColor: "#212121", fontSize: 24, spacing: 4, poetryStyle: style)
            textData.showBottomLine = false
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
                    
                    for (index, strArr) in arr.enumerated(){
    
                        let contentS = PRPoetryHStackView.init(styleData: textData)
                        vStackView.addArrangedSubview(contentS)
                        var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()

                        var tempIndex = 0
                        for (subIndex, var info) in strArr.enumerated(){
                            info.section = index + 1
                            info.row = subIndex + 1
                            info.textPart = contentNum + 1
                            
                            let wordView = PRPoetrySingleTextView.init(textInfo: info, data: textData)
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
extension PRPoetryGenDuController{
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
            //行路难 特殊处理
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
                var startIndex = (line - 1) * wordNums
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
extension PRPoetryGenDuController: PRAudioRecordDelegate{
    func audioRecorderRealTimeVolume(_ volume: Double) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
           
            self.waveView.updateVolumeBars(newVolume: Float(volume))
            
        }
    }

    
   
    func audioRecorderDidReceive(_ audioData: Data) {
        self.audioData.append(audioData)
        
        
    }
    
    func changeUI(){
        
    }

    func saveGendu(){
        self.genduBtn.isEnabled = true
        
        
        
        let filePath = self.createNewFile(fileName: currentPoetryModel.chapter_id + "__gendu.wav")
        let mp3Path = self.createNewFile(fileName: currentPoetryModel.chapter_id + "_" + userID + "_gendu.mp3")
        
        do {
                // 写入文件
            try self.audioData.write(to: NSURL.fileURL(withPath: filePath), options: .atomic)
                print("文件写入成功---\(filePath)")
                self.audioData = Data()
                audioRecord.convertToMp3(withWavpath: filePath, toMp3path: mp3Path)
                mp3FilePath = mp3Path
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                
                self.resultView.alpha = 1
                
            }
            
            } catch {
                
            }

    }
    func checkMp3File(fileName: String) -> (Bool, String){
        guard let path = mainPath else { return (false, "") }
        let filePath = path + "/" + fileName
        if fileManager.fileExists(atPath: filePath){
            return (true, filePath)
        }else{
            return (false, "")
        }
    }
    func createNewFile(fileName: String) -> String{
        guard let path = mainPath else { return "" }
        let filePath = path + "/" + fileName
        //如果文件存在就删除
        if fileManager.fileExists(atPath: filePath){
            do {
                    // 删除文件
                    try fileManager.removeItem(atPath: filePath)
                    print("文件删除成功")
                    return filePath
                } catch {
                    print("删除文件失败: \(error)")
                    return ""
                }
        }else{
            return filePath
        }
        
    }
}
extension PRPoetryGenDuController: PCNavigationControllerPopDelegate{
   
    func navigationBarShouldPopViewController(_ nvigationController: UINavigationController!, onBackBarButtonAction backBarButtonItem: UIBarButtonItem!) {
        if playAudioStatus == .kPoetryPlayOriginalAudio{
            
            showAlert(on: self)
        }else{
            if let nav = self.navigationController{
                nav.popViewController(animated: true)
            }
        }
    }
    

    func showAlert(on viewController: UIViewController) {
        // 创建 UIAlertController
        let alertController = UIAlertController(title: nil, message: "跟读进行中，确认退出吗？", preferredStyle: .alert)
        
        // 创建 "确认" 按钮
        let confirmAction = UIAlertAction(title: "确认", style: .destructive) { _ in
            // 处理确认操作
            if let nav = self.navigationController{
                nav.popViewController(animated: true)
            }
        }
        
        // 创建 "继续跟读" 按钮
        let continueAction = UIAlertAction(title: "继续跟读", style: .cancel) { _ in
            // 处理继续跟读操作
            
            // 例如，执行继续跟读操作的代码
        }
        
        // 将按钮添加到 UIAlertController
        alertController.addAction(confirmAction)
        alertController.addAction(continueAction)
        
        // 显示弹窗
        viewController.present(alertController, animated: true, completion: nil)
    }

   
    func getDocumentsDirectoryFilePath(fileName: String) -> String {
        // 获取应用的 Documents 目录
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        // 创建完整的文件路径
        let filePath = documentsDirectory.appendingPathComponent(fileName)
        
        return filePath.path
    }
}

