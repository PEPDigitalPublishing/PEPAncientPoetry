//
//  UIColor+AudioAncientPoetry.h
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIColor (AudioAncientPoetry)


/** 主题色：0x24A973 */
@property(class, nonatomic, readonly) UIColor *themeColor;

/** 主题色：0x24A973 */
@property(class, nonatomic, readonly) UIColor *placehoderColor;

/** 红色提示文字：0xFD5E5E */
@property(class, nonatomic, readonly) UIColor *redNoticeColor;

/** 导航栏背景色：0x55C97E */
@property(class, nonatomic, readonly) UIColor *navColor;

/** 文本主题色-白色：0xFFFFFF */
@property(class, nonatomic, readonly) UIColor *textThemeColorWhite;

/** 文本主题色-黑色：0x333333 */
@property(class, nonatomic, readonly) UIColor *textThemeColorBlack;

/** 强调背景色，红色：0xEF596A */
@property(class, nonatomic, readonly) UIColor *importantBackgroundColor;

+ (UIColor *)pc_colorWithRGBHex:(UInt32)hex;


@end

NS_ASSUME_NONNULL_END
