//
//  SaveValue.swift
//  PEPRead
//
//  Created by iMac_pephan on 2020/11/18.
//  Copyright © 2020 PEP. All rights reserved.
//

import Foundation

@objcMembers class SaveValue: NSObject {
    class func savePhoneNumber(newNumber : String) {
        guard let accountList = UserDefaults.standard.object(forKey: kUserDefaults_PhoneNumberList) as? [String] else {
            let firstNumberArray : [String] = [newNumber]
            UserDefaults.standard.setValue(firstNumberArray, forKey: kUserDefaults_PhoneNumberList)
            return
        }
        
        var phoneNumberList = accountList
        var repet = false
        if phoneNumberList.isEmpty {
            phoneNumberList.append(newNumber)
            UserDefaults.standard.setValue(phoneNumberList, forKey: kUserDefaults_PhoneNumberList)
        }else{
            for item in phoneNumberList {
                if newNumber == item {
                    repet = true
                    break
                }
            }
            if !repet {
                phoneNumberList .insert(newNumber, at: 0)
                if phoneNumberList.count > 5 {
                    phoneNumberList .removeLast()
                }
                UserDefaults.standard.setValue(phoneNumberList, forKey: kUserDefaults_PhoneNumberList)
            }
        }
    }
    class func setUpPhoneNumber() {
        let firstNumberArray : [String] = []
        UserDefaults.standard.setValue(firstNumberArray, forKey: kUserDefaults_PhoneNumberList)
    }
}
