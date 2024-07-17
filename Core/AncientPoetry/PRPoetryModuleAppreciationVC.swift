//
//  PRPoetryModuleAppreciationVC.swift
//  PEPRead
//
//  Created by sunShine on 2023/10/9.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
class PRPoetryModuleAppreciationVC : BaseAncientPoetryViewController {
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

    @IBOutlet weak var bgImg: UIImageView!
    var style: poetryStyle = .Tangpoetry
    var bgImgUrl = ""
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var myScrollView: UIScrollView!

    @IBOutlet weak var yiwenL: UILabel!
    
    @IBOutlet weak var jiexiL: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var yiwenView: UIView!
    
    @IBOutlet weak var jiexiView: UIView!
    
    @IBOutlet weak var flowStackView: UIStackView!
    
    @IBOutlet weak var toTopView: UIView!
    
    @IBOutlet weak var toTopBtn: UIButton!
    
    @IBOutlet weak var yiwenBtnView: UIView!
    
    @IBOutlet weak var jiexiBtnView: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resetGSCNavBarStyle()
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
        self.showGSCNavBarStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeScrollView = true
        self.title = "赏析"
        configData()

        NotificationCenter.default.addObserver(self, selector: #selector(handleNoti(notification:)), name: NSNotification.Name(rawValue: PRNotificationNameClickPoetryword), object: nil)
        if bgImgUrl.count > 0{
            bgImg.kf.setImage(with: URL(string: bgImgUrl))
        }
        self.navigationBar.title.text = "赏析"
        self.scrollViewTop.constant = CGFloat(64)
        self.view.setNeedsLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    var infoData : PRPoetryInfoRootClass? 
    var currentPoetryModel = PoetryModel()
    
    var titleWordViewArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
    var orderWordViewArr: Array<Array<PRPoetrySingleTextView>> = Array<Array<PRPoetrySingleTextView>>()
    var contentWordViewArr: Array<Array<Array<PRPoetrySingleTextView>>> = Array<Array<Array<PRPoetrySingleTextView>>>()

    
    
    
    @IBAction func clickYi(_ sender: Any) {

        let point = yiwenL.convert(yiwenL.frame, to: bgView)
        let offset = myScrollView.contentSize.height - myScrollView.frame.height
        myScrollView.setContentOffset(CGPoint(x: 0, y:  min(offset, point.origin.y - 100)), animated: true)
    }
    @IBAction func clickJie(_ sender: Any) {
        let point = jiexiL.convert(jiexiL.frame, to: bgView)
        let offset = myScrollView.contentSize.height - myScrollView.frame.height
        myScrollView.setContentOffset(CGPoint(x: 0, y: min(offset, point.origin.y - 100)), animated: true)
    }
    
    @IBAction func clickToTopBtn(_ sender: Any) {
        myScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.headIndent = 0
        style.alignment = .left
        style.firstLineHeadIndent = 37
        
        
        if let yiwen = infoData?.poetry.content, yiwen.count > 0{
            let tempStr = yiwen.replacingOccurrences(of: "</br>", with: "\n")
            
            let attrStr = NSMutableAttributedString(string: tempStr)
            let allFontNSRange = tempStr.toNSRangeWithString(tempStr)
           
            attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: allFontNSRange)
            attrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .regular), range: allFontNSRange)
           
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#666666"), range: allFontNSRange)
            attrStr.addAttribute(NSAttributedString.Key.kern, value:1.5, range: allFontNSRange)
            yiwenL.attributedText = attrStr
        }else{
            bottomStackView.removeArrangedSubview(yiwenView)
            yiwenView.removeFromSuperview()
            
            flowStackView.removeArrangedSubview(yiwenBtnView)
            yiwenBtnView.removeFromSuperview()
        }
        
        
        if let jiexi = infoData?.appreciate.content, jiexi.count > 0{
            let tempStr = jiexi.replacingOccurrences(of: "</br>", with: "\n")
            
            let attrStr = NSMutableAttributedString(string: tempStr)
            let allFontNSRange = tempStr.toNSRangeWithString(tempStr)
           
            attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: allFontNSRange)
            attrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .regular), range: allFontNSRange)
           
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#666666"), range: allFontNSRange)
            attrStr.addAttribute(NSAttributedString.Key.kern, value: 1.5, range: allFontNSRange)
            jiexiL.attributedText = attrStr
            
        }else{
            bottomStackView.removeArrangedSubview(jiexiView)
            jiexiView.removeFromSuperview()
            
            flowStackView.removeArrangedSubview(jiexiBtnView)
            jiexiBtnView.removeFromSuperview()
        }
        self.bottomView.setNeedsLayout()

        myScrollView.setNeedsLayout()
        myScrollView.layoutIfNeeded()
        
        
        let cgsize = myScrollView.contentSize
        if cgsize.height > (HEIGHT_SWIFT - CGFloat(NavBarH_SWIFT) - CGFloat(bottomSafeBarH_SWIFT)) {
            flowStackView.isHidden = false
        }else{
            flowStackView.isHidden = true
            bottomStackView.removeArrangedSubview(toTopView)
            toTopView.removeFromSuperview()
        }
        
        myScrollView.setNeedsLayout()
        myScrollView.layoutIfNeeded()
        bgView.createShapeLayer(withRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
       
    }
}
extension PRPoetryModuleAppreciationVC{
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
            textData.showBottomLine = true
            
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
        poetTextData.showBottomLine = true
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
        
//        if infoData?.isorder ?? false {
//            
//            orderV.snp.makeConstraints { make in
//                make.top.equalTo(poetV.snp_bottom).offset(27)
//                make.left.equalToSuperview().offset(outerSpace)
//                make.right.equalToSuperview().offset(-outerSpace)
//            }
//            var textData = PRPoetrySingleTextData(style: .order, section: 0, row: 0, fontColor: "#888888", fontSize: 20, spacing: 4, poetryStyle: style)
//            textData.showBottomLine = true
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
//                
//                for strArr in arr{
//
//                    let contentS = PRPoetryHStackView.init(styleData: textData)
//                    vStackView.addArrangedSubview(contentS)
//                 
//                    for i in strArr{
//                        let wordView = PRPoetrySingleTextView.init(textInfo: i, data: textData)
//                        contentS.addArrangedSubview(wordView)
//
//                    }
//
//                }
//
//            }
//            
//        }else{
            orderV.snp.makeConstraints { make in
                make.top.equalTo(poetV.snp_bottom).offset(0)
                make.left.equalToSuperview().offset(outerSpace)
                make.right.equalToSuperview().offset(-outerSpace)
            }
//        }
        
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
            textData.showBottomLine = true
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
            textData.showBottomLine = true
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
        poetTextData.showBottomLine = true
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
            var textData = PRPoetrySingleTextData(style: .order, section: 0, row: 0, fontColor: "#888888", fontSize: 20, spacing: 4, poetryStyle: style)
            textData.showBottomLine = true
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
                make.bottom.lessThanOrEqualToSuperview().offset(-20)
            }
            var textData = PRPoetrySingleTextData(style: .content, section: 1, row: 0, fontColor: "#212121", fontSize: 24, spacing: 4, poetryStyle: style)
            textData.showBottomLine = true
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
extension PRPoetryModuleAppreciationVC{
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
extension PRPoetryModuleAppreciationVC{
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
