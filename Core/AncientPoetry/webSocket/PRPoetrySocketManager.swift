//
//  PRPoetrySocketManager.swift
//  PEPRead
//
//  Created by sunShine on 2024/3/7.
//  Copyright © 2024 PEP. All rights reserved.
//

import Foundation

protocol PRPoetrySocketDelegate: AnyObject{
    func didReceiveData(data: String)
}

class PRPoetrySocketManager :NSObject{
    var socket: SRWebSocket?

    let appId = "5a13cf3a"
    
    let aPIKey = "0145d07bef4f2c2719edc5c82c109ca1"
    /**
        创建链接
        关闭链接
     链接成功的代理方法
     链接失败的代理
     定时器定时任务
     */
    var socketStatus: Bool = false
    
    weak var delegate: PRPoetrySocketDelegate?
    
    override init(){
        super.init()
       
    }
    func createXFParams() -> String{
        let currentDate = Date()
        
        let ts = String(Int(currentDate.timeIntervalSince1970))
        
        let baseString = appId + ts
        
        let baseStringMD5 = NSString.md5(forLower32Bate: baseString)
        
        
        let sign =  baseStringMD5?.HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA1), keyString: aPIKey, dataString: baseStringMD5!)
        guard let signStr = sign else{
            return ""
        }
        
        let urlStr = "wss://rtasr.xfyun.cn/v1/ws?appid=\(appId.urlencode(appId))&ts=\(ts)&signa=\(signStr.urlencode(signStr))&lang=cn&pd=edu&engLangType=4&punc=0"
        return urlStr
    }
    func openWebSocket(){
        let urlStr = self.createXFParams()
        if urlStr.count <= 0{
//            showPEPToast("webSocket初始化失败")
            return
        }
        guard let url = URL(string: urlStr) else {
                print("Invalid WebSocket URL")
                return
        }
        socket = SRWebSocket(url: url)
        socket?.delegate = self
        socket?.open()
    }
    func closeWebSocket(){
        let dic = ["end":true]
        let data: Data = try! JSONSerialization.data(withJSONObject: dic)
        do {
            try socket?.send(data: data)
            socket?.close()
        } catch {
            print("An error occurred: \(error)")
        }
    
    }
    func sendMessage(data: Data){
        do {
            try socket?.send(data: data)
        } catch {
            print("An error occurred: \(error)")
        }
       
    }
}
extension PRPoetrySocketManager: SRWebSocketDelegate{
    func webSocketDidOpen(_ webSocket: SRWebSocket) {
        print("WebSocket connection opened")
        guard let webSocket = socket else {
            print("网络异常")
            return
        }
            //定时任务开启,上传数据
        if webSocket.readyState == .OPEN{
            //等到数据量攒够1280之后再传输
            socketStatus = true
        }
        }
        
        func webSocket(_ webSocket: SRWebSocket, didReceiveMessage message: Any) {
            if let receivedMessage = message as? String {
//                print("已收到的消息: \(receivedMessage)")
                delegate?.didReceiveData(data: receivedMessage)
            }
        }
        
        func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
            print("失败消息: \(error.localizedDescription)")
            socketStatus = false
        }
        
        func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
            print("socket关闭 \(code), reason: \(reason ?? ""), wasClean: \(wasClean)")
            socketStatus = false
        }
}
