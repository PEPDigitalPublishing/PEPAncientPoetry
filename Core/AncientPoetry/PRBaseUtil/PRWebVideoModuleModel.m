//
//  PRWebVideoModuleModel.m
//  PEPRead
//
//  Created by 韩帅 on 2022/1/18.
//  Copyright © 2022 PEP. All rights reserved.
//

#import "PRWebVideoModuleModel.h"

@implementation PRWebVideoModuleModel
-(NSString *)code{
    if (_code.length <= 0) {
        return @"";
    }else{
        return _code;
    }
}
-(NSString *)label{
    if (_label.length > 0) {
        NSArray *tempArr = [_label componentsSeparatedByString:@","];
        NSString *tempStr = @"";
        if (tempArr.count > 0) {
            for (NSString *str in tempArr) {
                if (str.length > 0) {
                    tempStr = [[tempStr stringByAppendingString:[@"#" stringByAppendingString:str]] stringByAppendingString:@" "];
                }
            }
            
            return tempStr;
        }else{
            return _label;
        }
    }else{
        return @"";
    }
}
@end
