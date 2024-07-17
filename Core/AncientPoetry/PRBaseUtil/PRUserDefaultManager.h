//
//  PRUserDefaultManager.h
//  PEPRead
//
//  Created by 韩帅 on 2022/5/7.
//  Copyright © 2022 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMKV/MMKV.h>
NS_ASSUME_NONNULL_BEGIN

static NSString * const PRNotificationNameClickPoetryword = @"PRNotificationNameClickPoetryword";

@interface PRCountProgressModel : NSObject
@property(nonatomic,assign)BOOL is_change;/**<  */
@property(nonatomic,assign)NSInteger progress;/**<  */
@end

@interface PRUserDefaultManager : NSObject

+ (instancetype)shareInstance;

// 音频最大播放时长
-(void)setAudioPlayProportion:(NSString*)audioUrl time:(NSInteger)time;
-(NSInteger)getAudioPlayProportion:(NSString*)audioUrl;

//音频时长存贮---可被重置
-(void)setAudioPlayTime:(NSString*)audioUrl time:(NSInteger)time;
-(NSInteger)getAudioPlayTime:(NSString*)audioUrl;

//背诵的隔句提示
-(BOOL)getBeisongStatus;
//背诵的模式
-(int)getBeisongConfig;
-(void)setBeisongConfig:(int)value;


//+(void)setPoetryScoreData:(int)score chapterID:(NSString*)chapterID;
//+(int)getPoetryScoreDataWithChapterID:(NSString*)chapterID;
@end

NS_ASSUME_NONNULL_END
