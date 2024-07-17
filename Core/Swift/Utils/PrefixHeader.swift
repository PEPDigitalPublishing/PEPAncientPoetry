//
//  PrefixHeader.swift
//  PEPRead
//
//  Created by 李沛倬 on 2020/1/14.
//  Copyright © 2020 PEP. All rights reserved.
//

import Foundation
import UIKit

///  DEBUG打印
///
///  - parameter message: 要打印的内容，可以为空
///  - parameter file:    所属文件
///  - parameter line:    行号
///  - parameter method:  所在方法名
func print_debug(_ message: Any! = "", file: String = #file, line: Int = #line, method: String = #function) {
    print("[\((file as NSString).lastPathComponent) -> \(method) -> \(line)]: \(message!)")
}


// MARK: - API

func URLString(with key: ServerAPI) -> String {
    return "https://rjyst.mypep.cn" + "/" + key.rawValue
}

func URLString(with key: String) -> String {
    return "https://rjyst.mypep.cn" + "/" + key
}

//func URLStringByReplaceUserID(with key: ServerAPI) -> String? {
//    guard let userid = __user_id else { return nil }
//    var str = PRServerBaseURL + "/" + key.rawValue
//    str = str.replacingOccurrences(of: "<userid>", with: userid)
//    
//    return str
//}


enum ServerAPI: String {
    
    case PR_API_poetryList = "cp/getList.anys"
    
    case PR_API_poetrySearch = "cp/getSearchKeyList.anys"
    
    case PR_API_poetryInfo = "cp/ak/rjyst/user/<userid>/signature.json"
    
    case PR_API_poetryInfo1 = "cp/ak/rjyst/<userid>/signature.json1"
}


// MARK: - Static

let screenScale = min(1.4, UIScreen.main.bounds.width/375.0)

let bundleID = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String

let signInWithAppleUser = "KSignInWithAppleUser"

let isiPad = UIDevice.current.model.hasPrefix("iPad")

let WIDTH_SWIFT = UIScreen.main.bounds.size.width

let HEIGHT_SWIFT = UIScreen.main.bounds.size.height

let isIphone:Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)

let isIphoneX:Bool = (isIphone && UIApplication.shared.statusBarFrame.size.height >= 44)

let NavBarH_SWIFT = isIphoneX ? 88 : 64

let bottomSafeBarH_SWIFT = isIphoneX ? 34 : 0

// MARK: - UserDefault key

let kUserDefaults_PhoneNumberList = "phoneNumberList"



