//
//  PRPoetrySearchBarView.swift
//  PEPRead
//
//  Created by sunShine on 2023/9/13.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
typealias kPRPoetrySearchBarViewBlock = (_ text: String) ->()
typealias kPRPoetrySearchBarViewPushBlock = () ->()

class PRPoetrySearchBarView: UIView ,UITextFieldDelegate{

    var textField = UITextField.init()
    
    var block: kPRPoetrySearchBarViewBlock!
    
    
    var searchItem = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
            
        self.setUI()
    
        self.backgroundColor = UIColor.clear// 设置背景色
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setUI() {
        let contentView = UIView.init()
         contentView.layer.cornerRadius = 17.5
         contentView.layer.masksToBounds = true
         contentView.backgroundColor = .white
         self.addSubview(contentView)
         contentView.addSubview(textField)
         contentView.snp.makeConstraints { make in
             make.right.equalToSuperview()
             make.left.equalToSuperview()
             make.bottom.equalToSuperview()
             make.top.equalToSuperview()
             
         }
         textField.returnKeyType = .search
         textField.backgroundColor = .white
         textField.placeholder = "请输入你想搜索的古诗词关键词"
         textField.delegate = self
         textField.font = UIFont.systemFont(ofSize: 14)
         textField.textColor = UIColor(hexString: "#666666")
         textField.tintColor = UIColor.theme
         textField.attributedPlaceholder = NSAttributedString(string: "请输入你想搜索的古诗词关键词", attributes: [.foregroundColor: UIColor.init(hexString: "666666")])
         textField.addTarget(self, action: #selector(textFieldChange(sender: )), for: .editingChanged)
         textField.snp.makeConstraints { (make) in
             make.right.equalToSuperview().offset(-54)
             make.left.equalToSuperview().offset(18)
             make.bottom.equalToSuperview().offset(-2)
             make.top.equalToSuperview().offset(2)
      
        }
       
         let lineView = UIView.init()
         lineView.backgroundColor = UIColor.init(hexString: "#666666")
         contentView.addSubview(lineView)
         lineView.snp.makeConstraints { make in
             make.right.equalToSuperview().offset(-54)
             make.bottom.equalToSuperview().offset(-10)
             make.top.equalToSuperview().offset(10)
             make.width.equalTo(1)
         }
         let btn = UIButton(type: .custom)
         contentView.addSubview(btn)
         btn.snp.makeConstraints { make in
             make.right.equalToSuperview().offset(-14)
             make.bottom.equalToSuperview().offset(0)
             make.top.equalToSuperview().offset(0)
             make.left.equalTo(lineView).offset(4)
         }
         btn.backgroundColor = .clear
         btn.setTitle("搜索", for: .normal)
         btn.setTitleColor(UIColor.init(hexString: "444444"), for: .normal)
         btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
         btn .addTarget(self, action: #selector(clickFunctionBtn(sender: )), for: .touchUpInside)

    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 300, height: 35)
    }
    @objc func clickFunctionBtn(sender: BookEditStateButton){
        textField.endEditing(true)
        if searchItem.count > 0{
            if block != nil {
                block(searchItem)
            }
        }else{
//            showPEPToast("搜索词不能为空!")
        }
        
    }
    @objc func textFieldChange(sender: UITextField){
        if let text = sender.text{
            searchItem = text
        }
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if pushBlock != nil {
//            pushBlock()
//        }
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if searchItem.count > 0{
            if block != nil {
                block(searchItem)
            }
        }else{
//            showPEPToast("搜索词不能为空!")
        }
        return true
    }
    
}
