//
//  PRFileDownloadManager.m
//  PEPRead
//
//  Created by sunShine on 2024/1/25.
//  Copyright © 2024 PEP. All rights reserved.
//

#import "PRFileDownloadManager.h"
#import "NSString+PEPRead.h"
#import "AFNetworking.h"


@implementation PRFileDownloadManager
+(void)downloadFile:(NSArray <NSString*> *)urlArr success:(void(^)(NSArray <NSString*> *filePathArr))successBlock fail:(void(^)(NSError *error))failBlock{
    NSArray *checkArr = [PRFileDownloadManager checkfileDownloadStatus:urlArr];
    if (checkArr.count == urlArr.count) {
        //全部下载完毕
        successBlock(checkArr);
        return;
    }
    
    //准备路径
   
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    for (NSString *urlStr in urlArr) {
        if (urlStr.length <= 0) {
            continue;
        }
        NSString *fileName = [NSURL URLWithString:urlStr].lastPathComponent;
        NSString *md5Name = [fileName PEP_md5String];
        NSString *onlineBookPath = @"";//getDocumentsDirectoryFilePath
        NSString *filePathInOnlineCache = [onlineBookPath stringByAppendingPathComponent:fileName];
        NSLog(@"%@", onlineBookPath);
//        if ([PEPFileUtility fileExists:filePathInOnlineCache]) {        // 在线缓存目录中存在该音频
//            continue;
//        }

        dispatch_group_async(group, queue, ^{
           //准备异步任务
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
             
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
             
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {

                NSURL *fileURL = [NSURL fileURLWithPath:filePathInOnlineCache];
                return fileURL;
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//                if (error) {
//                    NSLog(@"Download failed: %@", error);
//                } else {
//                    NSLog(@"Download succeeded. File path: %@", filePath);
//                }
                dispatch_semaphore_signal(semaphore);
            }];
             
            [downloadTask resume];
            dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC);

            dispatch_semaphore_wait(semaphore, t);
            
        });
        
        
    }
    dispatch_group_notify(group, queue, ^{
        //还是要去检查文件是否下载
        
        NSLog(@"任务完成执行");
        NSArray *arr = [PRFileDownloadManager checkfileDownloadStatus:urlArr];
        if (arr.count == urlArr.count) {
            //全部下载完毕
            successBlock([arr copy]);
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorNoPermissionsToReadFile userInfo:@{NSLocalizedDescriptionKey:@"下载失败，请检查后重试"}];
            failBlock(error);
        }
    });
    
    
}
+(NSArray <NSString*> *)checkfileDownloadStatus:(NSArray <NSString*> *)urlArr{
    
    NSMutableArray <NSString*>*arrM = [NSMutableArray array];
    for (NSString *urlStr in urlArr) {
        if (urlStr.length <= 0) {
            continue;
        }
        NSString *fileName = [NSURL URLWithString:urlStr].lastPathComponent;
//        NSString *onlineBookPath = [PEPFileManager shareManager].poetryDir;
//        NSString *filePathInOnlineCache = [onlineBookPath stringByAppendingPathComponent:fileName];
//        if ([PEPFileUtility fileExists:filePathInOnlineCache]) {        // 在线缓存目录中存在该音频
//            [arrM addObject:filePathInOnlineCache];
//        }
    }
    return  [arrM copy];
    
}
@end
