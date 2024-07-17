//
//  UIImage+Color.swift
//  PEPRead
//
//  Created by 韩帅 on 2021/12/21.
//  Copyright © 2021 PEP. All rights reserved.
//

import Foundation

extension UIImage{
    
    ///用颜色创建一张图片
   static func creatColorImage(_ color:UIColor,_ ARect:CGRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)) -> UIImage {

       let renderer = UIGraphicsImageRenderer(size: ARect.size)
               
       let image = renderer.image { (context) in
           color.setFill()
           let path = UIBezierPath(roundedRect: ARect, cornerRadius: 0.0)
           path.addClip()
           UIRectFill(ARect)
       }
       return image
    }
    
}
