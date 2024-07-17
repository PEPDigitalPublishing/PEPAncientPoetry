//
//  PRPoetrySingleTextView.swift
//  PEPRead
//
//  Created by sunShine on 2023/9/19.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
import Spring

enum PRPoetrySingleTextStyle: String{
    case title
    case poet
    case order
    case content
}
enum PRPoetryInfoWordPosition: String{
    case single
    case left
    case right
    case middle
    case normal
}
enum PRPoetryWordGenduStatus: String{
    case black   //空
    case origin   //透明
    case green //绿色
    
}
enum PRPoetryWordBeisongStatus: String{
    case emptyWord   //空
    case prepare   //透明
    case beisongSuc //绿色
    case beisongFail //红色
    case beisongPrompt //橙色
//    case beisongPromptOnlyShow //橙色
//    case beisongPromptSuc //橙色
//    case beisongPromptFail //橙色
    case onlyShow //仅展示-黑色
}
struct PRPoetryReadTimeData {
    var startTime: Int = 0//全字
    var stopTime: Int = 0//全字
    
    var contentStartTime: Int = 0//读字
    var contentEndTime: Int = 0//读字
    
    var wordStartHeadTime: Int = 0//字前空余
    var wordEndHeadTime: Int = 0//字前空余
    
    var wordStartBehindTime: Int = 0//字后空余
    var wordEndBehindTime: Int = 0//字后空余
    
    var isPunctuation = false
    
}
struct PRPoetrySingleTextData {
    var style: PRPoetrySingleTextStyle
    var section: Int //弃用
    var row: Int //弃用
    var fontColor: String
    var fontSize: CGFloat
    var spacing: CGFloat
    var poetryStyle: poetryStyle
    var showBottomLine = true
}
struct PRPoetryInfoWordModel {
    var textData: PRPoetrySingleTextData
    var content: String
    var position: PRPoetryInfoWordPosition
    var textPart: Int = 0
    var section: Int = 0
    var row: Int = 0
    var rowTag = 0 //标记是同一句
    var rowTail = false
    var sectionTail = false
    var wordTimeData: PRPoetryReadTimeData?
    var wordTrueIndex: Int {
        //修复 从1开始
        get{
            if textData.style == .title{
                return textPart  + section * 100 + row
            }else if textData.style == .poet{
                return textPart  + section * 1000 + row
            }else if textData.style == .order{
                return textPart * 10000 + section * 100 + row
            }
            else{
                return textPart * 100000 + section * 1000 + row
            }
            
            
        }
    }
    
    var wordPinyin: String = ""
    
    var is_mate = false
    
    var annotion: Bool {
        get{
            if content.count > 0{
                return true
            }else{
                return false
            }
        }
    }
    var str: String = ""
    var blank: Bool {
        get{
            if str == "卍"{
                return true
            }else{
                return false
            }
        }
    }
    
    var serialNumber = 0
    
}

class PRPoetrySingleTextView: UIView {
    
//    var titleLabel = UILabel()
    var titleLabel = PRPoetryTextView()
    var textData: PRPoetrySingleTextData?
    var lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_28Line_single") )
    var lineWord_view = SpringView.init()
    var textInfo: PRPoetryInfoWordModel?
    var btn = UIButton(type: .custom)
    var genduStatus: PRPoetryWordGenduStatus = .black
    var isFlash = false
    var is_sel = false{
        didSet{
            changeWordUI()
        }
    }
    var beisongStatus: PRPoetryWordBeisongStatus = .prepare {
        didSet{
            changeBeisongWordUI()
        }
    }
    
    init(textInfo: PRPoetryInfoWordModel, data: PRPoetrySingleTextData){
        super.init(frame: CGRect.zero)
        
        titleLabel = PRPoetryTextView()

        //FZKTK--GBK1-0 FZKai-Z03
        titleLabel.font = UIFont(name: "FZKai-Z03", size: data.fontSize)
        titleLabel.textColor = UIColor.init(hexString: data.fontColor)
        titleLabel.textAligment = .center
        titleLabel.isRemovedOnCompletion = false
        if textInfo.blank{
            titleLabel.text = " "
        }else{
            titleLabel.text = textInfo.str
        }
        if textInfo.str.count > 0{
            self.textInfo = textInfo
            self.textData = data
            self.setUI()
            
        }
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.red.cgColor
        
        
        
//        self.backgroundColor = UIColor.purple// 设置背景色
    }
    func changeBeisongWordUI(){
        switch beisongStatus {
        case .prepare:
            titleLabel.isHidden = true
            lineWord_view.isHidden = false
        case .beisongSuc:
            titleLabel.isHidden = false
            titleLabel.textColor = UIColor.init(hexString: "#35C79C")
            lineWord_view.isHidden = true
        case .beisongFail:
            titleLabel.isHidden = false
            titleLabel.textColor = UIColor.init(hexString: "#eb4e41")
            lineWord_view.isHidden = true
        case .beisongPrompt:
            titleLabel.isHidden = false
            titleLabel.textColor = UIColor.init(hexString: "#F48D31")
            if !isFlash{
                lineWord_view.isHidden = true
            }
        case .onlyShow:
            titleLabel.isHidden = false
            titleLabel.textColor = UIColor.init(hexString: "#000000")
            lineWord_view.isHidden = true
        default:
            break
    
        }
    }
    func changeWordUI(){
        if is_sel{
            titleLabel.textColor = UIColor.theme
            
            if textData?.style == .title {
                if textInfo?.position == .single{
                    lineImg.image = UIImage(named: "pr_icon_poetry_28Line_single_sel")
                    
                }
                else if textInfo?.position == .left{
                    lineImg.image = UIImage(named: "pr_icon_poetry_28Line_left_sel")
                    
                }
                else if textInfo?.position == .right{
                    lineImg.image = UIImage(named: "pr_icon_poetry_28Line_right_sel")
                    
                }else if textInfo?.position == .middle{
                    lineImg.image = UIImage(named: "pr_icon_poetry_28Line_center_sel")
                    
                }
                
            }else if textData?.style == .order{
                if textInfo?.position == .single{
                    lineImg.image = UIImage(named: "pr_icon_poetry_20Line_single_sel")
                    
                }
                else if textInfo?.position == .left{
                    lineImg.image = UIImage(named: "pr_icon_poetry_20Line_left_sel")
                    
                }
                else if textInfo?.position == .right{
                    lineImg.image = UIImage(named: "pr_icon_poetry_20Line_right_sel")
                    
                }else if textInfo?.position == .middle{
                    lineImg.image = UIImage(named: "pr_icon_poetry_20Line_center_sel")
                    
                }
                
            }
            else {
                if textInfo?.position == .single{
                    lineImg.image = UIImage(named: "pr_icon_poetry_24Line_single_sel")
                }
                else if textInfo?.position == .left{
                    lineImg.image = UIImage(named: "pr_icon_poetry_24Line_left_sel")
                }
                else if textInfo?.position == .right{
                    lineImg.image = UIImage(named: "pr_icon_poetry_24Line_right_sel")
                }else if textInfo?.position == .middle{
                    lineImg.image = UIImage(named: "pr_icon_poetry_24Line_center_sel")
                    
                }
            
            }
            
        }else{
            
            if let tempTextData = textData{
                titleLabel.textColor = UIColor.init(hexString: tempTextData.fontColor)
                if textData?.style == .title {
                    if textInfo?.position == .single{
                        lineImg.image = UIImage(named: "pr_icon_poetry_28Line_single")
                        
                    }
                    else if textInfo?.position == .left{
                        lineImg.image = UIImage(named: "pr_icon_poetry_28Line_left")
                        
                    }
                    else if textInfo?.position == .right{
                        lineImg.image = UIImage(named: "pr_icon_poetry_28Line_right")
                        
                    }else if textInfo?.position == .middle{
                        lineImg.image = UIImage(named: "pr_icon_poetry_28Line_center")
                        
                    }
                    
                }else if textData?.style == .order{
                    if textInfo?.position == .single{
                        lineImg.image = UIImage(named: "pr_icon_poetry_20Line_single")
                        
                    }
                    else if textInfo?.position == .left{
                        lineImg.image = UIImage(named: "pr_icon_poetry_20Line_left")
                        
                    }
                    else if textInfo?.position == .right{
                        lineImg.image = UIImage(named: "pr_icon_poetry_20Line_right")
                        
                    }else if textInfo?.position == .middle{
                        lineImg.image = UIImage(named: "pr_icon_poetry_20Line_center")
                        
                    }
                    
                }
                else {
                    if textInfo?.position == .single{
                        lineImg.image = UIImage(named: "pr_icon_poetry_24Line_single")
                        
                    }
                    else if textInfo?.position == .left{
                        lineImg.image = UIImage(named: "pr_icon_poetry_24Line_left")
                        
                    }
                    else if textInfo?.position == .right{
                        lineImg.image = UIImage(named: "pr_icon_poetry_24Line_right")
                        
                    }else if textInfo?.position == .middle{
                        lineImg.image = UIImage(named: "pr_icon_poetry_24Line_center")
                        
                    }
                
                }
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {

//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.pr_color(withHexString: "#f36787").cgColor

        //计算是开头结尾还是中间
        if textData?.style == .title {
            if textInfo?.position == .single{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_28Line_single") )
            }
            else if textInfo?.position == .left{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_28Line_left") )
                
            }
            else if textInfo?.position == .right{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_28Line_right") )
            }else if textInfo?.position == .middle{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_28Line_center") )
            }
            
        }else if textData?.style == .order{
            if textInfo?.position == .single{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_20Line_single") )
            }
            else if textInfo?.position == .left{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_20Line_left") )
            }
            else if textInfo?.position == .right{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_20Line_right") )
            }else if textInfo?.position == .middle{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_20Line_center") )
            }
            
        }
        else {
            if textInfo?.position == .single{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_24Line_single") )
            }
            else if textInfo?.position == .left{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_24Line_left") )
            }
            else if textInfo?.position == .right{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_24Line_right") )
            }else if textInfo?.position == .middle{
                lineImg = UIImageView(image: UIImage(named: "pr_icon_poetry_24Line_center") )
            }
        
        }
        self.addSubview(titleLabel)
    
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
           
            make.width.equalTo(textData?.fontSize ?? 0)

        }
        
        self.lineWord_view.backgroundColor = .init(hexString: "#C7C7C7")
        self.addSubview(lineWord_view)
        lineWord_view.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp_bottom).offset(-1)
            make.height.equalTo(1.6)
            make.left.equalTo(titleLabel).offset(1.5)
            make.right.equalTo(titleLabel).offset(-1.5)
        }
        lineWord_view.layer.cornerRadius = 0.8
        lineWord_view.layer.masksToBounds = true
        lineWord_view.isHidden = true
        self.addSubview(lineImg)
        
         let margin = (textData?.spacing ?? 0) / 2
         lineImg.snp.makeConstraints { make in
             make.top.equalTo(titleLabel.snp_bottom).offset(4)
             make.bottom.equalToSuperview().offset(-4)
             
             //计算是开头结尾还是中间
             
             if textInfo?.position == .single{
                 make.left.equalTo(titleLabel)
                 make.right.equalTo(titleLabel)
             }
             else if textInfo?.position == .right{
                 make.right.equalTo(titleLabel).offset(0)
             }
             else if textInfo?.position == .left{
                 make.left.equalTo(titleLabel).offset(0)
             }
             else if textInfo?.position == .middle{
                 make.left.equalTo(titleLabel).offset(-margin)
                 make.right.equalTo(titleLabel).offset(margin)
             }

         }
        if textInfo?.annotion ?? false && textData?.showBottomLine ?? false{
            lineImg.isHidden = false
            self.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.top.bottom.left.right.equalToSuperview()
            }
            btn.backgroundColor = .clear
            btn .addTarget(self, action: #selector(clickFunctionBtn(sender: )), for: .touchUpInside)
        }else{
            lineImg.isHidden = true
        }
        
        
    }
    
    
    @objc func clickFunctionBtn(sender: BookEditStateButton){
        //改自身颜色
        //弹窗
        let rect = sender.convert(sender.frame, to: UIApplication.shared.keyWindow)
        print(rect)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PRNotificationNameClickPoetryword), object: self ,userInfo: ["content": textInfo?.content ?? "", "rect": rect, "textInfo": textInfo as Any])
        //
    }
    
    func changeOriginWordColor(){
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else{return}
            self.genduStatus = .origin
            if let timeData = self.textInfo?.wordTimeData{
                var timeD = timeData.contentEndTime - timeData.contentStartTime
                if timeD <= 0{
                    timeD = 250
                }
                let seconds = Double(timeD) * 0.001
            
//                CommonTools.printWithTimestamp("LLL-当前字的播放时间是  " + String(timeD))
                self.titleLabel.maskColor = UIColor.init(hexString: "#F48D31")
                self.titleLabel.playAnimation(seconds) {
                }
                
                
            }
        }

    }
    func changeGenduWordColor(){
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else{return}
            self.genduStatus = .green
            if let timeData = self.textInfo?.wordTimeData{
                var timeD = timeData.contentEndTime - timeData.contentStartTime
                if timeD <= 0{
                    timeD = 250
                }
                let seconds = Double(timeD) * 0.001
        
                self.titleLabel.maskColor = UIColor.init(hexString: "#35C79C")
                self.titleLabel.textColor = UIColor.init(hexString: "#F48D31")
                self.titleLabel.playAnimation(seconds) {
                   
                }
                
            }
        }
        
    }
    
    func flashCursor(){
        isFlash = true
        
        lineWord_view.isHidden = false
        
        lineWord_view.animation = "flash"
        lineWord_view.curve = "easeIn"
        lineWord_view.duration = 0.5
        lineWord_view.repeatCount = .greatestFiniteMagnitude
        lineWord_view.backgroundColor = UIColor.theme
        lineWord_view.animate()
    }
    func stopFlashCursor(){
        isFlash = false
        lineWord_view.layer.removeAllAnimations()
        lineWord_view.backgroundColor = .init(hexString: "#C7C7C7")
    }
    
}
