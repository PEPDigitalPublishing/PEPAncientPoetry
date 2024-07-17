//
//  UIView+Extension.swift
//  PEPRead
//
//  Created by iMac_pephan on 2020/12/25.
//  Copyright © 2020 PEP. All rights reserved.
//

import Foundation

extension UIView {

    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    

    func roundCorners(corners: UIRectCorner, rect: CGRect? = nil , radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
         layer.mask = mask
    }
    
    func noCornerMask() {
        layer.mask = nil
 
    }
    
    
    func drawShadow(rect: CGRect? = nil) {
        let path = UIBezierPath(rect: rect ?? bounds)

        
        // now configure the background view layer with the shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.init(width: 1, height: 0)
        layer.shadowRadius = 2.5
        layer.shadowOpacity = 0.2
        layer.shadowPath = path.cgPath
        layer.masksToBounds = false
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}
extension UIViewController {
    static func currentViewController() -> UIViewController? {
        // 获取应用的根视图控制器
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        // 递归查找当前显示的非 UITabBarController 和非 UINavigationController 的视图控制器
        func findCurrentViewController(from viewController: UIViewController) -> UIViewController? {
            if let presentedViewController = viewController.presentedViewController {
                // 如果当前控制器是模态呈现的，继续递归查找
                return findCurrentViewController(from: presentedViewController)
            } else if let selectedViewController = (viewController as? UITabBarController)?.selectedViewController {
                // 如果当前控制器是 UITabBarController，继续查找选中的控制器
                return findCurrentViewController(from: selectedViewController)
            } else if let visibleViewController = (viewController as? UINavigationController)?.visibleViewController {
                // 如果当前控制器是 UINavigationController，继续查找可见的控制器
                return findCurrentViewController(from: visibleViewController)
            } else {
                // 其他情况下返回当前控制器
                return viewController
            }
        }
        
        // 调用递归方法查找当前显示的非 UITabBarController 和非 UINavigationController 的视图控制器
        return findCurrentViewController(from: rootViewController)
    }
}


