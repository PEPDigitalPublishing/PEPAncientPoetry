//
//  AncientPoetryPlayerOnlineEngine.h
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioPlayerOnlineEngineDelegate;

@interface AncientPoetryPlayerOnlineEngine : NSObject

@property (nonatomic, strong, readonly) AVPlayer *audioPlayer;

@property (nonatomic, weak) id<AudioPlayerOnlineEngineDelegate> delegate;

/** 播放速度。默认1.0。速度范围：0.5 ~ 2.0 */
@property (nonatomic, assign) CGFloat speed;

/** 音频播放地址 */
@property (nonatomic, copy, readonly) NSString *audioLink;

/** 是否处于暂停中 */
@property (nonatomic, assign, readonly, getter=isPausing) BOOL pausing;

+ (instancetype)shareInstance;

/** 播放音频 */
- (void)playAudioWithURLString:(NSString *)url;

/** 停止播放 */
- (void)stop;

/** 暂停播放 */
- (void)pause;

/** 恢复播放 */
- (void)resume;

/**重播 */
- (void)replay;

/**获取总时长 */
- (NSTimeInterval)getDurationTime;

/** 跳转到指定的播放位置 */
- (void)seekToTime:(int)time;

- (void)seekToTime:(int)time completionHandler:(void (^)(BOOL finished))completion;


@end


@protocol AudioPlayerOnlineEngineDelegate <NSObject>

/**
 播放器已经开始播放
 
 @param engine AudioPlayerOnlineEngine instance
 */
- (void)audioPlayerDidPlaying:(AncientPoetryPlayerOnlineEngine *)engine;

/**
 播放器播放完成后将回调该代理方法
 
 @param engine AudioPlayerOnlineEngine instance
 @param flag 如果为true，说明成功播放完成。若为false，说明播放被中断
 */
- (void)audioPlayerDidFinishPlaying:(AncientPoetryPlayerOnlineEngine *)engine successfully:(BOOL)flag;

/**
 播放器播放进度回调
 
 @param currentTime 当前播放时间
 @param duration 总时间
 */
- (void)audioPlayerProgress:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;

/**
 播放器播放错误将会回调该代理方法
 
 @param errorMessage 错误信息
 */
- (void)audioPlayerError:(NSString *)errorMessage;

@end

NS_ASSUME_NONNULL_END
