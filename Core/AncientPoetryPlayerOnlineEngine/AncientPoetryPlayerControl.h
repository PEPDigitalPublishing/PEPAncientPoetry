//
//  AudioPlayerControl.h
//  PEPRead
//
//  Created by 李沛倬 on 2019/11/26.
//  Copyright © 2019 PEP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AncientPoetryPlayerOnlineEngine.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AudioPlayerControlPlayingMode) {
    AudioPlayerControlPlayingModeSingleOnce,
    AudioPlayerControlPlayingModeSingleCycle,
    AudioPlayerControlPlayingModeListCycle,
};
typedef NS_ENUM(NSUInteger, AudioPlayerPopupMode) {
    AudioPlayerPopupList,
    AudioPlayerPopupCountDownOption,
};

typedef NS_ENUM(NSUInteger, AudioPlayerUIMode) {
    AudioPlayerUIModeNormal = 0,
    AudioPlayerUIModeGreen,
    AudioPlayerUIModeEnglish,
};

@protocol AudioPlayerControlPlayingDelegate;

@interface AncientPoetryPlayerControl : UIView

@property (nonatomic, strong) AncientPoetryPlayerOnlineEngine *playerEngine;

@property (nonatomic, assign) BOOL cleanSlider;

@property (nonatomic, weak) id<AudioPlayerControlPlayingDelegate> delegate;

@property (nonatomic, assign, readonly) AudioPlayerControlPlayingMode playingMode;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UIButton *prevButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *back10sBtn;

@property (weak, nonatomic) IBOutlet UIButton *forward10sBtn;

/** 选中状态为正在播放中，未选中状态为未播放 */
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *playModeButton;

@property (weak, nonatomic) IBOutlet UILabel *loopLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loopImg;

@property (weak, nonatomic) IBOutlet UIImageView *repeatImg;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playModeImg;
@property (weak, nonatomic) IBOutlet UILabel *playModeText;

@property (weak, nonatomic) IBOutlet UILabel *playSpeedText;

@property (weak, nonatomic) IBOutlet UIView *playSpeedTextBg;

@property (weak, nonatomic) IBOutlet UIButton *playSpeedBtn;
@property (weak, nonatomic) IBOutlet UIView *playMenuView;
@property (weak, nonatomic) IBOutlet UIView *playShowTimeView;

@property (weak, nonatomic) IBOutlet UIButton *audioListBtn;
@property (weak, nonatomic) IBOutlet UIButton *countDownBtn;

@property (weak, nonatomic) IBOutlet UILabel *countDownTimeL;
@property (weak, nonatomic) IBOutlet UIImageView *countDownTimeImg;
//定时相关
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *counDownImg;

@property(nonatomic,assign)NSInteger audioTimes;/**<  要播放的集数  0默认值不处理   11代表一遍 12代表2遍 13代表3遍*/

//控制条view
@property (weak, nonatomic) IBOutlet UIView *menuView;
//工具条
@property (weak, nonatomic) IBOutlet UIView *toolView;


@property (nonatomic , assign)AudioPlayerUIMode uiModel;



- (void)playAudioWithURLString:(NSString *)url;

//旧样式
- (void)configOldStyle;
//英语样式
- (void)configEnglishStyle;

-(void)configCountDown:(NSInteger)time;

- (void)resetPlayingProgressAndPlayStatus;
@end




@protocol AudioPlayerControlPlayingDelegate <NSObject>

@optional

 /**
 播放器已经开始播放
  */
- (void)audioPlayerDidPlaying;

/**
 播放器播放完成后将回调该代理方法
 
 @param flag 如果为true，说明成功播放完成。若为false，说明播放被中断
 */
- (void)audioPlayerDidFinishPlayingSuccessfully:(BOOL)flag;

/**
 播放器播放进度回调
 
 @param currentTime 当前播放时间
 @param duration 总时间
 */
- (void)audioPlayerProgressTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;

/**
 播放器播放错误将会回调该代理方法
 
 @param errorMessage 错误信息
 */
- (void)audioPlayerPlayError:(NSString *)errorMessage;

- (void)audioPlayerPlayButtonStatus:(NSInteger )status;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl playButtonAction:(UIButton *)sender;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl prevButtonAction:(UIButton *)sender;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl nextButtonAction:(UIButton *)sender;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl playModeButtonAction:(UIButton *)sender;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl settingButtonAction:(UIButton *)sender;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl forwardButtonAction:(UIButton *)sender;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl rewindButtonAction:(UIButton *)sender;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl currentSpeed:(CGFloat)speed;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl popupMode:(AudioPlayerPopupMode)mode;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl changePlayMode:(AudioPlayerControlPlayingMode)playMode;

- (void)audioPlayerControlWithCountDownFinished:(AncientPoetryPlayerControl *)audioPlayerControl;

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl repeatModel:(UIButton *)button;

@end


NS_ASSUME_NONNULL_END
