////
////  PRPoetryModule.swift
////  PEPRead
////
////  Created by sunShine on 2023/5/6.
////  Copyright © 2023 PEP. All rights reserved.
////
//
//import Foundation
//import Starscream
//import Dispatch
//import SwiftyJSON
//import AVFoundation
//
//

//
//class PRPoetryModule : BaseViewController {
//
////
//    let appId = "5a13cf3a"
//    
//    let aPIKey = "0145d07bef4f2c2719edc5c82c109ca1"
//    
//    var recorder: IFlyPcmRecorder?
//    
//    let fileManeger = FileManager.default
//    
//    let mainPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last ?? ""
//    
//    var audioData:Data = Data()
//    
////    var isRecording = false{
////        didSet{
////            if isRecording {
////                self.connectBtn("")
////            }
////        }
////    }
//    
//    var socket:WebSocket?
//    
//    
//    
//    var currentPosition: Int = 0
//    
//    let chunkSize: Int = 1280
//    
//    let chunkInterval: TimeInterval = 0.04
//    
//    
//    
//    
//    // 创建一个全局队列
//    let queue = DispatchQueue.global()
//
//    // 创建一个定时器
//    var timer: DispatchSourceTimer?
//    
//    let interval = DispatchTimeInterval.milliseconds(40)
//    
//    // 创建音频播放器
//    var audioPlayer: AVAudioPlayer?
//    
//    var stardardPinYinArr = Array<PRPoetryArrModel>()
//    
//    var matePinYinArr = Array<PRPoetryArrModel>()
//    
//    var lastTempResult = ""
//    
//    var oText = ""
//    
//    var recitationProgress = 0
//    
//    //当前语音转文字状态    0 1
//    var sttStatus: soundToTextStatus = .soundToTextUnknow
//    
//    @IBOutlet weak var poetryL: UILabel!
//    @IBOutlet weak var textView: UITextView!
//    
//    @IBOutlet weak var recordingTag: UILabel!
//    @IBAction func startRecord(_ sender: Any) {
//        self.textView.text = ""
//        self.currentPosition = 0
//        recitationProgress = 0
//        self.audioData = Data()
//        
//        print("kk当前录音器状态\(String(describing: recorder?.isCompleted()))")
//
//        recorder = IFlyPcmRecorder.sharedInstance()
//        recorder?.delegate = self
//        recorder?.setSaveAudioPath(self.createNewFile(fileName: "test.pcm"))
//        recorder?.setSample("16000")
//        recorder?.start()
//
//        self.connectSocketBtn()
//    }
//    
//    @IBAction func closeRecord(_ sender: Any) {
//        recorder?.stop()
//       
//        print("kk当前录音器状态\(String(describing: recorder?.isCompleted()))")
//
//
//        let path = self.createNewFile(fileName: "test_Data1.pcm")
//        do {
//           try self.audioData.write(to: URL(fileURLWithPath: path))
//           print("kk写入成功！")
//        } catch {
//           print("kk写入失败：\(error)")
//        }
//
//    }
//
//    
////    @IBAction func playFileBtn(_ sender: Any) {
////
////        let audioPath = self.createNewFile(fileName: "test_Data1.pcm")
////
////        let player = PCMPlayer()
////        player.play(pcmData: FileManager.default.contents(atPath: audioPath)!)
////    }
//    
//    
//     
//    func connectSocketBtn() {
//        print("kk开始连接socket")
//         self.configWebSocket()
//        socket?.connect()
//        
//        self.configTimer()
//        recordingTag.isHidden = false
//        self.lastTempResult = ""
//    }
//    
//    
//    
//    func closeSocketBtn() {
//         
//         let dic = ["end":true]
//         let data: Data = try! JSONSerialization.data(withJSONObject: dic)
//         socket?.write(data: data, completion: { [self] in
//             socket?.disconnect()
//             print("kk关闭连接socket")
//            
//         })
//        
//        DispatchQueue.main.async {
//            self.recordingTag.isHidden = true
//            self.lastTempResult = ""
//        }
//        
//       
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        recorder = IFlyPcmRecorder.sharedInstance()
//        recorder?.delegate = self
//        recorder?.setSaveAudioPath(self.createNewFile(fileName: "test.pcm"))
//        recorder?.setSample("16000")
//        print("地址" + self.createNewFile(fileName: "test.pcm"))
//        
//        recordingTag.isHidden = true
//        
//       
//        changeJYS("")
////        let pinyin = handleTextToPinYin(text: "长风破浪会有时")
////        print("")
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.closeRecord("")
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        
//    }
//    //测试
//    @IBAction func clickTempBtn(_ sender: Any) {
//        
//        let text1 = "头头"
//        let text2 = "他这真实"
//        let text3 = "他这真实的"
//        let text4 = "他这真实是"
//        let text5 = "他这真实是床"
//        let text6 = "他这真实是床前"
//        let text7 = "他这真床前"
//        let text8 = "他这真也许床前"
//        let text9 = "他这真也许床前,太坑了"
//        let text10 = "他这真也许床前,太坑了明月光"
//        
//        let result1 = checkSTTResult(result: text1, type: 1)
//        let result2 = checkSTTResult(result: text2, type: 1)
//        let result3 = checkSTTResult(result: text3, type: 1)
//        let result4 = checkSTTResult(result: text4, type: 1)
//        let result5 = checkSTTResult(result: text5, type: 1)
//        let result6 = checkSTTResult(result: text6, type: 1)
//        let result7 = checkSTTResult(result: text7, type: 1)
//        let result8 = checkSTTResult(result: text8, type: 1)
//        let result9 = checkSTTResult(result: text9, type: 1)
//        let result10 = checkSTTResult(result: text10, type: 0)
////        let result11 = checkSTTResult(result: text10, type: 0)
//        
//        
////        let distance1 = jaccardSimilarity(str1: text2, str2: text3)
////        let distance2 = jaccardSimilarity(str1: text3, str2: text4)
////        let distance3 = jaccardSimilarity(str1: text4, str2: text5)
////        let distance4 = jaccardSimilarity(str1: text5, str2: text6)
////        let distance5 = jaccardSimilarity(str1: text8, str2: text9)
////        let distance6 = jaccardSimilarity(str1: text9, str2: text10)
//    
//
//        
//        
//        checkPinyin(result: result1)
//
//        checkPinyin(result: result2)
////
//        checkPinyin(result: result3)
////
//        checkPinyin(result: result4)
//        
////        let delayTime = DispatchTimeInterval.seconds(2)
////        let delayedTask1 = {
////            self.checkPinyin(result: result6)
////        }
////        let delayedTask2 = {
////            self.checkPinyin(result: result10)
////        }
////        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: delayedTask1)
////        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime + delayTime, execute: delayedTask2)
////        checkPinyin(result: result5)
////        
////        checkPinyin(result: result7)
////        checkPinyin(result: result8)
////        checkPinyin(result: result10)
//        //result 过滤标点,
//        
//        /*
//         测试
//         ///   - type: 1-临时结果  0-最终结果
//         func checkSTTResult(result: String, type: Int) -> String{
//         */
//        
//        
//
//
////        let str1 = checkWord(previousStr: "", nextStr: "")
////        let str2 = checkWord(previousStr: text2, nextStr: text3)
////        let str3 = checkWord(previousStr: text3, nextStr: text4)
////        let str4 = checkWord(previousStr: text4, nextStr: text5)
////        let str5 = checkWord(previousStr: text5, nextStr: text6)
////        let str6 = checkWord(previousStr: text6, nextStr: text7)
////        let str7 = checkWord(previousStr: text7, nextStr: text8)
////        let str8 = checkWord(previousStr: text8, nextStr: text9)
////        let str9 = checkWord(previousStr: text9, nextStr: text10)
////
//        print("")
//    }
//    @IBAction func clearBtn(_ sender: Any) {
//        textView.text = ""
//        let mText = NSMutableAttributedString(string: oText)
//        mText.addAttributes([.foregroundColor: UIColor.pr_color(withHexString: "#ffffff")], range: NSRange(location: 0, length: oText.count))
//        poetryL.attributedText = mText
//    }
//    
//    @IBAction func changeJYS(_ sender: Any) {
//        stardardPinYinArr.removeAll()
//        matePinYinArr.removeAll()
//        oText = "床前明月光，疑是地上霜。举头望明月，低头思故乡。"
//        let mText = NSMutableAttributedString(string: oText)
//        mText.addAttributes([.foregroundColor: UIColor.pr_color(withHexString: "#ffffff")], range: NSRange(location: 0, length: oText.count))
//        poetryL.attributedText = mText
//        //转换拼音数组
//        
//        for (index,char) in oText.enumerated() {
//            let str = String(char)
//            let pinyin = handleTextToPinYin(text: str)
//           
//            var model = PRPoetryArrModel()
//            model.wordIndex = index
//            model.word = str
//            model.wordPinyin = pinyin
//            let hashStr = str + String(index)
//            model.wordHash = hashStr.hashValue
//            let punctuation = "，。！“”："
//            if punctuation.contains(str){
//                continue
//            }
//            stardardPinYinArr.append(model)
//        }
//        for (i, model) in stardardPinYinArr.enumerated(){
//            if i < 10{
//                matePinYinArr.append(model)
//            }
//        }
//        
//        print("")
//        
//    }
//    @IBAction func changeGGRZ(_ sender: Any) {
//        stardardPinYinArr.removeAll()
//        matePinYinArr.removeAll()
//        oText = "故人具鸡黍，邀我至田家。绿树村边合，青山郭外斜。开轩面场圃，把酒话桑麻。待到重阳日，还来就菊花。"
//        let mText = NSMutableAttributedString(string: oText)
//        mText.addAttributes([.foregroundColor: UIColor.pr_color(withHexString: "#ffffff")], range: NSRange(location: 0, length: oText.count))
//        poetryL.attributedText = mText
//        //转换拼音数组
//        
//        for (index,char) in oText.enumerated() {
//            let str = String(char)
//            let pinyin = handleTextToPinYin(text: str)
//            
//            var model = PRPoetryArrModel()
//            model.wordIndex = index
//            model.word = str
//            model.wordPinyin = pinyin
//            let hashStr = str + String(index)
//            model.wordHash = hashStr.hashValue
//            let punctuation = "，。！“”：？"
//            if punctuation.contains(str){
//                continue
//            }
//            stardardPinYinArr.append(model)
//        }
//        for (i, pinyin) in stardardPinYinArr.enumerated(){
//            if i < 10{
//                matePinYinArr.append(pinyin)
//            }
//        }
//        
//        print("")
//    }
//    
//    @IBAction func clickJJBtn(_ sender: Any) {
//        stardardPinYinArr.removeAll()
//        matePinYinArr.removeAll()
//        oText = "两个黄鹂鸣翠柳，一行白鹭上青天。窗含西岭千秋雪，门泊东吴万里船。"
//        let mText = NSMutableAttributedString(string: oText)
//        mText.addAttributes([.foregroundColor: UIColor.pr_color(withHexString: "#ffffff")], range: NSRange(location: 0, length: oText.count))
//        poetryL.attributedText = mText
//        //转换拼音数组
//        
//        for (index,char) in oText.enumerated() {
//            let str = String(char)
//            let pinyin = handleTextToPinYin(text: str)
//            
//            var model = PRPoetryArrModel()
//            model.wordIndex = index
//            model.word = str
//            model.wordPinyin = pinyin
//            let hashStr = str + String(index)
//            model.wordHash = hashStr.hashValue
//            let punctuation = "，。！“”：？"
//            if punctuation.contains(str){
//                continue
//            }
//            stardardPinYinArr.append(model)
//        }
//        for (i, pinyin) in stardardPinYinArr.enumerated(){
//            if i < 10{
//                matePinYinArr.append(pinyin)
//            }
//        }
//        
//        print("")
//    }
//    @IBAction func clickXLNBtn(_ sender: Any) {
//        stardardPinYinArr.removeAll()
//        matePinYinArr.removeAll()
//        oText = "金樽清酒斗十千，玉盘珍羞直万钱。停杯投箸不能食，拔剑四顾心茫然。欲渡黄河冰塞川，将登太行雪满山。闲来垂钓碧溪上，忽复乘舟梦日边。行路难，行路难，多歧路，今安在？长风破浪会有时，直挂云帆济沧海。"
//        let mText = NSMutableAttributedString(string: oText)
//        mText.addAttributes([.foregroundColor: UIColor.pr_color(withHexString: "#ffffff")], range: NSRange(location: 0, length: oText.count))
//        poetryL.attributedText = mText
//        //转换拼音数组
//        
//        for (index,char) in oText.enumerated() {
//            let str = String(char)
//            let pinyin = handleTextToPinYin(text: str)
//            
//            var model = PRPoetryArrModel()
//            model.wordIndex = index
//            model.word = str
//            model.wordPinyin = pinyin
//            let hashStr = str + String(index)
//            model.wordHash = hashStr.hashValue
//            let punctuation = "，。！“”：？"
//            if punctuation.contains(str){
//                continue
//            }
//            stardardPinYinArr.append(model)
//        }
//        for (i, pinyin) in stardardPinYinArr.enumerated(){
//            if i < 10{
//                matePinYinArr.append(pinyin)
//            }
//        }
//        
//        print("")
//        
//    }
//    
//    func handleTextToPinYin(text: String) ->String{
//        var str = NSMutableString(string: text) as CFMutableString
//        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) == true{
//            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) == true{
//                return str as String
//            }
//        }
//        return ""
//    }
//}
//
//extension PRPoetryModule {
//    
//    func createXFParams() -> String{
//        let currentDate = Date()
//        
//        let ts = String(Int(currentDate.timeIntervalSince1970))
//        
//        let baseString = appId + ts
//        
//        let baseStringMD5 = NSString.md5(forLower32Bate: baseString)
//        
//        
//        let sign =  baseStringMD5?.HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA1), keyString: aPIKey, dataString: baseStringMD5!)
//        guard let signStr = sign else{
//            return ""
//        }
//        
//        let urlStr = "wss://rtasr.xfyun.cn/v1/ws?appid=\(appId.urlencode(appId))&ts=\(ts)&signa=\(signStr.urlencode(signStr))&lang=cn&pd=edu&engLangType=4&punc=0"
//        return urlStr
//    }
//    func configWebSocket() {
//        let url = self.createXFParams()
//        if url.count <= 0{
//            showPEPToast("webSocket初始化失败")
//            return
//        }
//        
//        var request = URLRequest(url: URL(string: url)!)
//        request.timeoutInterval = 5
//        socket = WebSocket(request: request)
//        socket?.delegate = self
//        
//    }
//    
//}
//extension PRPoetryModule: WebSocketDelegate {
//    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
//        switch event {
//        case .connected(let headers):
//           
//            print("kkwebsocket is connected: \(headers)")
//            
//            
//        case .disconnected(let reason, let code):
//            
//            print("kkwebsocket is disconnected: \(reason) with code: \(code)")
//        case .text(let string):
//            print("kkReceived text: \(string)")
//            
//            self .handleReceivedText(jsonStr: string)
//        case .binary(let data):
//            print("kkReceived data: \(data.count)")
//        case .ping(_):
//            break
//        case .pong(_):
//            break
//        case .viabilityChanged(_):
//            break
//        case .reconnectSuggested(_):
//            break
//        case .cancelled:
//            break
//        case .error(let error):
//            
//            // ...处理异常错误
//            print("kkReceived data: \(String(describing: error))")
//        default:
//            break
//        }
//    }
//    
//   
//    // 通信（与服务端协商好）
////    func didReceive(event: WebSocketEvent, client: WebSocket) {
////        switch event {
////        case .connected(let headers):
////           
////            print("kkwebsocket is connected: \(headers)")
////            
////            
////        case .disconnected(let reason, let code):
////            
////            print("kkwebsocket is disconnected: \(reason) with code: \(code)")
////        case .text(let string):
////            print("kkReceived text: \(string)")
////            
////            self .handleReceivedText(jsonStr: string)
////        case .binary(let data):
////            print("kkReceived data: \(data.count)")
////        case .ping(_):
////            break
////        case .pong(_):
////            break
////        case .viabilityChanged(_):
////            break
////        case .reconnectSuggested(_):
////            break
////        case .cancelled:
////            break
////        case .error(let error):
////            
////            // ...处理异常错误
////            print("kkReceived data: \(String(describing: error))")
////        default:
////            break
////        }
////    }
//    
//    func handleReceivedText(jsonStr: String){
//        if let jsonData = jsonStr.data(using: .utf8) {
//               do {
//                   let dataStruct = try JSONDecoder().decode(PRWebSocketData.self, from: jsonData)
//                   switch dataStruct.action {
//                   case "started":
//                       print("kkwebsocket状态-已连接")
//                   case "result":
//                       let dataJson: String = dataStruct.data
//                       let json = JSON(parseJSON: dataJson)
//                       var textStr = ""
//                       var resultStr = ""
//                       if let type =  json["seg_id"].string{
//                           
//                       }
//                       guard let type = json["seg_id"].int else {
//                           return
//                       }
//                       if  json["cn"]["st"]["type"].string == "1"  {
//                           textStr = textStr + "临时结果--" 
//                       }else{
//                           textStr = textStr + "最终结果--"
//                       }
////                       textStr = "NO-" + String(type)  + "--"
//                       if let arr =  json["cn"]["st"]["rt"][0]["ws"].array  {
//                           for index in 0..<arr.count{
//                               if let text =  arr[index]["cw"][0]["w"].string {
//                                   textStr = textStr + text
//                                   resultStr = resultStr + text
//                                   
//                               }
//                           }
//                       }
//                       var needCheckResult = ""
//                       //临时结果做判定  出了最终结果,再次校验
//                       if  json["cn"]["st"]["type"].string == "1"  {
//                           sttStatus = .soundToTexting
//                           //临时结果
//                           //每一次的临时结果都要和上一次比较,找出改变,然后匹配拼音,然后开始对比
//                           needCheckResult = checkSTTResult(result: resultStr, type: 1)
//                           self.textView.text = self.textView.text + "\n" + textStr
//                           textView.scrollRangeToVisible(NSRange(location: textView.text.count - 1, length: 0))
//                           
//                       }else{
//                           //最终结果-最终结果是去修正之前已经匹配的结果
//                           sttStatus = .soundToTextSuccess
//                           needCheckResult = checkSTTResult(result: resultStr, type: 0)
//                           self.textView.text = self.textView.text + "\n" + textStr + "\n"
//                           textView.scrollRangeToVisible(NSRange(location: textView.text.count - 1, length: 0))
//                           
//                       }
//                       if needCheckResult.count > 0{
//                           checkPinyin(result: needCheckResult)
//                       }
//                       
//                       
//
//                       print("")
//                   case "error":
//                       
//                       print("kkwebsocket连接异常")
//                   default: break
//                       
//                   }
//                   print("")
//               } catch {
//                   debugPrint("error == \(error)")
//               }
//           }
//    }
//    func filterPunctuation(input: String) -> String {
//        let punctuationCharacters = CharacterSet.punctuationCharacters
//        let components = input.components(separatedBy: punctuationCharacters)
//        let filteredString = components.joined(separator: "")
//        return filteredString
//    }
//    
//    //MARK: 说明
//    func jaccardSimilarity(str1: String, str2: String) -> Double {
//        let set1 = Set(str1)
//        let set2 = Set(str2)
//        
//        let intersection = set1.intersection(set2)
//        let union = set1.union(set2)
//        
//        return Double(intersection.count) / Double(union.count)
//    }
//
//    
//
//   
//    ///
//    /// - Parameters:
//    ///   - result:
//    ///   - type: 1-临时结果  0-最终结果
//
///**
//    临时结果--床
//    临时结果--床前
//    临时结果--床前明
//    临时结果--床前明月光
//    最终结果--床前明月光啊
// 
//    临时结果连续 每次上用上一次的临时结果去分割,得出新增的内容
// 
// 
//    在一次临时匹配周期里面 相同的字只会匹配一次
//    明月 只会匹配一次
// 
//    会有一个临时数组 存放本次周期的所有字
// 
//    新建立一个未背诵数组存放未背诵的字
// 
//        
// */
//    func checkSTTResult(result: String, type: Int) -> String{
//        let resultFiltered = filterPunctuation(input: result)
//        
//        let lastSTTResult = lastTempResult
//        
//       
//        let resultText = checkWord(previousStr: lastSTTResult, nextStr: resultFiltered)
//
//        if type == 0{
//            //需要清空 lastTempResult
//            lastTempResult = ""
//        }else{
//            lastTempResult = resultFiltered
//        }
//        print("kkk-状态\(type)转拼音判断的字-\(resultText)")
//        return resultText
//        
//        if type == 1{
//            var resultText: String = ""
//            //  临时结果
//            //用上个结果分割下一个结果,
//            if lastSTTResult.count == 0{
//                //第一次匹配
//                lastTempResult = resultFiltered
//                resultText = resultFiltered
//                
//            }else{
//                var arr = resultFiltered.components(separatedBy: lastSTTResult)
//                
//                if arr.count > 1{
//                    //1.能分开,意味着结果连续,直接用后一段结果继续匹配,
//                    resultText = arr.last ?? ""
//                }else{
//                    //2,分不开,意味着结果不连续.重新匹配  舍弃
//                    resultText = checkWord(previousStr: lastSTTResult, nextStr: resultFiltered)
//                    
//                }
//                lastTempResult = resultFiltered
//                
//            }
//            return resultText
//        }else{
//            var resultText: String = ""
//            //3.最终结果  如果和最后的临时结果一致,就结束,
//            //最终结果 和最后一次临时结果对比,删选出所有不同的字
//     
//            if lastSTTResult != resultFiltered{
//                //继续对比
//                var arr = resultFiltered.components(separatedBy: lastSTTResult)
//                if arr.count > 2{
//                    //1.能分开,意味着结果连续,直接用后一段结果继续匹配,
//                    resultText = arr.last ?? ""
//                }else{
//                    //2,分不开,意味着结果不连续.重新匹配
//                    resultText = resultFiltered
//                }
//            }
//            //需要清空 lastTempResult
//            lastTempResult = ""
//            return resultText
//        }
//        
//    }
//    func checkWord(previousStr: String, nextStr: String) -> String{
//        if previousStr.count <= 0{
//            return nextStr
//        }
//        if nextStr.count <= 0{
//            return ""
//        }
//        var arr1 = Array(previousStr)
//        var arr2 = Array(nextStr)
//        for (str1Index, word1) in arr1.enumerated().reversed(){
//            for (str2Index, word2) in arr2.enumerated().reversed(){
//                if word1 == word2 {
//                    arr1.remove(at: str1Index)
//                    arr2.remove(at: str2Index)
//                    break
//                }
//            }
//        }
//        return String(arr2)
//        
//    }
//    
//    func checkPinyin(result: String){
//        //拿到了每次识别的结果
//        //转拼音
//        var resultArr = Array<PRPoetryArrModel>()
//        for char in result {
//            let str = String(char)
//            let pinyin = handleTextToPinYin(text: str)
//            let model = PRPoetryArrModel()
//            model.wordPinyin = pinyin
//            resultArr.append(model)
//        }
//        // chuang  qian  ming yue guang  答案
//        // chuang  qian  ming yue guang  用户背诵 临时结果
//        // chuang  qian  ming yue guang a 用户背诵 最终结果 不往下推
//        //有个问题 是否拒绝反着背诗
//        //特殊逻辑   明月光床
//        
//        for (mateIndex,mateModel) in matePinYinArr.enumerated(){
//
//            for (resultIndex,resultModel) in resultArr.enumerated(){
//                if resultModel.is_mate {
//                    continue
//                }
//                if mateModel.wordPinyin == resultModel.wordPinyin{
//                    //匹配
//                    mateModel.is_mate = true
//                    resultModel.is_mate = true
//                    recitationProgress = max(recitationProgress, mateModel.wordIndex)
//                    changeTextColor(index: mateModel.wordIndex)
//                    break
//                }
//            }
//        }
//        updateMatePinArr()
//        print("")
//        //需要去补齐 matePinYinArr
//   
//    }
//    func updateMatePinArr(){
//        if let tailIndex = matePinYinArr.last?.wordIndex{
//            //删除已经匹配的字
//            var tempArr = Array<PRPoetryArrModel>()
//            
//            for model in matePinYinArr {
//                if model.is_mate == false {
//                    tempArr.append(model)
//                }
//            }
//            let count = 10 - tempArr.count
//            if count > 0 {
//                for (i, word) in stardardPinYinArr.enumerated() {
//                    if word.wordIndex == tailIndex{
//                        //从这里开始
//                        for index in 1...count {
//                            if (i + index) < stardardPinYinArr.count{
//                                let model = stardardPinYinArr[i + index]
//                                tempArr.append(model)
//                            }
//                        }
//                        break
//                    }
//                }
//            }
//            matePinYinArr = tempArr
//            
//        }
//        print("查看新数据")
//        
//    }
//    func changeTextColor(index: Int){
//        //去标记已识别的字
//        for word in stardardPinYinArr {
//            if index == word.wordIndex{
//                print("已经识别---%@",word.word)
//            }
//        
//        }
//        
//       
//        if let cmText = poetryL.attributedText{
//            let mText = NSMutableAttributedString(attributedString: cmText)
//            
//            for model in stardardPinYinArr {
//                if model.wordIndex <= recitationProgress{
//                    if model.is_mate == false{
//                        mText.addAttributes([.foregroundColor: UIColor.pr_color(withHexString: "#ff3c40")], range: NSRange(location: model.wordIndex, length: 1))
//                    }else{
//                        mText.addAttributes([.foregroundColor: UIColor.pr_color(withHexString: "#0c9566")], range: NSRange(location: model.wordIndex, length: 1))
//                    }
//                }
//                
//            }
//            //0c9566 绿色  ff3c40 红色
//            poetryL.attributedText = mText
//        }
//        let wordLast2 = stardardPinYinArr[stardardPinYinArr.count - 2]
//        let wordLast1 = stardardPinYinArr[stardardPinYinArr.count - 1]
//        
//        //根据时间 来结束
//        
//        
//        
//        if wordLast1.is_mate && wordLast2.is_mate{
//            //停止录音
//            showPEPToast("检测到背诵到最后两个字,本次背诵结束!")
//            closeRecord("")
//        }
//        
//        
//    }
//    
//}
//extension PRPoetryModule {
//    func configTimer(){
//        self.timer = DispatchSource.makeTimerSource(flags: .strict, queue: self.queue)
//        self.timer?.schedule(deadline: .now()+1, repeating: self.interval)
////        let formatter = DateFormatter()
//      //           formatter.dateFormat = "mm:ss.SSS"
//      //            let time = formatter.string(from:  Date()) as String
////            print("kk当前时间\(time)")
//        self.timer?.setEventHandler(handler: {
//            guard self.audioData.count > 1280 else{
//               return
//           }
//            guard self.currentPosition < self.audioData.count else{
//               print("kk音频传输结束")
//               self.closeSocketBtn()
//               self.timer?.cancel()
//               self.timer = nil
//               return
//           }
//            print("kk音频传输ing")
//            let chunkEndPosition = min(self.currentPosition + self.chunkSize, self.audioData.count)
//            let chunkData = self.audioData.subdata(in: self.currentPosition..<chunkEndPosition)
//            self.socket?.write(data: chunkData)
//            self.currentPosition = chunkEndPosition
//        })
//        
//
//        self.timer?.resume()
//    }
//}
//extension PRPoetryModule {
//    
//    func createNewFile(fileName: String) -> String{
//        let filePath = mainPath + "/" + fileName
//        return filePath
//    }
//    
//}
//extension PRPoetryModule: IFlyPcmRecorderDelegate {
//    func onIFlyRecorderBuffer(_ buffer: UnsafeRawPointer!, bufferSize size: Int32) {
//        let newData = Data.init(bytes: buffer, count: Int(size))
//        self.audioData.append(newData)
//        print("kk当前buffer-size\(size)")
////        self.isRecording = true
//    }
//    
//    func onIFlyRecorderError(_ recoder: IFlyPcmRecorder!, theError error: Int32) {
//        print("");
//    }
//    func onIFlyRecorderVolumeChanged(_ power: Int32) {
//        print("kk当前音量\(power)");
//    }
//    
//    
//}
