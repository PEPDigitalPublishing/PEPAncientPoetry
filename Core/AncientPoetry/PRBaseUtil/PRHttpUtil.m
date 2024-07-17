//
//  PRHttpUtil.m
//  PEPRead
//
//  Created by liudongsheng on 2017/10/23.
//  Copyright © 2017年 PEP. All rights reserved.
//

#import "PRHttpUtil.h"
#import <YYModel/YYModel.h>
  
#import "PEPRSA.h"
static NSDictionary     *headers;
@implementation PRHttpUtil

+ (void)configHttpHeader:(NSDictionary *)httpHeader{
    headers = httpHeader;
}
/**
 post请求
 
 @param path 请求路径
 @param params 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+(void)postWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.connectionProxyDictionary = @{};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = 30;

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[
                                                                              @"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"
                                                                              ]];
    
    
    [manager POST:path parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        PEPLog(@"%@",error.localize÷dDescription);
        failure(error);
    }];
}
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.connectionProxyDictionary = @{};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
//    manager.responseSerializer =[AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.requestSerializer.cachePolicy =NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    [manager GET:path parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        PEPLog(@"%@",error.localizedDescription);
        failure(error);
        
    }];
}


+ (void)postWithPath:(NSString *)path arrayBody:(NSArray *)arrayBody success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.connectionProxyDictionary = @{};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题

    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil]];
  
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"URLString:path parameters:nil error:nil];
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    [request addValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    NSData *body  = [arrayBody yy_modelToJSONData];
    
    [request setHTTPBody:body];
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
//            PEPLog(@"%@",error.localizedDescription);
            failure(error);
        }else{
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                success(dic);
            }else{
                success(responseObject);
            }
        }
    }] resume];
}
+ (void)postWithPath:(NSString *)path dicBody:(NSDictionary *)dicBody success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.connectionProxyDictionary = @{};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
   
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil]];
    
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"URLString:path parameters:nil error:nil];
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    [request addValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    
    NSData *body  = [NSJSONSerialization dataWithJSONObject:dicBody options:NSJSONWritingPrettyPrinted error:nil];

    [request setHTTPBody:body];
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
//            PEPLog(@"%@",error.localizedDescription);
            failure(error);
        }else{
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                success(dic);
            }else{
                success(responseObject);
            }
        }
    }] resume];
}
+ (void)postWithPath:(NSString *)path stringbody:(NSString *)bodyStr success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.connectionProxyDictionary = @{};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil]];
  
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"URLString:path parameters:nil error:nil];
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    [request addValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    
    NSData *body  = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
//            PEPLog(@"%@",error.localizedDescription);
            failure(error);
        }else{
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                success(dic);
            }else{
                success(responseObject);
            }
        }
    }] resume];
}

/**
 post请求-数据使用AFHTTPResponseSerializer格式返回
 
 @param path 请求地址
 @param params 请求参数
 @param progress 请求进程
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params progress:(HttpProgressBlock)progress success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.connectionProxyDictionary = @{};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.requestSerializer.cachePolicy =NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    [manager POST:path parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        PEPLog(@"%@",error.localizedDescription);
        failure(error);
        
    }];
    
}

/**
 get请求
 
 @param path 请求地址
 @param params 请求参数
 @param progress 请求进程
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params progress:(HttpProgressBlock)progress success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.connectionProxyDictionary = @{};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
//    manager.responseSerializer =[AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.requestSerializer.cachePolicy =NSURLRequestReloadIgnoringLocalAndRemoteCacheData;

    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    [manager GET:path parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        PEPLog(@"%@",error.localizedDescription);
        failure(error);
        
    }];
    
}
/** 解决服务器返回json中内容为单引号(')无法正常解析的问题 */
+ (id)reformatJSONObject:(NSData *)data {
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    id responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    return responseJSON;
}

//+(void)obtainM3u8Url:(NSString*)url :(void(^)(NSString *videoUrl))success :(void(^)(NSError *error))fail{
//    if (![url.lastPathComponent hasSuffix:@".mp4"] && ![url.lastPathComponent hasSuffix:@".MP4"]) {
//        fail([NSError new]);
//        return;
//    }
//    NSString *urlString = PRURLStringWith(PRURLStringByReplaceUserIDWithKey(kQueryVideoM3u8Url));
//    urlString = [urlString stringByReplacingOccurrencesOfString:@"<ak>" withString:kRJReadSDK_AppKey];
//    urlString = [urlString stringByReplacingOccurrencesOfString:@"<token>" withString:[[PRUserInfoManager shareManager].userInfo.access_token URLEncode]?:@""];
//    urlString = [urlString stringByReplacingOccurrencesOfString:@"<videoUrl>" withString:url?:@""];
//    [PRHttpUtil postWithPath:urlString params:nil success:^(id JSON) {
//        NSLog(@"");
//        NSString *errcode = [JSON objectForKey:@"errcode"];
//        if ([errcode isEqualToString:@"110"]) {
//            NSDictionary *result = [JSON objectForKey:@"result"];
//            NSString *m3u8Url = [result objectForKey:@"m3u8Url"];
//            if (m3u8Url.length > 0) {
//                success(m3u8Url);
//            }else{
//                fail([NSError new]);
//            }
//        }else{
//            fail([NSError new]);
//        }
//    } failure:^(NSError *error) {
//        fail(error);
//    }];
//}
+(NSString*)rsaWithCiphertext:(NSString*)str{
    NSString *privkey = @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC/IXJU3kWeCFLR8MSpq4rdVIGp1cPgIXk3wZgouDhtzCsgYh9X2L8HF1zz8dmbIoZtdGG2CyfZerS+r2qn7qwe3omngG0X7rn9cvca05ovUzhwihXo44tetKfxSMjs2UIgBEY2sl74wglGEh0Cobp7WlHZ6QpVgnetp8Otl3uL53mEvaI0uMIw7TuUUgyM3fOQgmS8emSPUmT6vWyF3g7lcTIT0DWJYiXQdu36b4YSGn8wPoUOnm9qVREaS7cfYUV36PT4t//mGNySuxzNCsWt/E3rOoG1otyQLQ7WE26/qqkgk0TvAeKZ0884blZH5L/IouILJVI5Xt+ug/nl6BHfAgMBAAECggEAGnUWzoi2OloMnOMnVhVY86pvCIN+ydfYX898sKZPqWNJ1QHANPjb+K9TPrGL3d25ng0uOXTx3zkNLBg8O2LekKddhsJQV6/EL0Fq01vXTBXJCksTHVniQQng9ZWNuruYW7Y7wfaPDwBNKFX5jhO1LL4j9nY75/pXdsJyY+VEROlYnsC1kg34nnTWc0NKXjn4S6h1WIRyaLKQFAXlSo4Eec2WdrczenNfz27Qzqzs3SRaQWJdDDq949FpM2TfhjYq/l7ZVkZ0hKJneOZY+DElzZIIR2H2vCm6XfRS/VfWyu6J/5+0mTj6LigDLF+Jg8mSIkdsy4/XOgr5xA1t222KAQKBgQDq/H0fvGbmsmHY2BRZmPj1BbjSAX7I7LWv+KfiGXnR73uWLj9vHsxZ56tkk5yrV2Z0KVFFVCISUbG+RErS67oYA4W/UEe8lx/OeITmxaz0l1fc8jnzoxrH8KBAKtxbN+SukWhmuQUTIxSycdx2nyKeCQ2Dsej3KijyAlDH3yL5UQKBgQDQOPn0K3cH14/DIKaDgKPLXSoqaBUI+oOggT0Cgmvw42PEaQSFzixOw8+X66DdJ3ryCGBs6wcjy+ch8D6qGNqdTGC8D2LdaINS3N6RRdbgBirSrqrSwMwSmbesTs3CokLnpeuJ+ujZMg6J6ilpRcr+pgefu05WQ/lR7tGeIuSMLwKBgC82ATGSGZ558lyttRD3QfWAa8yNjlpx7GLpc1liwu3hzpOywP3jUy0w9WdknNJz4dquvmxOZfYGQc63S80qnR3b/1Abof4K4tIJtrHiv0f47Ccw52HCwEuxVZDuy4zsIt7LygzxWUqp/quHYsLWYA8eRH/UC7k02DsfKfmuJAmxAoGAKtZ9/hDvJSrhBcjy2P0fNZiOMzlEkptPdzb/gUOpx15QyTi92HVpQi8gx2WPq9ASiDbW97GGv4OUorPVgJMqbtAm2qnjsh9tXR/ZnlOa+G3sY3nR5RgLJAyB8C4qQM+3KgdFpRZ8zypwOUl2iZT1RVyNFvynCjJj2cpjT8Bn+rsCgYBx9R2J0SbS+KrTFd5yTeD3pnlzlc7nZ9GOsovYn1UQfPjXKCyas2AfsAp/TaT2XHFEh77KittuMfv/+nVHfQmN4rulZX0jUcRT5YoZwsftii/ysj1FBrmaS+Yyoja2ZKHHe5I89GrL5WDVs/fNjdq+gvMa47zHpFYfelzyjYqdGA==";

    NSString *temp = [PEPRSA decryptString:str privateKey:privkey];
    return temp;
}
@end
