//  央视等音频播放
//  PoetryPlayViewController.h
//  PEPRead
//
//  Created by liudongsheng on 2018/7/4.
//  Copyright © 2018年 PEP. All rights reserved.
//
#import "PoetryModel.h"
#import "PRAudioPlayerControl.h"
#import "BaseAncientPoetryViewController.h"

@interface PoetryPlayViewController : BaseAncientPoetryViewController
//h5点击的音频title
@property (nonatomic, copy) NSString *res_title;
//h5点击的音频地址
@property (nonatomic, copy) NSString *mp3;

@property (nonatomic, copy) NSString *from;

@property(nonatomic,strong)NSString *bookID;/**<  */


//
+(NSInteger)findTruePreAudioItem:(int)currentIndex dataArr:(NSArray<PoetryModel*>*)dataArray;
+(NSInteger)findTrueNextAudioItem:(int)currentIndex dataArr:(NSArray<PoetryModel*>*)dataArray;
+(NSInteger)calculationTimeWithAudioIndex:(int)audioIndex :(NSInteger)countDownOptionIndex :(AudioPlayerControlPlayingMode) playingMode dataArr:(NSArray<PoetryModel*>*)dataArray;

@end
