//
//  LabelFactory.swift
//  PEPRead
//
//  Created by 李沛倬 on 2020/1/8.
//  Copyright © 2020 PEP. All rights reserved.
//

import UIKit

class LabelFactory {
    
    class func makeLabel(font : UIFont? = UIFont.systemFont(ofSize: 13),
                   textColor : UIColor? = UIColor.black,
                   textAlignment : NSTextAlignment? = .left,
                   backgroundColor: UIColor? = UIColor.clear,
                   text : String? = nil) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment ?? .left
        label.backgroundColor = backgroundColor
        label.text = text
        
        return label
    }
    
    class func makeToastTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#FFFFFF")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()

        return label
    }
    
    // Normal create Label
    class func makeNormalLabel(title : String? = nil,backgroundColor : UIColor? = nil, textColor : UIColor? = nil, font : UIFont? = nil, textAlignment : NSTextAlignment? = nil) -> UILabel{
        let label = UILabel()
        label.backgroundColor = (backgroundColor != nil) ? backgroundColor : UIColor.clear
        label.textColor = (textColor != nil) ? textColor : UIColor.textThemeColorWhite
        label.font = (font != nil) ? font : UIFont.systemFont(ofSize: 12)
        label.textAlignment = (textAlignment != nil) ? textAlignment!  : .left
        label.text = title
        
        return label
    }
    
    class func makeUserInfoNameLabel(title : String) -> UILabel{
        let label = makeNormalLabel(title: title, backgroundColor: nil, textColor: nil, font: UIFont.boldSystemFont(ofSize: 18), textAlignment: nil)
        return label;
    }
    
    class func makeUserInfoOtherLabel(title : String) -> UILabel {
        let label = makeNormalLabel(title: title, backgroundColor: nil, textColor: nil, font: UIFont.systemFont(ofSize: 14), textAlignment: nil)
        return label;
    }
    
    class func makeUpdateTitleLabel(title : String) -> UILabel {
        let label = makeNormalLabel(title: title, backgroundColor: nil, textColor: UIColor.textThemeColorBlack, font: UIFont.systemFont(ofSize: 18), textAlignment: nil)
        return label;
    }
}
