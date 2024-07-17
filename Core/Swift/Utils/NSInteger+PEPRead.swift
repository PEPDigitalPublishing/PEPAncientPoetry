//
//  NSInteger+PEPRead.swift
//  PEPRead
//
//  Created by sunShine on 2023/2/22.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
extension NSInteger {
    func getTimeStrStyleOne() -> String{
        let minute:Double = Double(self) / 3600.0
        let minuteStr = minute > 0 ?String(format: "%.1f", minute):"0"
        return minuteStr
    }
    func getTimeStrStyleTwo() -> String {
        ///时
        let hours = Int(self / 3600)
        ///分
        let minute = Int((self - hours*3600)/60)
        let hoursStr = hours > 0 ?(String(hours) + "小时"):""
        let minuteStr = minute > 0 ?(String(format: "%d", minute) + "分钟"):"0分钟"
        let timeString = hoursStr + minuteStr
        return timeString
    }
    func getTimeStrStyleThree() -> String {
        var timeUnit  = "小时"
        var timeStr: String = "";
        if self >= 600{
            let hour:Double = Double(self) / 3600.0
            timeStr = String(format: "%.1f", hour)
        }else if self >= 60 {
            let minute: Int = self / 60
            timeStr = String(minute)
            timeUnit = "分钟"
        }else if self >= 10{
            timeStr = String(self)
            timeUnit = "秒"
        }else{
            return ""
        }
        return timeStr + timeUnit
    }
}
