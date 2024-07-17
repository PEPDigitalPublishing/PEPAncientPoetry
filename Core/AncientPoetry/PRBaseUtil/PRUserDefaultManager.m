//
//  PRUserDefaultManager.m
//  PEPRead
//
//  Created by 韩帅 on 2022/5/7.
//  Copyright © 2022 PEP. All rights reserved.
//

#import "PRUserDefaultManager.h"


@implementation PRCountProgressModel
@end


@implementation PRUserDefaultManager


+ (instancetype)shareInstance {
    static PRUserDefaultManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PRUserDefaultManager.alloc init];
    });
    
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        // SDK测评数据埋点通知
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(evaluateDataStatistics:) name:@"PRYMMobClickNotification" object:nil];
    }
    return self;
}


-(void)setAudioPlayProportion:(NSString*)audioUrl time:(NSInteger)time{
    NSString *key = [NSString stringWithFormat:@"PRAudioPlayProportion_%@",audioUrl];
    [NSUserDefaults.standardUserDefaults setInteger:time forKey:key];
    
}
-(NSInteger)getAudioPlayProportion:(NSString*)audioUrl{
    NSString *key = [NSString stringWithFormat:@"PRAudioPlayProportion_%@",audioUrl];
    NSInteger time = [NSUserDefaults.standardUserDefaults integerForKey:key];
    return time;
}

-(void)setAudioPlayTime:(NSString*)audioUrl time:(NSInteger)time{
    NSString *key = [NSString stringWithFormat:@"PRAudioPlayTime_%@",audioUrl];
    [[MMKV defaultMMKV]setInt64:time forKey:key];
}
-(NSInteger)getAudioPlayTime:(NSString*)audioUrl{
    NSString *key = [NSString stringWithFormat:@"PRAudioPlayTime_%@",audioUrl];
    NSInteger time = [[MMKV defaultMMKV]getInt64ForKey:key];
    return time;
}


//背诵的隔句提示
-(BOOL)getBeisongStatus{
    NSString *key = [NSString stringWithFormat:@"PRBeisongStatus"];
    BOOL status = [[MMKV defaultMMKV]getBoolForKey:key];
    [[MMKV defaultMMKV]setBool:!status forKey:key];
    return status;
}

//背诵的模式 0 - 1 - 2
-(int)getBeisongConfig{
    NSString *key = [NSString stringWithFormat:@"PRBeisongConfig"];
    int value = [[MMKV defaultMMKV]getInt32ForKey:key];
    return value;
}
-(void)setBeisongConfig:(int)value{
    NSString *key = [NSString stringWithFormat:@"PRBeisongConfig"];
    [[MMKV defaultMMKV]setInt32:value forKey:key];

}
@end
