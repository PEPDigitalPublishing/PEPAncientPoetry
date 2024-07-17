//
//  PRPoetryListHeaderView.swift
//  PEPRead
//
//  Created by sunShine on 2023/8/30.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
import Kingfisher


typealias kPoetryListHeaderBlock = (_ indexPath: Int,_ status: Bool) ->()


class PRPoetryListHeaderView: UIView {
    
    var bgView: UIView!
    
    var titleLabel = UILabel()
    var nameLabel = UILabel()
    
    var img = UIImageView(image: UIImage(named: "pr_icon_arrow_up"))
    
    var indexPath: Int = 0
    
    var clickBtn: kPoetryListHeaderBlock!
    
    var iconImg: UIImageView!
    
    var foldStatus: Bool = true {
        didSet{
            if foldStatus{
                
                img.image = UIImage(named: "pr_icon_poetryarro_up")
                
            }else{
                
                img.image = UIImage(named: "pr_icon_poetryarro_down")
                
            }
        }
    }
    
    
    init(model: PRPoetryModelResult, indexPath: Int){
        super.init(frame: CGRect.zero)
        
        titleLabel =  LabelFactory.makeLabel(font: UIFont.systemFont(ofSize: 16, weight: .medium), textColor: UIColor.init(hexString: "#666666"), textAlignment: .center, text: model.njName + model.fasciculeName)
        nameLabel =  LabelFactory.makeLabel(font: UIFont.systemFont(ofSize: 18, weight: .regular), textColor: UIColor.init(hexString: "#000000"), textAlignment: .center, text: "语文（统编版）")
        iconImg = UIImageView()
        if model.thumbnail.count > 0{
            iconImg.kf.setImage(with: URL(string: model.thumbnail))
        }
        
        
        self.setUI()
        
        self.indexPath = indexPath
        self.backgroundColor = UIColor.init(hexString: "#F8F9FD")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        bgView = UIView()
        bgView.backgroundColor = .white

        
        self.addSubview(bgView)
        bgView.addSubview(iconImg)
        bgView.addSubview(nameLabel)
        bgView.addSubview(titleLabel)
        bgView.addSubview(img)
        
        bgView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(12)
        })
        iconImg.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(160)
        })
        nameLabel.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(bgView.snp_centerY).offset(-6)
            make.left.equalTo(iconImg.snp_right).offset(10)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp_centerY).offset(6)
            make.left.equalTo(iconImg.snp_right).offset(10)
        }
        img.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        let btn = UIButton(type: .custom)
        bgView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        btn.backgroundColor = .clear
        btn .addTarget(self, action: #selector(clickFunctionBtn(sender: )), for: .touchUpInside)

    }
    
    func changeBgView(){
        if foldStatus{
            
            bgView.createShapeLayer(withRoundingCorners: [.allCorners] , cornerRadii: CGSize(width: 11, height: 11))
        }else{
            bgView.createShapeLayer(withRoundingCorners: [.topLeft, .topRight] , cornerRadii: CGSize(width: 11, height: 11))
            
        }
    }
    
    @objc func clickFunctionBtn(sender: BookEditStateButton){
        if clickBtn != nil {
            clickBtn(indexPath, foldStatus)
        }
    }
    
}
