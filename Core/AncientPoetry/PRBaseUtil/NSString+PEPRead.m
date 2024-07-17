//
//  NSString+PEPRead.m
//  PEPRead
//
//  Created by 李沛倬 on 2018/6/4.
//  Copyright © 2018年 PEP. All rights reserved.
//

  
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const kURLEncodeParameter = @"!*'();@&=+$,%#[]";

@implementation NSString (PEPRead)

- (NSString*)URLEncode {
    NSString *encodedString = [self URLEncodeStringWithParameter:kURLEncodeParameter];
    
    return encodedString.length>0?encodedString:@"";
}

- (NSString*)URLEncodeStringWithParameter:(NSString *)parameter {
    NSCharacterSet *characterSet = NSCharacterSet.alphanumericCharacterSet;
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    return encodedString;
}

- (NSString *)PEP_md5String {
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}
+(NSString *)MD5ForLower32Bate:(NSString *)str{

    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}



+ (NSString *)PEP_formatTimeString:(NSInteger)seconds {
    NSString *timeString = @"0分钟";
    
    NSInteger hour = seconds / 3600;
    NSInteger min = seconds % 3600 / 60;
    NSInteger s = seconds % 3600 % 60;
    
    if (hour > 0) {
        timeString = [NSString stringWithFormat:@"%ld小时%ld分钟", hour, min];
    } else if (min > 0) {
        timeString = [NSString stringWithFormat:@"%ld分钟", min];
    } else if (seconds > 0) {
        timeString = [NSString stringWithFormat:@"%ld秒", s];
    }
    
    return timeString;
}

+ (NSString *)PEP_formatTimeProgressString:(int)seconds {
    NSString *timeString = @"00:00";
    
    int hour = seconds / 3600;
    int min = seconds % 3600 / 60;
    int s = seconds % 3600 % 60;
    
    if (hour > 0) {
        timeString = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, s];
    } else if (min > 0) {
        timeString = [NSString stringWithFormat:@"%02d:%02d", min, s];
    } else if (seconds > 0) {
        timeString = [NSString stringWithFormat:@"00:%02d", s];
    }
    
    return timeString;
}

+ (NSString *)PEP_weekdayWithIndex:(int)index {
    if (index <= 0 || index > 7) { return nil; }
    
    NSArray<NSString *> *weekdays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    
    return weekdays[index-1];
}

+ (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"(/^[0-9]*$/)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}
+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:0];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}
+ (CGFloat)getWidthLineWithString:(NSString *)string withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(1000, font.lineHeight);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:0];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat width = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.width;
    
    return width;
}
@end
