//
//  YSAudioUserManager.h
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import "YSAudioUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSAudioUserManager : NSObject

+ (instancetype)shareYSAudioUserManager;


/** 获取用户信息 */
- (YSAudioUserInfoModel *)getUserInfoModel;
//是否登录
- (BOOL)isLogin;
//获取access_token
- (NSString *)getAccessToken;

- (void)login;

@end

NS_ASSUME_NONNULL_END
