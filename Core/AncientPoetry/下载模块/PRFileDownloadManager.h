//
//  PRFileDownloadManager.h
//  PEPRead
//
//  Created by sunShine on 2024/1/25.
//  Copyright © 2024 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRFileDownloadManager : NSObject
/// 异步下载多个文件,然后回调
/// - Parameters:
///   - urlArr: 文件下载地址
///   - successBlock: 返回文件地址数组
+(void)downloadFile:(NSArray <NSString*> *)urlArr 
            success:(void(^)(NSArray <NSString*> *filePathArr))successBlock
               fail:(void(^)(NSError *error))failBlock;

@end

NS_ASSUME_NONNULL_END
