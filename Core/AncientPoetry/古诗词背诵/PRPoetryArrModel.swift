//
//  PRPoetryArrModel.swift
//  PEPRead
//
//  Created by sunShine on 2023/12/28.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
class PRPoetryArrModel{
    var wordIndex: Int = 0
    
    var word: String = ""
    
    var wordPinyin: String = ""
    
    var is_mate = false
    
    
    var wordHash: Int = 0
    func findWordWithHash(hash: Int, arr: Array<PRPoetryArrModel>) ->Int{
        for model in arr {
            if model.wordHash == hash{
                return model.wordIndex
            }
        }
        return 0
    }
    
}
