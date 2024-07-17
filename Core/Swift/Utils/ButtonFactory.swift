//
//  ButtonFactory.swift
//  PEPRead
//
//  Created by 李沛倬 on 2020/1/8.
//  Copyright © 2020 PEP. All rights reserved.
//

import UIKit


class ButtonFactory {
    

  
    class func makeSelectedBox(normalImg: String ,selecededImg: String ) -> UIButton{
        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(named: normalImg), for: .normal)
        button.setImage(UIImage.init(named: selecededImg), for: .selected)
        return button
    }
    
    class func makeOtherLoginTypeButton(image: UIImage) -> UIButton {
          let button = UIButton(type: .custom)
          button.setImage(image, for: .normal)
          return button
      }
    
    


    class func makeNoBackgroundButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.theme, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitle(title, for: .normal)

        return button
    }

    
    
 
  
    class func makeShowDetailsButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setTitle(title, for: .normal)
        button.isEnabled = false
        
        return button
    }
    
    class func makeChangeAccountButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.theme, for: .normal)
        button.setTitleColor(UIColor.theme, for: .selected)
        button.setTitleColor(UIColor.theme, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitle(title, for: .normal)
        
        return button
    }
    
    
    
    class func makeConformUpdate(title:String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.backgroundColor = UIColor.theme
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitle(title, for: .normal)
        button .setBackgroundImage(UIImage.init(named: "lightgreen"), for: .normal)
        return button
    }
    
    
    class func makeNormalButton(title: String,ImageName: String? = nil,titleColor: UIColor? = UIColor.theme,font: UIFont? = UIFont.systemFont(ofSize: 16)) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        if ImageName?.isEmpty == false {
            button.setImage(UIImage.init(named: ImageName!), for: .normal)
            button.setImage(UIImage.init(named: ImageName!), for: .highlighted)
        }
        button.setTitle(title, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }
    
    class func makeImageLeftButton(title: String,ImageName: String,titleColor: UIColor? = UIColor.theme,font: UIFont? = UIFont.systemFont(ofSize: 13)) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(titleColor, for: .normal)
        
        button.titleLabel?.font = font
        button.setImageAndTitle(imageName: ImageName, title: title, type: .Positionleft, Space: 5)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
    class func makeBookEditStateButton(title: String,ImageName: String? = nil,titleColor: UIColor? = UIColor.theme,font: UIFont? = UIFont.systemFont(ofSize: 16), type: EditState) -> UIButton {
        let button = BookEditStateButton.init(type: .custom)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        if ImageName?.isEmpty == false {
            button.setImage(UIImage.init(named: ImageName!), for: .normal)
        }
        button.backgroundColor = UIColor.clear
        button.setTitle(title, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.type = type
        return button
    }
    
    class func makeAddAuthBookButton() -> UIButton{
        let button = UIButton.init(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setBackgroundImage(UIImage.init(named: "authbook_add"), for: .normal)
        button.setBackgroundImage(UIImage.init(named: "authbook_added"), for: .disabled)
        button.backgroundColor = UIColor.clear
        button.setTitle("点击添加", for: .normal)
        button.setTitle("已添加", for: .disabled)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    class func makeStartStudyButton() -> UIButton{
        let button = UIButton.init(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = UIColor.init(named: "#35C79C")
        button.setTitle("开始学习", for: .normal)
        return button
    }
}


class BookEditStateButton: UIButton {
    var type = EditState(rawValue: 0)
}

enum EditState : Int{
    case Edit = 0
    case Cancel = 1
    case Delete = 2
    case Add = 3
}










/*
枚举 设置 图片的位置
*/
enum ButtonImagePosition : Int{
 
    case PositionTop = 0
    case Positionleft
    case PositionBottom
    case PositionRight
}

extension UIButton {
/**
imageName:图片的名字
title：button 的名字
type ：image 的位置
Space ：图片文字之间的间距
*/
    func setImageAndTitle(imageName:String,title:String,type:ButtonImagePosition,Space space:CGFloat)  {
        if imageName.count > 0{
            self.setImage(UIImage(named:imageName), for: .normal)
        }
        if title.count > 0 {
            self.setTitle(title, for: .normal)
        }
        
        
        
        let imageWith :CGFloat = (self.imageView?.frame.size.width)!;
        let imageHeight :CGFloat = (self.imageView?.frame.size.height)!;
      
        var labelWidth :CGFloat = 0.0;
        var labelHeight :CGFloat = 0.0;

        labelWidth = CGFloat(self.titleLabel!.intrinsicContentSize.width);
        labelHeight = CGFloat(self.titleLabel!.intrinsicContentSize.height);

        var  imageEdgeInsets :UIEdgeInsets = UIEdgeInsets();
        var  labelEdgeInsets :UIEdgeInsets = UIEdgeInsets();
       
        switch type {
        case .PositionTop:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space/2.0, left: 0, bottom: 0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight-space/2.0, right: 0);
            break;
        case .Positionleft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0);
            break;
        case .PositionBottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWith, bottom: 0, right: 0);
            break;
        case .PositionRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith-space/2.0, bottom: 0, right: imageWith+space/2.0);
            break;
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
    
}
