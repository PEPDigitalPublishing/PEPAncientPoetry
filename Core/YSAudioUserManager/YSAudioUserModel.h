//
//  YSAudioUserModel.h
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSAudioUserInfoModel : NSObject<NSSecureCoding>

/** 性别*/
@property (nonatomic , copy) NSString * sex_txt;
/** 用户名 (138****6492 )*/
@property (nonatomic , copy) NSString * reg_name;
/** 年级*/
@property (nonatomic , copy) NSString * grade_txt;
/** 性别number*/
@property (nonatomic , copy) NSString * sex;
/** 册number*/
@property (nonatomic , copy) NSString * fascicule;
/** 手机号(138****6492)*/
@property (nonatomic , copy) NSString * mobile;
/** 用户头像*/
@property (nonatomic , copy) NSString * head_image;
/** 年龄*/
@property (nonatomic , copy) NSString * age;
/** 用户id*/
@property (nonatomic , copy) NSString * user_id;
/** 册次 txt*/
@property (nonatomic , copy) NSString * fascicule_txt;
/** xxx*/
@property (nonatomic , copy) NSString * eng_ver;
/** 点数*/
@property (nonatomic , copy) NSString * point;
/** 昵称*/
@property (nonatomic , copy) NSString * nickname;
/** 年级*/
@property (nonatomic , copy) NSString * grade;
/** 名字*/
@property (nonatomic , copy) NSString * name;

@end

@interface YSAudioUserModel : NSObject<NSSecureCoding>

/** 状态*/
@property (nonatomic , copy) NSString * errcode;
/** 活跃时间(需要校验成日期格式)*/
@property (nonatomic , copy) NSString * active_time;
/** 用户信息*/
@property (nonatomic , strong) YSAudioUserInfoModel * user_info;
/** 错误信息*/
@property (nonatomic , copy) NSString * errmsg;
/** 用户token(有效期1年,登陆后刷新)*/
@property (nonatomic , copy) NSString * access_token;


@end

NS_ASSUME_NONNULL_END
