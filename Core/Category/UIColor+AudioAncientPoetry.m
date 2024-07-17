//
//  UIColor+AudioAncientPoetry.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "UIColor+AudioAncientPoetry.h"
#import <ChameleonFramework/Chameleon.h>

@implementation UIColor (AudioAncientPoetry)

static UIColor *themeColor = nil;

static UIColor *placehoderColor = nil;

static UIColor *redNoticeColor = nil;

static UIColor *navColor = nil;

static UIColor *tabBarTintColor = nil;

static UIColor *textThemeColorWhite = nil;

static UIColor *importantBackgroundColor = nil;

static UIColor *textThemeColorBlack = nil;

+ (UIColor *)themeColor {
    if (themeColor == nil) {
//        themeColor = [UIColor pc_colorWithRGBHex:0x24A973];
        themeColor = [UIColor colorWithHexString:@"#20ACB1"];
    }
    return themeColor;
}

+(UIColor *)placehoderColor{
    if (placehoderColor == nil) {
        placehoderColor = [UIColor colorWithHexString:@"#F7F7FE"];
    }
    return placehoderColor;
}

+ (UIColor *)redNoticeColor{
    if (redNoticeColor == nil){
        redNoticeColor = [UIColor colorWithHexString:@"#FD5E5E"];
    }
    return redNoticeColor;
}

+ (UIColor *)navColor {
    if (themeColor == nil) {
//        themeColor = [UIColor pc_colorWithRGBHex:0x55C97E];
        themeColor = [UIColor colorWithHexString:@"#0091a7"];
    }
    return themeColor;
}


+ (UIColor *)textThemeColorWhite {
    if (textThemeColorWhite == nil) {
        textThemeColorWhite = [UIColor pc_colorWithRGBHex:0xFFFFFF];
    }
    return textThemeColorWhite;
}


+ (UIColor *)importantBackgroundColor {
    if (importantBackgroundColor == nil) {
        importantBackgroundColor = [UIColor pc_colorWithRGBHex:0xEF596A];
    }
    return importantBackgroundColor;
}

+ (UIColor *)textThemeColorBlack {
    if (textThemeColorBlack == nil) {
        textThemeColorBlack = [UIColor pc_colorWithRGBHex:0x333333];
    }
    return textThemeColorBlack;
}

#pragma mark -评测模块颜色设置
+ (UIColor *)pc_colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end
