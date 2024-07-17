//
//  NSString+PEPClassroom.h
//  PEPClassroom
//
//  Created by liudongsheng on 2019/7/18.
//  Copyright © 2019 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *PCLocalizedString(NSString *key);

@interface NSString (AudioAncientPoetry)

- (NSString *)clearNil;

- (NSString *)URLEncode;

/**
 判断字符串为空
 @return 返回bool类型
 */
- (BOOL)pep_isBlankString;

/**
 验证字符串 ，是否符合8-20个字符，数字，字母，符号组合
 @return 返回bool类型
 */
-(BOOL)pep_judgePassword;

/**
 返回过滤xss代码，防止入侵
 @return 返回bool类型
 */
-(NSString *)pep_stringBuilder;

/**
 计算字符串高度
 */
- (CGFloat)calculateHeightWithSize:(CGFloat)size andWidth:(CGFloat)width;
- (CGFloat)calculateHeightWithFont:(UIFont*)font andWidth:(CGFloat)width;

/**
 计算字符串宽度
 */
- (CGFloat)calculateWidthWithSize:(CGFloat)size andHeight:(CGFloat)height;

/** 将以秒为单位的数值转化为「01:20:30」、「12:34」、「00:23」形式 */
+ (NSString *)PEP_formatTimeProgressString:(int)seconds;

- (NSString *)rj_URLEncodeString;

- (NSString *)rj_md5String;

@end

NS_ASSUME_NONNULL_END
