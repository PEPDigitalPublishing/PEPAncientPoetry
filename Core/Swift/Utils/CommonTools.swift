//
//  CommonTools.swift
//  PEPRead
//
//  Created by iMac_pephan on 2020/11/24.
//  Copyright © 2020 PEP. All rights reserved.
//

import Foundation

class CommonTools: NSObject {
     
    
}


extension CommonTools{
    
    /// 返回最上层viewController
    /// - Parameter base: 基于viewcontroller 可为空
    /// - Returns: 最上层viewController
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

           if let nav = base as? UINavigationController {
               return getTopViewController(base: nav.visibleViewController)

           } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
               return getTopViewController(base: selected)

           } else if let presented = base?.presentedViewController {
               return getTopViewController(base: presented)
           }
           return base
       }
    
    
    class func getCurrentView(){
        
    }
}
extension CommonTools{
    class func printWithTimestamp(_ message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        let timestamp = dateFormatter.string(from: Date())
        print("\(timestamp) \(message)")
    }
}
