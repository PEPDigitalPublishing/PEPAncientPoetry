//
//  NSString+PEPRead.h
//  PEPRead
//
//  Created by 李沛倬 on 2018/6/4.
//  Copyright © 2018年 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (PEPRead)

- (NSString *)URLEncode;

- (NSString *)PEP_md5String;
+(NSString *)MD5ForLower32Bate:(NSString *)str;

/** 将以秒为单位的数值转化为「x小时x分钟」、「x分钟」、「x秒」形式 */
+ (NSString *)PEP_formatTimeString:(NSInteger)seconds;

/** 将以秒为单位的数值转化为「01:20:30」、「12:34」、「00:23」形式 */
+ (NSString *)PEP_formatTimeProgressString:(int)seconds;

/** 通过一周内天数的下标返回该天数的描述，如：1 = 星期一 */
+ (NSString *)PEP_weekdayWithIndex:(int)index;
/** 判断字符串是否是纯数字 */
+ (BOOL)isNumText:(NSString *)str;


/// 计算文本高度
/// @param string 文本内容
/// @param width 限制的宽度
/// @param font 字体
+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;


/// 计算一行文本宽度
/// @param string 文本内容
/// @param font 字体
+ (CGFloat)getWidthLineWithString:(NSString *)string withFont:(UIFont *)font;
@end
