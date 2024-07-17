//
//  PRHttpUtil.h
//  PEPRead
//
//  Created by liudongsheng on 2017/10/23.
//  Copyright © 2017年 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PEPNetworking/PEPNetworking.h>

typedef void(^HttpSuccessBlock) (id JSON);
typedef void(^HttpFailureBlock) (NSError *error);
typedef void(^HttpProgressBlock) (NSProgress *downLoadProgress);

@interface PRHttpUtil : NSObject

+ (void)configHttpHeader:(NSDictionary *)httpHeader;
/**
 post请求 -请求数据使用AFJSONRequestSerializer
 
 @param path 请求路径
 @param params 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

/**
 get请求 -请求数据使用AFJSONRequestSerializer
 
 @param path 请求路径
 @param params 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

///  post请求-数据使用AFHTTPResponseSerializer格式返回
/// @param path
/// @param params
/// @param progress
/// @param success
/// @param failure
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params progress:(HttpProgressBlock)progress success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
/**
 get请求-数据使用AFHTTPResponseSerializer格式返回
 
 @param path 请求地址
 @param params 请求参数
 @param progress 请求进程
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params progress:(HttpProgressBlock)progress success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;


//json入参放置到body提交
+ (void)postWithPath:(NSString *)path arrayBody:(NSArray *)arrayBody success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
//json入参放置到body提交
+ (void)postWithPath:(NSString *)path dicBody:(NSDictionary *)dicBody success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
//入参放置到body提交
+ (void)postWithPath:(NSString *)path stringbody:(NSString *)bodyStr success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

/// 根据mp4地址获取m3u8地址
/// @param url mp4地址
/// @param success 返回m3u8地址
/// @param fail error
//+(void)obtainM3u8Url:(NSString*)url :(void(^)(NSString *videoUrl))success :(void(^)(NSError *error))fail;

+(NSString*)rsaWithCiphertext:(NSString*)str;
@end
