//
//  YSAudioUserManager.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "YSAudioUserManager.h"


#define __access_token_Key  @"access_token_Key"
#define __access_token  [[NSUserDefaults standardUserDefaults] valueForKey:__access_token_Key]
#define __kIS_NOT_EMPTY(string) (string !=nil && [string isKindOfClass:[NSString class]] && ![string isEqualToString:@""] && ![string isEqualToString:@"(null)"])
#define __kIS_NO_EMPTY_OBJ(obj) (obj != nil && ![[NSNull null] isEqual:obj])
@implementation YSAudioUserManager

+ (instancetype)shareYSAudioUserManager{
    static YSAudioUserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getAccessToken{
    return __access_token;
}

- (YSAudioUserInfoModel *)getUserInfoModel
{
    NSData *archData = [[NSUserDefaults standardUserDefaults] objectForKey:@"YSUserInfoModelKey"];
    if (__kIS_NO_EMPTY_OBJ(archData)) {
        NSError *err = nil;
        YSAudioUserInfoModel * userModel = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[YSAudioUserInfoModel.class,NSString.class]] fromData:archData error:&err];
        if (err == nil)
            return userModel;
    }
    return nil;
}

//是否登录
- (BOOL)isLogin{
    if (__kIS_NOT_EMPTY(__access_token)) {
        return true;
    }
    return false;
}

- (void)login{
    [[NSUserDefaults standardUserDefaults] setObject:@"50661973646216912935778635787400147124579783140712229186815754033346448149325236218026021333123962836531945824971428778499370287811918318414898169176601023703095285223482243312236950515642253917795184098155600085699604300029445321788186995986545139173035940675005601541762211503156178885620450581569025731119" forKey:@"access_token_Key"];
}

@end
