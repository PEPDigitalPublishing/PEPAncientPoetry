//
//  PRPoetrysBeiSongController.swift
//  PEPRead
//
//  Created by sunShine on 2024/2/23.
//  Copyright © 2024 PEP. All rights reserved.
//

import Foundation
import SwiftyJSON
import Dispatch
import AVFoundation
import Kingfisher
import Spring

enum soundToTextStatus{
    case soundToTextUnknow, soundToTexting, soundToTextSuccess
}



class PRPoetrysBeiSongController : BaseAncientPoetryViewController {
    
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

    
    var style: poetryStyle = .Tangpoetry
    var bgImgUrl = ""
    var bookID = ""

    var infoData : PRPoetryInfoRootClass?
    var currentPoetryModel = PoetryModel()
    
    var titleWordViewArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
    var poetWordViewArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
    var orderWordViewArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
    var contentWordViewArr: Array<Array<Array<PRPoetrySingleTextView>>> = Array<Array<Array<PRPoetrySingleTextView>>>()

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bgImg: UIImageView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!

    
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var startBtnImg: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var promptLabel: UILabel!
    
    
    @IBOutlet weak var countDownView: UIView!
    @IBOutlet weak var countDownLabel: UILabel!
    var waveView: PRWaveFormView!
    @IBOutlet weak var waveFormBgView: UIView!
    
    @IBOutlet weak var poetryScrollview: UIScrollView!
    
    
    @IBOutlet weak var promptImg: UIImageView!
    @IBOutlet weak var promptView: UIView!
    
    @IBOutlet weak var promptBtn: UIButton!
    var mainPath: String? = "" //getDocumentsDirectoryFilePath
    
    var audioData:Data = Data()
    
//    var isRecording = false{
//        didSet{
//            if isRecording {
//                self.connectBtn("")
//            }
//        }
//    }
    
    lazy var socketManager = PRPoetrySocketManager()
    
    var progressView = PRCircularProgressView()
    
    var currentPosition: Int = 0
    
    let chunkSize: Int = 1280
    
    let chunkInterval: TimeInterval = 0.04
    
    // 创建一个全局队列
    let queue = DispatchQueue.global()

    // 创建一个定时器
    var timer: DispatchSourceTimer?
    
    let interval = DispatchTimeInterval.milliseconds(40)
    
    // 创建音频播放器
    var audioPlayer: AVAudioPlayer?
    
    var tempText = ""
    
    var stardardPinYinArr = Array<PRPoetrySingleTextView>()
    
    var matePinYinArr = Array<PRPoetrySingleTextView>()

    
    var lastTempResult = ""
    
    var oText = ""
    
    var recitationProgress = 0{
        didSet{
            
        }
    }
    
    var recitationProgressView = PRPoetrySingleTextView()
    
    //当前语音转文字状态    0 1
    var sttStatus: soundToTextStatus = .soundToTextUnknow
    
    var audioRecord = PRAudioRecord.init(audioFormatType: .linearPCM, sampleRate: 16000.0, channels: 0, bitsPerChannel: 16)
    
    
    let fileManager = FileManager.default
    var countdownTimer: PRPoetryCountdownTimer?
    var openingUITimer: PRPoetryCountdownTimer?
    var promptViewTimer: PRPoetryCountdownTimer?
    var promptViewArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
    var currentMateSN = -1 {
        didSet{
            
            let oldValue = oldValue
            if currentMateSN != -1 && currentMateSN > oldValue{ //并且是背诵状态下
                self.flashCursor()
            }
        }
    }
    var previousFlashView = PRPoetrySingleTextView(){
        didSet{
            //如果正在提示,并且当前闪动点大于提示的最大值,结束提示状态
            print("测试用例---当前闪动的是--\(String(describing: previousFlashView.textInfo?.str))")
            if let promptLastView = promptViewArr.last{
                if let cSN = previousFlashView.textInfo?.serialNumber, let pSN = promptLastView.textInfo?.serialNumber {
                    if cSN > pSN {
                        promptViewTimer?.stop()
                        self.promptBtn.isUserInteractionEnabled = true
                        self.promptViewArr.removeAll()
                        promptImg.image = UIImage(named: "pr_icon_poetry_prompt")
                        
                        print("测试用例--当前闪动超过提示-------\(String(describing: promptLastView.textInfo?.str))")
                    }
                }
            }
        }
    }

    let modeStatus = PRUserDefaultManager.shareInstance().getBeisongStatus() //展示前半句
    let punctuation = "，。！“”：卍[]（） ？；·"
    let tailPunctuation = "，。！？；"
    var resetModel = false
    
    deinit{
        print("背诵页面关闭")
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
        
    
        if let nav = self.navigationController as? BaseAncientPoetryNavigation{
            nav.navigationPopDelegate = self
            nav.isLimitPopGesture = true
        }
        if self.resetModel{
            self.resetModel = false
            return
        }
        checkUserLastGrade()
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //关闭socket和录音器
    }
    override func viewDidLoad() {
        self.removeScrollView = true
        segmentControl.selectedSegmentIndex = Int(PRUserDefaultManager.shareInstance().getBeisongConfig())
        configUI()
        audioRecord.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleRetry), name: .PRPoetryRetryBeisong, object: nil)
        
        
        
        let frame = startBtnImg.frame
        progressView = PRCircularProgressView(frame: CGRect(x: frame.origin.x - 4 , y: frame.origin.y - 4 , width: 68, height: 68))
        bgView.insertSubview(progressView, belowSubview: startBtnImg)
        
        waveView = PRWaveFormView(frame: CGRect(x: 0 , y: 0, width: 250, height: 80))
        waveFormBgView.addSubview(waveView)
        
    }
    func checkUserLastGrade(){
        let lastScore = 0
        if lastScore >= 0{
            let audioPath =  self.jointPath(fileName: currentPoetryModel.chapter_id + ".mp3")
            //章节+ 诗id 作为key,存贮到本地
            let key = currentPoetryModel.chapter_id + "poetryPictureKey"
            let cache = ImageCache.default
            if cache.isCached(forKey: key) &&  fileManager.fileExists(atPath: audioPath){
                
                let storyBoard = UIStoryboard(name: "PRPoetrysBeiSongResultController", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PRPoetrysBeiSongResultController") as! PRPoetrysBeiSongResultController
                vc.score =  Int(lastScore)
                vc.bgImgUrl = self.currentPoetryModel.bgImgUrl
                vc.currentPoetryModel = self.currentPoetryModel
                vc.audioPath =  audioPath
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
            }
        }
        
    }
    @objc func handleRetry(){
        self.resetModel = true
        if segmentControl.selectedSegmentIndex == 0{
            sortoutWordsWithModeTwo()
        }
        if segmentControl.selectedSegmentIndex == 1{
            sortoutWordsWithModeOne()
        }
        if segmentControl.selectedSegmentIndex == 2{
            //无字
            sortoutWords()
        }
        
    }
    func configUI(){
        self.title = "背诵"
        let normalAttributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#333333"),
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)
                ]
        let selectAttributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#2BBE93"),
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
                ]
        segmentControl.setTitleTextAttributes(normalAttributes, for: .normal)
        
        segmentControl.setTitleTextAttributes(selectAttributes, for: .selected)

        configData()
        if bgImgUrl.count > 0{
            bgImg.kf.setImage(with: URL(string: bgImgUrl))
        }
    }
    @IBAction func clickSegmentControl(_ sender: UISegmentedControl) {
        if audioRecord.isRecording {return}
        recitationProgress = 0
        recitationProgressView = PRPoetrySingleTextView()
        PRUserDefaultManager.shareInstance().setBeisongConfig(Int32(sender.selectedSegmentIndex))
        if sender.selectedSegmentIndex == 0{
            sortoutWordsWithModeTwo()
        }
        if sender.selectedSegmentIndex == 1{
            sortoutWordsWithModeOne()
        }
        if sender.selectedSegmentIndex == 2{
            sortoutWords()
        }
    }
    
    @IBAction func clickPromptBtn(_ sender: Any) {
        promptBtn.isUserInteractionEnabled = false
        promptImg.image = UIImage(named: "pr_icon_poetry_prompted")
//        findCurrentWords()
        findWords()
        
    }
    
    @IBAction func clickStartBeisong(_ sender: UIButton) {
        if startBtn.isSelected{
            self.countdownTimer?.stop()
            return
        }
        
        
        audioRecord.requestPermission { granted in
            if !granted{
                return
            }else{
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else{return}
                    self.openingAnimation()
                    
                }
               
            }
        }
        
        
    }
    func openingAnimation(){
        segmentControl.isUserInteractionEnabled = false
        startBtn.isSelected = true  //背诵状态
        promptLabel.text = "做好准备"
        
        countDownView.alpha = 1
        openingUITimer = PRPoetryCountdownTimer(countdown: 1000 * 3)
        openingUITimer?.customTimeInterval = .milliseconds(1000)
        openingUITimer?.callback = {[weak self] countdown in
            guard let self = self else { return }
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.countDownLabel.text = String(countdown/1000)
            }
           
        }
        openingUITimer?.stopCallback = {[weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                
                self.startBeisong()
            }
        }
        openingUITimer?.startWithSeconds()
    }
    func resetBeisong(){
        recitationProgress = 0
        recitationProgressView = PRPoetrySingleTextView()
        self.currentMateSN = -1
        
        self.promptLabel.text = "点击背诵"
        self.progressView.resetAnimation()
        
        self.segmentControl.isUserInteractionEnabled = true
        self.startBtn.isSelected = false
        promptBtn.isUserInteractionEnabled = true
        promptImg.image = UIImage(named: "pr_icon_poetry_prompt")
        
        promptViewArr.removeAll()
        previousFlashView = PRPoetrySingleTextView()
        
    }
    func startBeisong(){
        promptView.alpha = 1
        currentMateSN = 0
        promptLabel.text = "背诵中"
        currentPosition = 0
        
        countDownView.alpha = 0
        
        audioData = Data()
        audioRecord.start(withFilePath: self.createNewFile(fileName: currentPoetryModel.chapter_id + "_temp.wav"))
        socketManager.delegate = self
        socketManager.openWebSocket()
        self.configTimer()
        
        countdownTimer = PRPoetryCountdownTimer(countdown: 1200 * stardardPinYinArr.count )
        countdownTimer?.callback = { countdown in
//            print("倒计时--\(String(countdown))")
        }
        countdownTimer?.stopCallback = {[weak self] in
            guard let self = self else { return }
            self.audioRecord.stop()
            
            DispatchQueue.main.async {[weak self] in
                guard let self = self else{return}
                self.waveView.resetVolumeBars()
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.waveFormBgView.alpha = 0
                    self.promptView.alpha = 0
                })
//                showPEPToast("正在计算分数...")
                
            }
            
            
        }
        
        progressView.startAnimation(duration: TimeInterval(Double(stardardPinYinArr.count) * 1.2))

        countdownTimer?.start()
        UIView.animate(withDuration: 0.2, animations: {
            
            self.waveFormBgView.alpha = 1
        })
        
    }
    
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
        tagWordsTail()
        if segmentControl.selectedSegmentIndex == 0{
            sortoutWordsWithModeTwo()
        }
        if segmentControl.selectedSegmentIndex == 1{
            sortoutWordsWithModeOne()
        }
        if segmentControl.selectedSegmentIndex == 2{
            sortoutWords()
        }
        
    }
}
extension PRPoetrysBeiSongController{
    func findWords(){
        
        if let currentInfo = self.previousFlashView.textInfo{
            for (i, view) in stardardPinYinArr.enumerated(){
                if let mateInfo = view.textInfo {
                    if mateInfo.rowTag  == currentInfo.rowTag{
                        if view.beisongStatus == .prepare{
                            view.beisongStatus = .beisongPrompt
                            promptViewArr.append(view)
                        }
                        
                    }
                    
                }
            }
            if promptViewArr.count <= 0{
                promptBtn.isUserInteractionEnabled = true
                promptImg.image = UIImage(named: "pr_icon_poetry_prompt")
                return
            }
            //准备倒计时5秒 ,5秒后还原
            promptViewTimer = PRPoetryCountdownTimer(countdown: 1000 * 5)
            promptViewTimer?.customTimeInterval = .milliseconds(1000)
            promptViewTimer?.stopCallback = {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else { return }
                    for (_, view) in self.promptViewArr.enumerated(){
                        if view.beisongStatus == .beisongPrompt{
                            view.beisongStatus = .prepare
                        }
                    }
                    self.promptBtn.isUserInteractionEnabled = true
                    self.promptViewArr.removeAll()
                    promptImg.image = UIImage(named: "pr_icon_poetry_prompt")
                }
            }
            promptViewTimer?.startWithSeconds()
            
            
        }
        
        
    }
    func findCurrentWords(){
        if segmentControl.selectedSegmentIndex == 0{
            //隔句
            if recitationProgress == 0{
                //找题目
                
                var status =  modeStatus//展示前半句
                
                if status{
                    
                    _ = findTextFirstViewWithStyle(style: .title)
                }else{
                    
                    _ = findTextFirstViewWithStyle(style: .poet)
                }
                
            }else{
                if let info = recitationProgressView.textInfo {
                    if info.rowTail{//行尾,切换行
                        if info.textData.style == .title{
                            //找第一个字
                            
                            if poetWordViewArr.count <= 0{
                                //如果没有作者
                                if infoData?.isorder ?? false {
                                   //序
                                     _ = findTextFirstViewWithStyle(style: .order)
            
                                }else{
                                    //正文
                                     _ = findTextFirstViewWithStyle(style: .content)
                                }
                            }else{
                                let result = findTextFirstViewWithStyle(style: .poet)
                                if result.0 == false {
                                    if infoData?.isorder ?? false {
                                       //序
                                         _ = findTextFirstViewWithStyle(style: .order)
                
                                    }else{
                                        //正文
                                         _ = findTextFirstViewWithStyle(style: .content)
                                    }
                                }
                            }
                           
                            
                            
                            
                        }else if info.textData.style == .poet{
                            //判断有没有序
                            if infoData?.isorder ?? false {
                               //序
                                if findTextFirstViewWithStyle(style: .order).0 == false {
                                    //找下一句
                                    _ = findNextWords(currentView: findTextFirstViewWithStyle(style: .order).1)
                                }
                                
        
                            }else{
                                //正文
                                if findTextFirstViewWithStyle(style: .content).0 == false {
                                    //找下一句
                                    _ = findNextWords(currentView: findTextFirstViewWithStyle(style: .content).1)
                                }
                                 
                            }
                            
                        }else if info.textData.style == .order{
                           
                            if !findNextWords(currentView: recitationProgressView){//序中
                                //切到正文
                                if findTextFirstViewWithStyle(style: .content).0 == false {
                                    //找下一句
                                    _ = findNextWords(currentView: findTextFirstViewWithStyle(style: .content).1)
                                }
                            }
                            
                            
                        }
                        else{
                            //正文的下一句
                            print("测试用例--当前点击提示--当前字\(recitationProgressView.textInfo?.str)")
                            _ = findNextWords(currentView: recitationProgressView)
                        }
                    }else{
                        //当前行,行中
                        if recitationProgressView.beisongStatus != .onlyShow{
                            changeTextStatus(firstView: recitationProgressView)
                        }
                        
                    }
                    
                }
            }
            
        }
        else if segmentControl.selectedSegmentIndex == 1{
            //首字 句尾需要注意
            if recitationProgress == 0{
                //找题目
                if let firstView = stardardPinYinArr.first {
                    changeTextStatus(firstView: firstView)
                }
                
                
            }else{
                if let info = recitationProgressView.textInfo {
                    if info.rowTail{//行尾,切换行
                        if info.textData.style == .title{
                            var firstView: (Bool, PRPoetrySingleTextView)
                            if poetWordViewArr.count <= 0{
                                //如果没有作者
                                if infoData?.isorder ?? false {
                                    //序
                                    firstView = findTextFirstViewWithStyle(style: .order)
                                    

                                }else{
                                    //正文
                                    firstView = findTextFirstViewWithStyle(style: .content)
                                    
                                }
                            }else{
                                //找第一个字肯定是only,然后找第二个字
                                firstView = findTextFirstViewWithStyle(style: .poet)
                            
                            }
                            if !firstView.0 {
                                _ = findNextWord(currentView:firstView.1)//改色
                              
                            }
                            
                        }else if info.textData.style == .poet{
                            var firstView: (Bool, PRPoetrySingleTextView)
                            //判断有没有序
                            if infoData?.isorder ?? false {
                               //序
                                firstView = findTextFirstViewWithStyle(style: .order)
                                
                            }else{
                                //正文
                                firstView = findTextFirstViewWithStyle(style: .content)
                                 
                            }
                            if !firstView.0 {
                                _ = findNextWord(currentView:firstView.1)//改色
                              
                            }
                            
                        }else if info.textData.style == .order{
                           
                            if !findNextWords(currentView: recitationProgressView){//序中
                                //切到正文
                                if findTextFirstViewWithStyle(style: .content).0 == false {
                                    //句首,找下一个字
                                    _ = findNextWord(currentView: findTextFirstViewWithStyle(style: .content).1)
                                }
                            }
                            
                            
                        }
                        else{
                            //正文的下一句
                            _ = findNextWords(currentView: recitationProgressView)
                        }
                    }else{
                        //当前行,行中
                        changeTextStatus(firstView: recitationProgressView)
                    }
                    
                }
            }
        }
        else if segmentControl.selectedSegmentIndex == 2{
            if recitationProgress == 0{
                //找题目
                if let firstView = stardardPinYinArr.first {
                    changeTextStatus(firstView: firstView)
                }
                
            }else{
                if let info = recitationProgressView.textInfo {
                    if info.rowTail{//行尾,切换行
                        if info.textData.style == .title{
                            //找第一个字
                            if poetWordViewArr.count <= 0{
                                //如果没有作者
                                if infoData?.isorder ?? false {
                                   //序
                                     _ = findTextFirstViewWithStyle(style: .order)
            
                                }else{
                                    //正文
                                     _ = findTextFirstViewWithStyle(style: .content)
                                }
                            }else{
                                _ = findTextFirstViewWithStyle(style: .poet)
                                
                            }
                           
                        }else if info.textData.style == .poet{
                            //判断有没有序
                            if infoData?.isorder ?? false {
                               //序
                                _ = findTextFirstViewWithStyle(style: .order)
                                
                            }else{
                                //正文
                                _ =  findTextFirstViewWithStyle(style: .content)
                                 
                            }
                            
                        }else if info.textData.style == .order{
                            //尝试找序,下一句序
                           let resultOne = findNextWords(currentView: recitationProgressView)
                            
                            if !resultOne{
                                //切到正文
                                _ = findTextFirstViewWithStyle(style: .content)
                            }
                            
                            
                        }
                        else{
                            //正文的下一句
                            _ = findNextWords(currentView: recitationProgressView)
                        }
                    }else{
                        //当前行,行中
                        changeTextStatus(firstView: recitationProgressView)
                    }
                    
                }
            }
        }
        
        
        
        
    }
    func findTextFirstViewWithStyle(style: PRPoetrySingleTextStyle) ->(Bool, PRPoetrySingleTextView) {
        //正文
        //找第一个字
         var firstView = PRPoetrySingleTextView()
         for (i, view) in stardardPinYinArr.enumerated(){
             if let mateInfo = view.textInfo {
                 if mateInfo.textData.style == style{
                     firstView = view
                     break
                 }
                 
             }
         }
        
        if firstView.beisongStatus == .onlyShow{
            return (false, firstView)
        }else{
            changeTextStatus(firstView: firstView)
            return (true, firstView)
        }
        
        
        
    }
    //根据当前view,找下一个字的view
    func findNextWord(currentView: PRPoetrySingleTextView) -> (Bool, PRPoetrySingleTextView){
        var isFind = false
        var nextView = PRPoetrySingleTextView()
        if let info = currentView.textInfo {
            var section = info.section
            let textPart = info.textPart
            let row = info.row + 1
            
            for (i, view) in stardardPinYinArr.enumerated(){
                if let mateInfo = view.textInfo {
                    if mateInfo.textData.style == info.textData.style && textPart == mateInfo.textPart && section == mateInfo.section && row == mateInfo.row{
                        isFind = true
                        nextView = view
                        break
                    }
                }
            }
            
        }
        if isFind {
            changeTextStatus(firstView: nextView)
            return (isFind, nextView)
        }else{
            return (isFind, currentView)
        }
    }
    //同style,句前句中找下句
    
    
    //同style,句尾找下句
    func findNextWords(currentView: PRPoetrySingleTextView) -> Bool{
        var isFind = false
        var rowTag = 0
        
        var nextView = PRPoetrySingleTextView()
        if let info = currentView.textInfo {
            rowTag = info.rowTag
            //直接找下一个字,然后变色
            var lastWordInfo: PRPoetryInfoWordModel?
            for (i, view) in stardardPinYinArr.enumerated(){
                if let mateInfo = view.textInfo {
                    if rowTag != 0 && mateInfo.rowTag == rowTag{
                        lastWordInfo = mateInfo
                    }
                    if lastWordInfo?.rowTag == rowTag && mateInfo.rowTag != rowTag{
                        isFind = true
                        nextView = view
                        print("测试用例-findNextWords-找到的当前下一句的开头是--\(mateInfo.str)")
                        break
                    }
                }
            }
        }
        if isFind {
            if segmentControl.selectedSegmentIndex == 0{
                if nextView.beisongStatus != .onlyShow{
                    changeTextStatus(firstView: nextView)
                }else if nextView.beisongStatus == .onlyShow{
                    _ = findNextWords(currentView: nextView)
                }
            }else{
                changeTextStatus(firstView: nextView)
            }
            
        }
        return isFind

    }
    func changeTextStatus(firstView: PRPoetrySingleTextView){
        if let info = firstView.textInfo {
            
            for (i, view) in stardardPinYinArr.enumerated(){
                if let mateInfo = view.textInfo {
                        if mateInfo.rowTag == info.rowTag {
                        if view.beisongStatus == .prepare{
                            view.beisongStatus = .beisongPrompt
                            promptViewArr.append(view)
                        }
                        
                        
                        
                    }
                }
            }
            //准备倒计时5秒 ,5秒后还原
            promptViewTimer = PRPoetryCountdownTimer(countdown: 1000 * 5)
            promptViewTimer?.customTimeInterval = .milliseconds(1000)
            promptViewTimer?.stopCallback = {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else { return }
                    for (_, view) in self.promptViewArr.enumerated(){
                        if view.beisongStatus == .beisongPrompt{
                            view.beisongStatus = .prepare
                        }
                    }
                    self.promptBtn.isUserInteractionEnabled = true
                    self.promptViewArr.removeAll()
                    promptImg.image = UIImage(named: "pr_icon_poetry_prompt")
                }
            }
            promptViewTimer?.startWithSeconds()
        }
        
    }
    
    func sortoutWords(){
        stardardPinYinArr.removeAll()
        matePinYinArr.removeAll()
        
        for sectionArr in titleWordViewArr {
            for view in sectionArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                stardardPinYinArr.append(view)
            }
        }
        for view in poetWordViewArr {
            
            if punctuation.contains(view.textInfo?.str ?? ""){
                continue
            }
            stardardPinYinArr.append(view)
        }
        for sectionArr in orderWordViewArr {
            for view in sectionArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                stardardPinYinArr.append(view)
            }
        }
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
            
                    if punctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    stardardPinYinArr.append(view)
                }
            }
        }
        for (i, view) in stardardPinYinArr.enumerated(){
            view.textInfo?.is_mate = false
            view.beisongStatus = .prepare
            view.textInfo?.serialNumber = i
            let pinyin = handleTextToPinYin(text: view.textInfo?.str ?? "")
            view.textInfo?.wordPinyin = pinyin
            if i < 6{
                matePinYinArr.append(view)
            }
        }
//        currentMateSN = 0
        
    }
    func tagWordsTail(){
        //去掉所有标点,最后一个字做标记
        var tempTitleViewArr = Array<PRPoetrySingleTextView>()
        for sectionArr in titleWordViewArr {
            for view in sectionArr {
                guard let info = view.textInfo else { continue }
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                view.textInfo?.rowTag = 1 //rowTag 默认1
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
                let punctuation = "卍 "
                if punctuation.contains(view.textInfo?.str ?? ""){
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
                }
                tempOrderSectionView.removeAll()
            }else{
                tempOrderSectionView.append(view)
            }
            
        }
        
        var tempContentAllViewArr = Array<PRPoetrySingleTextView>()
       
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
                    let punctuation = "卍 "
                    if punctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    tempContentAllViewArr.append(view)
                }
            }
        }
        
        var tempContentSectionView = Array<PRPoetrySingleTextView>()
        
        for view in tempContentAllViewArr
        {
            guard let info = view.textInfo else { continue }
            if tailPunctuation.contains(info.str){
                if let last = tempContentSectionView.last{
                    
                    last.textInfo?.rowTail = true
                    for view in tempContentSectionView{
                        view.textInfo?.rowTag = info.wordTrueIndex //用断句的标点wordTrueIndex作为rowTag
                    }
                }
                tempContentSectionView.removeAll()
            }else{
                tempContentSectionView.append(view)
            }
            
        }
    }
    //首字
    func sortoutWordsWithModeOne(){
        stardardPinYinArr.removeAll()
        matePinYinArr.removeAll()
        
        //首字模式
        var needTagView = handleWordModeOne()
        
        
        if let titleTagView = titleWordViewArr.first?.first {
            needTagView.insert(titleTagView, at: 0)
        }
        
        var tempPoetViewArr = Array<PRPoetrySingleTextView>()
        for view in poetWordViewArr {
            let punctuation = "["
            if punctuation.contains(view.textInfo?.str ?? ""){
                continue
            }
            tempPoetViewArr.append(view)
        }
        if let poetTagView = tempPoetViewArr.first {
            needTagView.insert(poetTagView, at: 0)
        }
        
        for sectionArr in titleWordViewArr {
            for view in sectionArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                stardardPinYinArr.append(view)
            }
        }
        for view in poetWordViewArr {
            
            if punctuation.contains(view.textInfo?.str ?? ""){
                continue
            }
            stardardPinYinArr.append(view)
        }
    
        
        for sectionArr in orderWordViewArr {
            for view in sectionArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                stardardPinYinArr.append(view)
            }
        }
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
                    
                    if punctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    stardardPinYinArr.append(view)
                }
            }
        }
        for (i, view) in stardardPinYinArr.enumerated(){
            view.textInfo?.is_mate = false
            let pinyin = handleTextToPinYin(text: view.textInfo?.str ?? "")
            view.textInfo?.wordPinyin = pinyin
            view.textInfo?.serialNumber = i
            view.beisongStatus = .prepare
            
            var is_Find = false
            for tagView in needTagView{
                if tagView.textInfo?.wordTrueIndex == view.textInfo?.wordTrueIndex{
                    view.beisongStatus = .onlyShow
                    is_Find = true
                    break
                }
            }
    
            
            
            if !is_Find && i < 6{
                matePinYinArr.append(view)
            }
        }
//        currentMateSN = 0
        
    }
    func sortoutWordsWithModeTwo(){
        stardardPinYinArr.removeAll()
        matePinYinArr.removeAll()
        //隔句模式
        var needTagView = handleWordModeTwo()
        for sectionArr in titleWordViewArr {
            for view in sectionArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                stardardPinYinArr.append(view)
            }
        }
        for view in poetWordViewArr {
            
            if punctuation.contains(view.textInfo?.str ?? ""){
                continue
            }
            stardardPinYinArr.append(view)
        }
        for sectionArr in orderWordViewArr {
            for view in sectionArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                stardardPinYinArr.append(view)
            }
        }
 
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
                    
                    if punctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    stardardPinYinArr.append(view)
                }
            }
        }
       
        for (i, view) in stardardPinYinArr.enumerated(){
            view.textInfo?.is_mate = false
//            print("当前字" + view.textInfo!.str + "--Index--" + String(view.textInfo!.wordTrueIndex) )
            view.beisongStatus = .prepare
            
            view.textInfo?.serialNumber = i
            
            let pinyin = handleTextToPinYin(text: view.textInfo?.str ?? "")
            view.textInfo?.wordPinyin = pinyin
            var is_Find = false
            for tagView in needTagView{
        
                if tagView.textInfo?.wordTrueIndex == view.textInfo?.wordTrueIndex{
                    view.beisongStatus = .onlyShow
                    is_Find = true
                    break
                }
            }
            
            
           
            if !is_Find &&  matePinYinArr.count < 6{
                matePinYinArr.append(view)
            }
        }
        print("")
        
    }
    func handleWordModeOne() -> Array<PRPoetrySingleTextView>{
        //用标点符号分割  ,.
        //先拼接 后分组
        var tempOrderAllViewArr = Array<PRPoetrySingleTextView>()
        for sectionArr in orderWordViewArr {
            for view in sectionArr {
                let punctuation = "卍 "
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                tempOrderAllViewArr.append(view)
            }
        }
        var needTagView = Array<PRPoetrySingleTextView>()
        var tempOrderSectionView = Array<PRPoetrySingleTextView>()
        
        for view in tempOrderAllViewArr
        {
            guard let info = view.textInfo else { continue }
            if tailPunctuation.contains(info.str){
                if let first = tempOrderSectionView.first{
                    needTagView.append(first)
                }
                tempOrderSectionView.removeAll()
            }else{
                tempOrderSectionView.append(view)
            }
            
        }
        
        var tempContentAllViewArr = Array<PRPoetrySingleTextView>()
       
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
                    let punctuation = "卍 "
                    if punctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    tempContentAllViewArr.append(view)
                }
            }
        }
        
        var tempContentSectionView = Array<PRPoetrySingleTextView>()
        
        for view in tempContentAllViewArr
        {
            guard let info = view.textInfo else { continue }
            
            if tailPunctuation.contains(info.str){
                if let first = tempContentSectionView.first{
                    needTagView.append(first)
                }
                tempContentSectionView.removeAll()
            }else{
                tempContentSectionView.append(view)
            }
            
        }
        return needTagView
    }
    func handleWordModeTwo() -> Array<PRPoetrySingleTextView>{
        var status =  modeStatus//展示前半句
        
        var needTagView = Array<PRPoetrySingleTextView>()
        if !status{
            for sectionArr in titleWordViewArr {
                for view in sectionArr {
                    
                    if punctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    needTagView.append(view)
                }
            }
        }else{
            
            for view in poetWordViewArr {
                
                if punctuation.contains(view.textInfo?.str ?? ""){
                    continue
                }
                needTagView.append(view)
            }
        }
        
        var tempOrderAllViewArr = Array<PRPoetrySingleTextView>()
        for sectionArr in orderWordViewArr {
            for view in sectionArr {
                let punctuation = "卍 "
                if punctuation.contains(view.textInfo?.str ?? ""){
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
                status = !status
                if status{
                    needTagView += tempOrderSectionView
                    tempOrderSectionView.removeAll()
                }else{
                    tempOrderSectionView.removeAll()
                }
            }else{
                tempOrderSectionView.append(view)
            }
            
        }
        
        var tempContentAllViewArr = Array<PRPoetrySingleTextView>()
       
        for partArr in contentWordViewArr {
            for sectionArr in partArr {
                for view in sectionArr{
                    let punctuation = "卍 "
                    if punctuation.contains(view.textInfo?.str ?? ""){
                        continue
                    }
                    tempContentAllViewArr.append(view)
                }
            }
        }
        
        var tempContentSectionView = Array<PRPoetrySingleTextView>()
        
        for view in tempContentAllViewArr
        {
            guard let info = view.textInfo else { continue }
            
            if tailPunctuation.contains(info.str){
                status = !status
                if status{
                    needTagView += tempContentSectionView
                    tempContentSectionView.removeAll()
                }else{
                    tempContentSectionView.removeAll()
                }
            }else{
                tempContentSectionView.append(view)
            }
            
        }
        return needTagView
    }
}
extension PRPoetrysBeiSongController: PRAudioRecordDelegate{
    func audioRecorderRealTimeVolume(_ volume: Double) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
           
            self.waveView.updateVolumeBars(newVolume: Float(volume))
            
        }
    }

    
    func audioRecorderDidReceive(_ audioData: Data) {
        self.audioData.append(audioData)
    }

}


extension PRPoetrysBeiSongController{
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
            var arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
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
//                print("段数--\(contentNum)")
                if infoData?.isorder ?? false {
                    //有序
                    if contentNum == 0 {continue}
                    
                }
                let orderContent = infoData?.poem.content[contentNum]
               
                if let text = orderContent?.label{
                    
                    
                    let annotion: [PRPoetryInfoAnnotation] = orderContent?.annotation ?? []
                    var arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
                    var sectionWordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
                    for (index, strArr) in arr.enumerated(){
    
                        let contentS = PRPoetryHStackView.init(styleData: textData)
                        vStackView.addArrangedSubview(contentS)
                        var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()
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
            var arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
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
                var arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
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
//                print("段数--\(contentNum)")
                if infoData?.isorder ?? false {
                    //有序
                    if contentNum == 0 {continue}
                    
                }
                let orderContent = infoData?.poem.content[contentNum]
               
                if let text = orderContent?.label{
                    
                    
                    let annotion: [PRPoetryInfoAnnotation] = orderContent?.annotation ?? []
                    var arr: Array<Array<PRPoetryInfoWordModel>> = getFinalWordResult(str: text, textData: textData, annotion: annotion)
                    var sectionWordArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()

                    for (index, strArr) in arr.enumerated(){
    
                        let contentS = PRPoetryHStackView.init(styleData: textData)
                        vStackView.addArrangedSubview(contentS)
                        var subWordArr: Array<PRPoetrySingleTextView> = Array<PRPoetrySingleTextView>()

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
extension PRPoetrysBeiSongController{
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
//                    print("是否锚点:\(wordModel.annotion ? "是" : "否")---第\(trueIndex)个字符:" + wordModel.str)
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
//                                print("标题是否锚点:\(wordModel.annotion ? "是" : "否")---第\(trueIndex)个字符:" + wordModel.str)
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
//                        print("标题是否锚点:\(wordModel.annotion ? "是" : "否")---第\(trueIndex)个字符:" + wordModel.str)
                        rowArr.append(wordModel)
                    }
                    
                    sectionArr.append(rowArr)
                }
            }

        }
        else{
           
            
            for line in 1...lineNum{
                var rowArr = Array<PRPoetryInfoWordModel>()
//                print("第\(line)行")
                var startIndex = (line - 1) * wordNums
                let stopIndex = min(line * wordNums, str.count)
//                print("第一次开始位\(startIndex)--截止\(stopIndex)")

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
                    
//                    print("是否锚点\(wordModel.annotion ? "是" : "否")---第\(i)个字符:" + String(str[textIndex]))
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
//            print("kk-检查通过---")
            return(true, sectionArr)
        }else{
//            print("kk-重新检查")
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

extension PRPoetrysBeiSongController {
    
    func createNewFile(fileName: String) -> String{
        guard let path = mainPath else { return "" }
        let filePath = path + "/" + fileName
        //如果文件存在就删除
        if fileManager.fileExists(atPath: filePath){
            do {
                    // 删除文件
                    try fileManager.removeItem(atPath: filePath)
//                    print("文件删除成功")
                    return filePath
                } catch {
//                    print("删除文件失败: \(error)")
                    return ""
                }
        }else{
            return filePath
        }
        
    }
    func jointPath(fileName: String) -> String{
        guard let path = mainPath else { return "" }
        let filePath = path + "/" + fileName
        return filePath
    }
    
}
extension PRPoetrysBeiSongController {
    func configTimer(){
        self.timer = DispatchSource.makeTimerSource(flags: .strict, queue: self.queue)
        self.timer?.schedule(deadline: .now() , repeating: self.interval)
//        let formatter = DateFormatter()
      //           formatter.dateFormat = "mm:ss.SSS"
      //            let time = formatter.string(from:  Date()) as String
//            print("kk当前时间\(time)")
        self.timer?.setEventHandler(handler: {[weak self] in
            guard let self = self else { return }
            if self.audioData.count > 1280 && self.socketManager.socketStatus{
                if self.currentPosition < self.audioData.count{
//                    print("kk音频传输ing")
                    let chunkEndPosition = min(self.currentPosition + self.chunkSize, self.audioData.count)
                    let chunkData = self.audioData.subdata(in: self.currentPosition..<chunkEndPosition)
                    self.socketManager.sendMessage(data: chunkData)
                    self.currentPosition = chunkEndPosition
                }else{
//                    print("kk音频传输结束")
                    self.stopBeisong()
                }
            }
        
        })
       
        self.timer?.resume()
    }
    
    func stopBeisong(){
        
        print("kk音频传输结束")
        self.socketManager.closeWebSocket()
        
        //timer需要主动结束
        self.timer?.cancel()
        self.timer = nil
        
        //防止中断,ui异常
        DispatchQueue.main.async {[weak self] in
            guard let self = self else{return}
            self.waveView.resetVolumeBars()
            UIView.animate(withDuration: 0.2, animations: {
                
                self.waveFormBgView.alpha = 0
                self.promptView.alpha = 0
            })
            
            
        }
       
       //去跳到下个结算页面,计算分数

       DispatchQueue.main.async {[weak self] in
           guard let self = self else { return }
           self.previousFlashView.stopFlashCursor()
           for (i, view) in stardardPinYinArr.enumerated() {
               if view.beisongStatus == .prepare{
                   view.beisongStatus = .beisongFail
               }
           }
           
//           TYSnapshotScroll.screenSnapshot(self.poetryScrollview) { [weak self] screenShotImage in
//               guard let self = self else {return}
//               guard let image = screenShotImage else {
//                   return
//               }
//               guard let chapterId = self.currentPoetryModel.chapter_id else {
//                   return
//               }
//               let key = currentPoetryModel.chapter_id + "poetryPictureKey"
//               let cache = ImageCache.default
//               cache.store(image, forKey: key)
//               self.resetBeisong()
//               
//               self.pushToResultPage()
//           }
          
           
       }
    }
    
    func pushToResultPage(){
        let storyBoard = UIStoryboard(name: "PRPoetrysBeiSongResultController", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PRPoetrysBeiSongResultController") as! PRPoetrysBeiSongResultController
        
        var mateArr = Array<Any>()
        var allNeedMateArr = Array<Any>()
        for view in self.stardardPinYinArr {
            guard let info = view.textInfo else { continue }
            if info.is_mate{
                mateArr.append(view)
            }
                //FIXME:算分的时候,先把tempBeisongPrompt改为onlyShow
            if view.beisongStatus != .onlyShow{
                allNeedMateArr.append(view)
            }
            
        }
        
        
        let score = CGFloat(mateArr.count) * 1.0 / CGFloat(allNeedMateArr.count)
        print("总字数--[\(String(allNeedMateArr.count))]---正确的字数-[\(String(mateArr.count))]---正确率-[\(String(format: "%.2f", score))]")
        if score >= 0.8{
            vc.score = 3
        }else if score >= 0.6 {
            vc.score = 2
        }else{
            vc.score = 1
        }
        print("")
//        PRUserDefaultManager.setPoetryScoreData(Int32(score), chapterID: currentPoetryModel.chapter_id)
        vc.bgImgUrl = self.currentPoetryModel.bgImgUrl
        vc.currentPoetryModel = self.currentPoetryModel
        vc.audioPath =  self.jointPath(fileName: currentPoetryModel.chapter_id + ".mp3")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PRPoetrysBeiSongController: PRPoetrySocketDelegate{
    func didReceiveData(data: String) {
//        print("BeiSong拿到的值---\(data)")
        handleReceivedText(jsonStr: data)
    }
    
    func handleReceivedText(jsonStr: String){
        if let jsonData = jsonStr.data(using: .utf8) {
               do {
                   let dataStruct = try JSONDecoder().decode(PRWebSocketData.self, from: jsonData)
                   switch dataStruct.action {
                   case "started":
                       print("kkwebsocket状态-已连接")
                   case "result":
                       let dataJson: String = dataStruct.data
                       let json = JSON(parseJSON: dataJson)
                       var textStr = ""
                       var resultStr = ""
                       if let type =  json["seg_id"].string{
                           
                       }
                       guard let type = json["seg_id"].int else {
                           return
                       }
                       if  json["cn"]["st"]["type"].string == "1"  {
                           textStr = textStr + "临时结果--"
                       }else{
                           textStr = textStr + "最终结果--"
                       }
                       
//                       textStr = "NO-" + String(type)  + "--"
                       if let arr =  json["cn"]["st"]["rt"][0]["ws"].array  {
                           for index in 0..<arr.count{
                               if let text =  arr[index]["cw"][0]["w"].string {
                                   textStr = textStr + text
                                   resultStr = resultStr + text
                                   
                               }
                           }
                       }
//                       print("textStr---------\(textStr)")
                       
                       var needCheckResult = ""
                       //临时结果做判定  出了最终结果,再次校验
                       if  json["cn"]["st"]["type"].string == "1"  {
                           sttStatus = .soundToTexting
                           //临时结果
                           //每一次的临时结果都要和上一次比较,找出改变,然后匹配拼音,然后开始对比
                           needCheckResult = checkSTTResult(result: resultStr, type: 1)
                       }else{
                           //最终结果-最终结果是去修正之前已经匹配的结果
                           sttStatus = .soundToTextSuccess
                           needCheckResult = checkSTTResult(result: resultStr, type: 0)
                        
                       }
                       if needCheckResult.count > 0{
                           checkPinyin(result: needCheckResult)
                           
                       }
                       
                       

                       
                   case "error":
                       
                       print("kkwebsocket连接异常")
                       //手动关闭
                   default: break
                       
                   }
                   print("")
               } catch {
                   debugPrint("error == \(error)")
               }
           }
    }
    
    func checkSTTResult(result: String, type: Int) -> String{
        let resultFiltered = filterPunctuation(input: result)
        
        let lastSTTResult = lastTempResult
        
       
        let resultText = checkWord(previousStr: lastSTTResult, nextStr: resultFiltered)

        if type == 0{
            //需要清空 lastTempResult
            lastTempResult = ""
        }else{
            lastTempResult = resultFiltered
        }
//        print("kkk-状态\(type)转拼音判断的字-\(resultText)")
        return resultText
        
    }
    func checkWord(previousStr: String, nextStr: String) -> String{
        if previousStr.count <= 0{
            return nextStr
        }
        if nextStr.count <= 0{
            return ""
        }
        var arr1 = Array(previousStr)
        var arr2 = Array(nextStr)
        for (str1Index, word1) in arr1.enumerated().reversed(){
            for (str2Index, word2) in arr2.enumerated().reversed(){
                if word1 == word2 {
                    arr1.remove(at: str1Index)
                    arr2.remove(at: str2Index)
                    break
                }
            }
        }
        return String(arr2)
        
    }
    func checkPinyin(result: String){
        //拿到了每次识别的结果
        //转拼音
        var resultArr = Array<PRPoetryArrModel>()
        for char in result {
            let str = String(char)
            let pinyin = handleTextToPinYin(text: str)
            let model = PRPoetryArrModel()
            model.wordPinyin = pinyin
            resultArr.append(model)
        }
        // chuang  qian  ming yue guang  答案
        // chuang  qian  ming yue guang  用户背诵 临时结果
        // chuang  qian  ming yue guang a 用户背诵 最终结果 不往下推
        //有个问题 是否拒绝反着背诗
        //特殊逻辑   明月光床
        var changed = false
        for (mateIndex,view) in matePinYinArr.enumerated(){
            guard var wordInfo = view.textInfo else {
                continue
            }
            for (resultIndex,resultModel) in resultArr.enumerated(){
                if resultModel.is_mate {
                    continue
                }
                if wordInfo.wordPinyin == resultModel.wordPinyin{
                    //匹配
//                    wordInfo.is_mate = true
                    view.textInfo?.is_mate = true
                    resultModel.is_mate = true
                    changed = true
                    recitationProgress = max(recitationProgress, wordInfo.wordTrueIndex)
                    recitationProgressView = view
                    
                    changeTextColor(index: wordInfo.wordTrueIndex)
                    break
                }
            }
        }
        if changed{
            updateMatePinArr()
        }
        
        print("")
   
    }
    func updateMatePinArr(){
            
        //删除已经匹配的字
        var tempArr = Array<PRPoetrySingleTextView>()
        
        var maxIndex = 0
        for view in matePinYinArr.reversed() {
            if view.textInfo?.is_mate == true {
                maxIndex = view.textInfo?.serialNumber ?? 0
                break
            }
        }
        
        if maxIndex < currentMateSN{
            print("测试用例-qqq匹配了之前的字")
            //光标不动
            
            //删掉已经匹配
            for model in matePinYinArr {
                guard let textInfo = model.textInfo else {continue}
                if textInfo.is_mate == false {
                    tempArr.append(model)
                }
            }
            matePinYinArr = tempArr
            return
        }
        //找maxIndex后面的字闪
        
        for model in matePinYinArr {
            guard let textInfo = model.textInfo else {continue}
            if textInfo.is_mate == false && textInfo.serialNumber < maxIndex {
                tempArr.append(model)
            }
        }
        
        var addMatchArr = Array<PRPoetrySingleTextView>()
        
        for (i, view) in stardardPinYinArr.enumerated() {
            if view.textInfo?.serialNumber == maxIndex{
                //从这里开始
               
                    for (j, nextView) in stardardPinYinArr.enumerated() {
                        if j <= i{
                            continue
                        }
                        if addMatchArr.count > 5{
                            break
                        }
                        if let nextInfo = nextView.textInfo{
                            if (nextView.beisongStatus == .prepare || nextView.beisongStatus == .beisongPrompt) {
                                
                                addMatchArr.append(nextView)
                            }
                        }
                        
                    }
                
            
//                for index in 1...6 {
//                    
//                    if (i + index) < stardardPinYinArr.count{
//                        let model = stardardPinYinArr[i + index]
//                        if index == 1{
//                            print("测试用例---currentMateSN指向---\(String(describing: model.textInfo?.str))")
//                            currentMateSN = model.textInfo?.serialNumber ?? 0
//                            
//                        }
//                        print("/n/n测试用例---待匹配字符[--\(model.textInfo?.str)--]")
//                        tempArr.append(model)
//                    }
//                }
                break
            }
        }
        if let currentView = addMatchArr.first{
            currentMateSN = currentView.textInfo?.serialNumber ?? 0
            print("测试用例---currentMateSN指向---\(String(describing: currentView.textInfo?.str))")
        }
    
        matePinYinArr = tempArr + addMatchArr
        for (index, view) in matePinYinArr.enumerated(){
            if index == 0{
                print("测试用例-------------")
            }
           
            if let info = view.textInfo{
                print("测试用例---所有待匹配字符[--\(info.str)--]")
            }
            if index == matePinYinArr.count - 1{
                print("测试用例-------------")
            }
        }
    }
    func changeTextColor(index: Int){
        //去标记已识别的字
        for wordView in stardardPinYinArr {
            if index == wordView.textInfo?.wordTrueIndex{
                print("测试用例--已经识别-------\(String(describing: wordView.textInfo?.str))")
            }
        
        }
        
        for view in stardardPinYinArr {
            guard let info = view.textInfo else { continue }
            if view.beisongStatus == .onlyShow {
                continue
            }
            
            if info.wordTrueIndex <= recitationProgress{
                if info.is_mate == false{
                    view.beisongStatus = .beisongFail
                }else{
                    view.beisongStatus = .beisongSuc
                }
            }
            
        }
        //根据时间 来结束
 
    }
    func handleTextToPinYin(text: String) ->String{
        var str = NSMutableString(string: text) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) == true{
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) == true{
                return str as String
            }
        }
        return ""
    }
    func filterPunctuation(input: String) -> String {
        let punctuationCharacters = CharacterSet.punctuationCharacters
        let components = input.components(separatedBy: punctuationCharacters)
        let filteredString = components.joined(separator: "")
        return filteredString
    }
    func flashCursor(){
        
        
        self.previousFlashView.stopFlashCursor()
        let tempIndex = 0
        findFlashCursor: for (i, view) in stardardPinYinArr.enumerated() {
            if view.textInfo?.serialNumber == currentMateSN{
                for (j, nextView) in stardardPinYinArr.enumerated() {
                    if let nextInfo = nextView.textInfo{
                        if j >= i && (nextView.beisongStatus == .prepare || nextView.beisongStatus == .beisongPrompt) {
                            
                            nextView.flashCursor()
                            self.previousFlashView = nextView
                            break findFlashCursor
                        }
                    }
                    
                }

            }
        }
    }
}
extension PRPoetrysBeiSongController: PCNavigationControllerPopDelegate{
   
    func navigationBarShouldPopViewController(_ nvigationController: UINavigationController!, onBackBarButtonAction backBarButtonItem: UIBarButtonItem!) {
        if audioRecord.isRecording {
            
            showAlert(on: self)
        }else{
            if let nav = self.navigationController{
                nav.popViewController(animated: true)
            }
        }
    }
    

    func showAlert(on viewController: UIViewController) {
        // 创建 UIAlertController
        let alertController = UIAlertController(title: nil, message: "背诵进行中，确认退出吗？", preferredStyle: .alert)
        
        // 创建 "确认" 按钮
        let confirmAction = UIAlertAction(title: "确认", style: .destructive) { _ in
            // 处理确认操作
            self.audioRecord.stop()
            self.socketManager.closeWebSocket()
            self.timer?.cancel()
            self.timer = nil
            
            if let nav = self.navigationController{
                nav.popViewController(animated: true)
            }
        }
        
        // 创建 "继续跟读" 按钮
        let continueAction = UIAlertAction(title: "继续背诵", style: .cancel) { _ in
            // 处理继续跟读操作
            
            // 例如，执行继续跟读操作的代码
        }
        
        // 将按钮添加到 UIAlertController
        alertController.addAction(confirmAction)
        alertController.addAction(continueAction)
        
        // 显示弹窗
        viewController.present(alertController, animated: true, completion: nil)
    }

   
}
