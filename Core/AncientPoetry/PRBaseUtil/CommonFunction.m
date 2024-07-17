//
//  CommonFunction.m
//  PEPRead
//
//  Created by iMac_pephan on 2021/1/12.
//  Copyright © 2021 PEP. All rights reserved.
//

#import "CommonFunction.h"
#import <sys/utsname.h>

@implementation CommonFunction


+ (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    if (window.subviews.count == 0) {
        return nil ;
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}
+ (NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}
+ (NSString *)getDeviceType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    //TODO:iPhone
    /*2007年1月9日，第一代iPhone 2G发布；

         2008年6月10日，第二代iPhone 3G发布 [1]；

         2009年6月9日，第三代iPhone 3GS发布 [2]；

         2010年6月8日，第四代iPhone 4发布；

         2011年10月4日，第五代iPhone 4S发布；

         2012年9月13日，第六代iPhone 5发布；

         2013年9月10日，第七代iPhone 5C及iPhone 5S发布；

         2014年9月10日，第八代iPhone 6及iPhone 6 Plus发布；

         2015年9月10日，第九代iPhone 6S及iPhone 6S Plus发布；

         2016年3月21日，第十代iPhone SE发布；

         2016年9月8日，第十一代iPhone 7及iPhone 7 Plus发布；

         */
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]
        || [platform isEqualToString:@"iPhone9,3"])     return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]
        || [platform isEqualToString:@"iPhone9,4"])     return @"iPhone7Plus";
    //2017年9月13日，第十二代iPhone 8，iPhone 8 Plus，iPhone X发布
    if ([platform isEqualToString:@"iPhone10,1"]
        || [platform isEqualToString:@"iPhone10,4"])    return @"iPhone8";
    if ([platform isEqualToString:@"iPhone10,2"]
        || [platform isEqualToString:@"iPhone10,5"])    return @"iPhone8Plus";
    if ([platform isEqualToString:@"iPhone10,3"]
        || [platform isEqualToString:@"iPhone10,6"])    return @"iPhoneX";
    //2018年9月13日，第十三代iPhone XS，iPhone XS Max，iPhone XR发布
    if ([platform isEqualToString:@"iPhone11,2"])       return @"iPhoneXS";
    if ([platform isEqualToString:@"iPhone11,4"]
        || [platform isEqualToString:@"iPhone11,6"])    return @"iPhoneXSMax";
    if ([platform isEqualToString:@"iPhone11,8"])       return @"iPhoneXR";
    //2019年9月11日，第十四代iPhone 11，iPhone 11 Pro，iPhone 11 Pro Max发布
    if([platform isEqualToString:@"iPhone12,1"])  return @"iPhone 11";
    if([platform isEqualToString:@"iPhone12,3"])  return @"iPhone 11 Pro";
    if([platform isEqualToString:@"iPhone12,5"])  return @"iPhone 11 Pro Max";
    //2020年4月15日，新款iPhone SE发布
    if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE 2020";
    //2020年10月14日，新款iPhone 12 mini、12、12 Pro、12 Pro Max发布
    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    //2021年9月15日，新款iPhone 13 mini、13、13 Pro、13 Pro Max发布
    if ([platform isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([platform isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
    if ([platform isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
    if ([platform isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
    //2022年3月9日，新款iPhone SE发布
    if ([platform isEqualToString:@"iPhone14,6"]) return @"iPhone SE 2022";
    
    if ([platform isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";
    if ([platform isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";
    
    //TODO:iPod
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch (5 Gen)";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod touch (6th generation)";
    //2019年5月发布，更新一种机型：iPod touch (7th generation)
    if ([platform isEqualToString:@"iPod9,1"]) return @"iPod touch (7th generation)";
    
    //TODO:iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"]
        || [platform isEqualToString:@"iPad2,2"]
        || [platform isEqualToString:@"iPad2,3"]
        || [platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"]
        || [platform isEqualToString:@"iPad3,2"]
        || [platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]
        || [platform isEqualToString:@"iPad3,5"]
        || [platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
    if ([platform isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
    if ([platform isEqualToString:@"iPad7,5"]
        || [platform isEqualToString:@"iPad7,6"])   return @"iPad (6th generation)";
    if ([platform isEqualToString:@"iPad7,11"]
        || [platform isEqualToString:@"iPad7,12"])   return @"iPad (7th generation)";
    if ([platform isEqualToString:@"iPad11,6"]
        || [platform isEqualToString:@"iPad11,7"])   return @"iPad (8th generation)";
    if ([platform isEqualToString:@"iPad12,1"]
        || [platform isEqualToString:@"iPad12,2"])   return @"iPad (9th generation)";
    
    //TODO:iPad Air
    if ([platform isEqualToString:@"iPad4,1"]
        || [platform isEqualToString:@"iPad4,2"]
        || [platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"]
        || [platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad11,3"]
        || [platform isEqualToString:@"iPad11,4"])  return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad13,1"]
        || [platform isEqualToString:@"iPad13,2"])  return @"iPad Air 4";
    if ([platform isEqualToString:@"iPad13,16"]
        || [platform isEqualToString:@"iPad13,17"])  return @"iPad Air 5";
    
    //TODO:iPad mini
    if ([platform isEqualToString:@"iPad2,5"]
        || [platform isEqualToString:@"iPad2,6"]
        || [platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad4,4"]
        || [platform isEqualToString:@"iPad4,5"]
        || [platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"]
        || [platform isEqualToString:@"iPad4,8"]
        || [platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"]
        || [platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad11,1"]
        || [platform isEqualToString:@"iPad11,2"])  return @"iPad mini (5th generation)";
    if ([platform isEqualToString:@"iPad14,1"]
        || [platform isEqualToString:@"iPad14,2"])  return @"iPad mini (6th generation)";
    
    //TODO:iPad Pro
    if ([platform isEqualToString:@"iPad6,7"]
        || [platform isEqualToString:@"iPad6,8"])   return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,3"]
        || [platform isEqualToString:@"iPad6,4"])   return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5 inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5 inch (Cellular)";
    if ([platform isEqualToString:@"iPad8,1"]
        || [platform isEqualToString:@"iPad8,2"]
        || [platform isEqualToString:@"iPad8,3"]
        || [platform isEqualToString:@"iPad8,4"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,5"]
        || [platform isEqualToString:@"iPad8,6"]
        || [platform isEqualToString:@"iPad8,7"]
        || [platform isEqualToString:@"iPad8,8"])   return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad8,9"]
        || [platform isEqualToString:@"iPad8,10"])  return @"iPad Pro (11-inch) (2nd generation)";
    if ([platform isEqualToString:@"iPad8,11"]
        || [platform isEqualToString:@"iPad8,12"])  return @"iPad Pro (12.9-inch) (4th generation)";
    if ([platform isEqualToString:@"iPad13,4"]
        || [platform isEqualToString:@"iPad13,5"]
        || [platform isEqualToString:@"iPad13,6"]
        || [platform isEqualToString:@"iPad13,7"])  return @"iPad Pro (11-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad13,8"]
        || [platform isEqualToString:@"iPad13,9"]
        || [platform isEqualToString:@"iPad13,10"]
        || [platform isEqualToString:@"iPad13,11"]) return @"iPad Pro (12.9-inch) (5th generation)";

    //TODO:模拟器
    if ([platform isEqualToString:@"i386"])         return @"iPhone 14 Pro";
    if ([platform isEqualToString:@"x86_64"])       return @"iPhone 14 Pro";
    return platform;
}


+ (int)getStatusBarHeight{
    CGFloat statusBarHeight = 0;
      if(@available(iOS 13.0, *)){
          UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
          CGFloat topPadding = window.safeAreaInsets.top;
          if(topPadding >0){
              statusBarHeight = topPadding;
          }else{
              statusBarHeight = 20;
          }
      } else {
          statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
      }
    NSLog(@"statu高度%f",statusBarHeight);
      return statusBarHeight;
}


@end
