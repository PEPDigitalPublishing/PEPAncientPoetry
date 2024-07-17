//
//  PRPoetryShowTipView.swift
//  PEPRead
//
//  Created by sunShine on 2023/10/9.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
class PRPoetryShowTipView: UIView{
    var contentL = UILabel()
    var finWidth = 0.0
    var finX = 0.0
    var is_downward = true {
        didSet{
            setUI()
        }
    }//箭头方向
    var positionH = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
   
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setUI() {
         let bgView = UIView()
         self.addSubview(bgView)
         bgView.snp.makeConstraints { make in
             make.centerX.equalToSuperview().offset(finX)
             make.top.equalToSuperview()
             make.bottom.equalToSuperview()
             make.width.equalTo(finWidth)
         }
         
         let img = UIImageView(image: UIImage(named: "pr_icon_poetry_showTip"))
         bgView.addSubview(img)
         img.snp.makeConstraints { make in
             make.right.left.equalToSuperview()
             make.top.equalToSuperview().offset(15)
             make.bottom.equalToSuperview().offset(-15)
         }
         
         
         contentL.font = UIFont.systemFont(ofSize: 15, weight: .regular)
         contentL.textColor = UIColor.init(hexString: "444444")
         
         contentL.numberOfLines = 0
         
//         contentL.showsVerticalScrollIndicator = false
//         contentL.showsHorizontalScrollIndicator = false
//         contentL.isEditable = false
//         contentL.isSelectable = false
//         contentL.backgroundColor = .clear
//         contentL.textContainer.lineFragmentPadding = 1
//         contentL.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//         contentL.isScrollEnabled = false
//         contentL.bounces = false
         bgView.addSubview(contentL)
         
         
         contentL.snp.makeConstraints { make in
             make.top.equalToSuperview().offset(35)
             make.left.equalToSuperview().offset(20)
             make.right.equalToSuperview().offset(-20)

         }
//         contentL.layer.borderWidth = 1
//         contentL.layer.borderColor = UIColor.black.cgColor
         let arrowImg = is_downward ? UIImage(named: "pr_icon_poetry_showTip_arrow_down") : UIImage(named: "pr_icon_poetry_showTip_arrow_up")
         let arrowImgV = UIImageView(image: arrowImg)
         self.addSubview(arrowImgV)
         arrowImgV.snp.makeConstraints { make in
             if is_downward{
                 make.top.equalTo(img.snp_bottom).offset(-2)
             }else{
                 make.bottom.equalTo(img.snp_top).offset(2)
             }
             
             make.left.equalToSuperview().offset(positionH)
             make.size.equalTo(CGSize(width: 18, height: 14))
         }
         

    }
    
    
}
