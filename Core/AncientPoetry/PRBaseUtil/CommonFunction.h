//
//  CommonFunction.h
//  PEPRead
//
//  Created by iMac_pephan on 2021/1/12.
//  Copyright © 2021 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonFunction : NSObject

+ (UIViewController *)getCurrentUIVC;
+ (NSString *)getNowTimeTimestamp3;
+ (NSString *)getDeviceType;

+ (int)getStatusBarHeight;
@end

NS_ASSUME_NONNULL_END
