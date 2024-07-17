//
//  NSString+PEPClassroom.m
//  PEPClassroom
//
//  Created by liudongsheng on 2019/7/18.
//  Copyright © 2019 PEP. All rights reserved.
//

#import "NSString+AudioAncientPoetry.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * const kURLEncodeParameter = @"!*'();@&=+$,%#[]";

NSString *PCLocalizedString(NSString *key) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:nil];
}

@implementation NSString (AudioAncientPoetry)

- (NSString *)clearNil{
    NSString* str =self;
    if(self == nil){
        str = @"";
    }
    return str;
}
- (NSString *)URLEncode {
    NSString *encodedString = [self URLEncodeStringWithParameter:kURLEncodeParameter];
    
    return encodedString;
}

- (NSString *)URLEncodeStringWithParameter:(NSString *)parameter {
    NSCharacterSet *characterSet = NSCharacterSet.alphanumericCharacterSet;
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    
    return encodedString;
}


- (BOOL)pep_isBlankString {
    if (self == nil || self == NULL) {
        return NO;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

-(BOOL)pep_judgePassword{
    BOOL result  = false;
    if (self) {
        NSString *regex;
        regex = @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[a-zA-Z0-9]{8,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        result = [pred evaluateWithObject:self];
        return  result;
    }else{
        return result;
    }
}

-(NSString *)stringBuilder{
    NSString * newSting = [self copy];
    if ([self containsString:@"&"]){
        newSting = [newSting stringByReplacingOccurrencesOfString:@"&" withString:@"&"];
    }else if ([self containsString:@"<"]){
        newSting = [newSting stringByReplacingOccurrencesOfString:@"<" withString:@"<"];
    }else if ([self containsString:@">"]){
        newSting = [newSting stringByReplacingOccurrencesOfString:@">" withString:@">"];
    }else if ([self containsString:@""]){
        newSting = [newSting stringByReplacingOccurrencesOfString:@"" withString:@" "];
    }else if ([self containsString:@"\""]){
        newSting = [newSting stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
    }
    return newSting;
}

/**
 计算字符串高度
 */
- (CGFloat)calculateHeightWithFont:(UIFont*)font andWidth:(CGFloat)width
{
    if (self.length < 1) {
        return 0;
    }
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGFloat height = rect.size.height + 1;
    return height;
}

- (CGFloat)calculateHeightWithSize:(CGFloat)size andWidth:(CGFloat)width
{
    if (self.length < 1) {
        return 0;
    }
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    CGFloat height = rect.size.height + 1;
    return height;
}

/**
 计算字符串宽度
 */
- (CGFloat)calculateWidthWithSize:(CGFloat)size andHeight:(CGFloat)height
{
    if (self.length < 1) {
        return 0;
    }
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    CGFloat width = rect.size.width + 1;
    return width;
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

- (NSString*)rj_URLEncodeString {
    NSString *encodedString = [self rj_URLEncodeStringWithParameter:kURLEncodeParameter];
    
    return encodedString;
}

- (NSString*)rj_URLEncodeStringWithParameter:(NSString *)parameter {
    NSCharacterSet *characterSet = NSCharacterSet.alphanumericCharacterSet;
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    
    return encodedString;
}

- (NSString *)rj_md5String {
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end
