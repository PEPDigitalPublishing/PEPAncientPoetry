//
//  PRPoetryListCell.swift
//  PEPRead
//
//  Created by sunShine on 2023/9/1.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
import SnapKit

class PRPoetryListCell: UITableViewCell{
    var bgView: UIView!
    var lineView: UIView!
    var title: UILabel = UILabel()
    var desLabel: UILabel = UILabel()
    var model = PRPoetryModelData.init() {
        didSet{
            self.configData()
        }
    }
    var isSel = false{
        didSet{
            changeCellBg()
        }
    }
    var isSearchCell = false
    var arrImg = UIImageView.init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupSubviews() {
        self.contentView.backgroundColor = UIColor.init(hexString: "#F8F9FD")
        bgView = UIView()
        bgView.backgroundColor = .white
    
        
        title.font = .systemFont(ofSize: 18, weight: .medium)
        
        desLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        title.textColor = UIColor(hexString: "#000000")
        desLabel.textColor = UIColor(hexString: "#666666")
        title.text = ""
        desLabel.text = ""
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(0)
        })
        
        bgView.addSubview(desLabel)
        bgView.addSubview(title)
       
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(16)
        }
        desLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp_bottom).offset(10)
            make.left.equalToSuperview().offset(16)
        }
        
        lineView = UIView.init()
        lineView.backgroundColor = UIColor.init(hexString: "#E5E5EB")
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalTo(title)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let arrImg = UIImageView(image: UIImage(named: "rightarrow_black"))
        arrImg.isHidden = true
        bgView.addSubview(arrImg)
        arrImg.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(6)
        }
    }
    func changeCellBg(){
    
//        self.contentView.backgroundColor = isSel ? UIColor.init(red: 53/255.0, green: 199/255.0, blue: 156/255.0, alpha: 0.3) : UIColor.white
//        self.bgView.backgroundColor = isSel ? UIColor.init(red: 53/255.0, green: 199/255.0, blue: 156/255.0, alpha: 0.3) : UIColor.white
    }
    func configData(){
        self.title.text = self.model.title
        if let dynastyName = self.model.dynastyName , dynastyName.count > 0{
            self.desLabel.text = "[\(dynastyName)]\(self.model.writer ?? "")"
        }else{
            self.desLabel.text = "\(self.model.writer ?? "")"
        }
        if isSearchCell {
            arrImg.isHidden = false
        }else{
            arrImg.isHidden = true
        }
    
    }

}
