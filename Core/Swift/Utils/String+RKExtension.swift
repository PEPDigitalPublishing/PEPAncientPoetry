//
//  String+RKExtension.swift
//  RKExtensions-Swift
//
//  Created by 李沛倬 on 2018/7/8.
//  Copyright © 2018年 peizhuo. All rights reserved.
//

import Foundation


// MARK: - Regex

extension String {
    // MARK: - Public Methods
    /// 判断一个字符串中是否包含指定的字符串
    func contains(_ text: String) -> Bool {
        return self.range(of: text)?.lowerBound == nil ? false : true
    }
    //计算每张图片高度
    func getImageURLHeight(imageSource : CGImageSource) -> CGFloat {
        //                let imageSource = CGImageSourceCreateWithURL(URL(string: item)! as CFURL, nil)
        if let result = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? Dictionary<String, Any> {
            if let width = result["PixelWidth"] as? CGFloat,let height = result["PixelHeight"] as? CGFloat {
                //宽度为屏幕宽度，高度根据比例自适应
                return height*UIScreen.main.bounds.size.width/width
            }
        }
        return 0
    }
    /// 判断字符串中是否匹配到传入的正则表达式的字符串
    func containsOfRegex(_ regex: String) -> Bool {
        if let rangeArr = self.rangesOfRegex(regex) {
            return rangeArr.count > 0
        }
        return false
    }
    
    /// 返回传入的正则表达式匹配到的第一个字符串的range
    func firstMatchedOfRegex(_ regex: String) -> NSRange? {
        let regular = self.getRegularExpression(regex)
        let result = regular?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.count-1))
        return result?.range
    }
    
    /// 找出字符串中匹配传入的正则表达式的字符串，以数组的形式返回匹配到的字符串集合
    func componentsMatchedOfRegex(_ regex: String) -> [String]? {
        let rangeArr = self.rangesOfRegex(regex)
        if rangeArr == nil { return nil }
        
        var returnArr = [String]()
        for range in rangeArr! {
            let text = self as NSString
            returnArr += [text.substring(with: range) as String]
        }
        return returnArr
    }
    
    /**
     根据传入的正则表达式查询字符串中匹配到的字符串Range信息，以数组形式返回
     - parameter regex: 正则表达式字符串
     - returns: NSRange数组
     */
    func rangesOfRegex(_ regex: String) -> [NSRange]? {
        let regular = self.getRegularExpression(regex)
        if regular == nil { return nil }
        
        let matches = regular!.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count-1))
        var rangeArr = [NSRange]()
        for result in matches {
            rangeArr += [result.range]
        }
        
        return rangeArr
    }
    
    /// 用『replaceString』替换掉满足传入的正则表达式的所有字符串，并返回替换后的字符串
    func replacingOccurencesOfRegex(_ regex: String, replaceString: String) -> String {
        return self.replacingOccurencesOfRegex(regex, replaceString: replaceString, searchRange: NSMakeRange(0, self.count))
    }
    
    /// 用『replaceString』替换掉满足传入的正则表达式的所有字符串，并返回替换后的字符串
    func replacingOccurencesOfRegex(_ regex: String, replaceString: String, searchRange: NSRange) -> String {
        let regular = getRegularExpression(regex)
        let resultStr = regular?.stringByReplacingMatches(in: self, options: .reportCompletion, range: searchRange, withTemplate: replaceString)
        
        return resultStr ?? self;
    }
    
    /// 将指定range范围内的内容替换为指定的字符串
    func replacingStringInRange(_ range: NSRange, withString: String) -> String {
        return NSString(string: self).replacingCharacters(in: range, with: withString)
    }
    
    /**
     将JSON字符串转换成字典
     */
    func jsonStrToDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                return dic as? [String: AnyObject]
            } catch {
                print_debug(error)
            }
        }
        return nil
    }
    
    
    /// 判断当前字符串是否为邮箱
    ///
    /// - Returns: 为邮箱返回true，否则返回false
    func isEmail() -> Bool {
        return getMatchCountWithRegex(regex: .Email) > 0 ? true : false
    }
    
    /// 判断当前字符串是否为纯数字（包括正负整数和小数）。
    /// 形如123、-123、123.02、-123.08都判定为纯数字
    /// - Returns: 为纯数字返回true，否则返回false
    func isNumber() -> Bool {
        return getMatchCountWithRegex(regex: .number) > 0 ? true : false
    }
    
    /// 判断当前字符串是否为手机号
    ///
    /// - Returns: 为手机号返回true，否则返回false
    func isPhoneNumber() -> Bool {
        let cn = getMatchCountWithRegex(regex: .phoneNumber) > 0
        if cn == false {
            let hk = getMatchCountWithRegex(regex: .phoneNumber_HK) > 0
            
            if hk == false {
                let mk = getMatchCountWithRegex(regex: .phoneNumber_MK) > 0
                
                if mk == false {
                    let tw = getMatchCountWithRegex(regex: .phoneNumber_TW) > 0
                    
                    return tw
                } else { return true }
            } else { return true }
        } else { return true }
        
//        return getMatchCountWithRegex(regex: .phoneNumber) > 0 ? true : false
    }
    
    /// 判断当前字符串是否是有效的密码
    func isAvailablePassword() -> Bool {
        return getMatchCountWithRegex(regex: .passwordAvailable) > 0
    }
    
    
    // MARK: - Private Methods
    fileprivate func getMatchCountWithRegex(regex: RegexString) -> Int {
        let regular = getRegularExpression(regex.rawValue)
        return regular?.numberOfMatches(in: self, options: .reportProgress, range: NSMakeRange(0, self.count)) ?? 0
    }
    
    fileprivate func getRegularExpression(_ regex: String) -> NSRegularExpression? {
        var regexR: NSRegularExpression?
        do {
            regexR = try NSRegularExpression.init(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            regexR = nil
            print_debug("ERROR!!")
        }
        
        return regexR
    }
    
    func toNSRangeWithString(_ str: String) -> NSRange {
        if let range = self.range(of: str) {
            let nsrange = NSRange(range, in: self)
            return nsrange
        }else{
            return NSMakeRange(0, 0)
        }
        
        }
    
    
}



// MARK: - URLEncode & URLDecode

extension String {
    func urlencode(_ string: String) -> String {
        var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: "!*'\"();:@&=+$,/?%#[]% ")
        return string.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey) ?? string
    }
    func urlEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? self
    }
    
    func urlDecode() -> String {
        return self.removingPercentEncoding ?? self
    }
    // 手机号和密码的加密
    func phoneNumberRsaWithPublicKey() -> String {
        if self.count <= 0 {
            return ""
        }
        var tempStr = PEPRSA.encryptString(self, publicKey: "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKvU/PqVsVaD4gWPn/0cH2MGeikTNCl70qEAsg21No0fB32TZ0jHIbblL+ocP8eyMH6Mp/4jKTuCIa3qZtAy8KUCAwEAAQ==")
        tempStr = "JszX/Dd+".appending(tempStr)
        return tempStr
        
    }
    func phoneNumberDecryptWithRsaWithPriKey() -> String {
        if self.count <= 0 {
            return ""
        }
        if self.range(of: "JszX/Dd+")?.lowerBound == nil{
            return ""
        }
        var tempStr = self.replacingOccurrences(of: "JszX/Dd+", with: "")
        tempStr = PEPRSA.decryptString(tempStr, privateKey: "MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEAq9T8+pWxVoPiBY+f/RwfYwZ6KRM0KXvSoQCyDbU2jR8HfZNnSMchtuUv6hw/x7Iwfoyn/iMpO4Ihrepm0DLwpQIDAQABAkAIc04JqMjy30ODUH/mu7ZTcWMamAYtsBg4sMcQ44OORw6sUU/bssnVBNx4PiGExPrOQBRReDB0tub6VdrOukJhAiEA5DkfZuCLlswfVT1Ky1dZCy7SNy6HLYQ1iPLdLunWAc0CIQDAvtrE1aJwzNo6iamuCGpWEAkHwxk/twhP4BQyX3yyOQIgHFp0akWPUga+Bcr9ldGeQGNqvmxLYv4/4Gm7zO5EJikCIQCmBH4o5p5ZLImXvDVz2nnFEWDF180qrTuymR6sWMTuOQIhALpYfZTzIwzTbAjD8Z6sBrYr16TVVGFW0HHxI8Pr2kmF")
        return tempStr
        
    }
    
    func toBase64() -> String? {
        if let data = self.data(using: .utf8){
            return data.base64EncodedString()
        }
        return nil
        
    }
    func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
}


// MARK: - =~运算符重载
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input,
                                    options: [],
                                    range: NSMakeRange(0, input.count))
        return matches.count > 0
    }
}


/// 正则表达式
///
/// - Email: 邮箱正则
/// - number: 数字正则（包括形如123、-123、123.02、-123.08的正负整数和小数）
/// - phoneNumber: 手机号正则
/// - phoneNumber_HK: 中国香港手机号正则
/// - phoneNumber_MK: 中国澳门手机号正则
/// - phoneNumber_TW: 中国台湾手机号正则
/// - passwordAvailable: 符合要求的密码正则
enum RegexString: String {
    case Email          = "^[a-z\\d]+(\\.[a-z\\d]+)*@([\\da-z](-[\\da-z])?)+(\\.{1,2}[a-z]+)+$"
    case number         = "^(\\d+|-\\d+)\\d*(.?\\d+|\\d*)$"
    case phoneNumber    = "^(13|14|15|16|17|18|19)[0-9]{9}$"
    case phoneNumber_HK = "^(\\+852)[569]\\d{7}$"
    case phoneNumber_MK = "^(\\+853)6\\d{7}$"
    case phoneNumber_TW = "^(\\+886)9\\d{8}$"
    case passwordAvailable = "^(?![a-zA-Z0-9]+$)(?![^a-zA-Z]+$)(?![^0-9]+$).{8,20}$"
}

/// =~运算符可使用正则表达式，返回一个bool值用于判断=~左边的字符串是否满足右边的正则表达式
infix operator =~ : regex

precedencegroup regex {
    associativity: none
    lowerThan: AdditionPrecedence
}


func =~(lhs: String, rhs: String) -> Bool {
    return (try? RegexHelper(rhs).match(lhs)) ?? false
}


//sha1加密
extension String{
    func HMAC_Sign(algorithm: CCHmacAlgorithm, keyString: String, dataString: String) -> String {
        if algorithm != kCCHmacAlgSHA1 && algorithm != kCCHmacAlgSHA256 {
            print("Unsupport algorithm.")
            return ""
        }
        
        let cKeyString = keyString.cString(using: .utf8)
        let cDataString = dataString.cString(using: .utf8)
        
        let len = algorithm == CCHmacAlgorithm(kCCHmacAlgSHA1) ? CC_SHA1_DIGEST_LENGTH : CC_SHA256_DIGEST_LENGTH
        
        var cHMAC = [UInt8](repeating: 0, count: Int(len))
        CCHmac(algorithm, cKeyString, keyString.count, cDataString, dataString.count, &cHMAC)
        
        /// 原结果二进制数据Base64编码
        //let data = Data(bytesNoCopy: &cHMAC, count: Int(len), deallocator: Data.Deallocator.none)
        let data = Data(bytes: &cHMAC, count: Int(len))
        let base64String = data.base64EncodedString()
        
        return base64String
    }

}

extension String {
    func pr_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func pr_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func pr_heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
    func pr_oc_getHeight(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        if self.isEmpty {
            return 0.0
        }
        
        let h = NSString.getHeightLine(with: self, withWidth: width, with: UIFont.systemFont(ofSize: fontSize))
        
        return h
    
    }
}








