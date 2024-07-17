//
//  AncientPoetryPlayerOnlineEngine.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "AncientPoetryPlayerOnlineEngine.h"

@interface AncientPoetryPlayerOnlineEngine ()

@property (nonatomic, strong) AVPlayer *audioPlayer;

@property (nonatomic, weak) AVPlayerItem *playerItem;

@property (nonatomic, assign) CMTime currentTime;

@property (nonatomic, assign)NSTimeInterval duration;

@property (nonatomic, assign) NSTimeInterval endTime;

@property (nonatomic, assign) BOOL didCallbackBeginPlaying;

@end

@implementation AncientPoetryPlayerOnlineEngine

// MARK: - Lifecycle

- (void)dealloc {
    [self stop];
}

+ (instancetype)shareInstance {
    AncientPoetryPlayerOnlineEngine *instance = [AncientPoetryPlayerOnlineEngine.alloc init];
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        self.speed = 1.0;
    }
    return self;
}


// MARK: - Public Method

- (void)playAudioWithURLString:(NSString *)url {
    if (url.length == 0) {
        [self callbackAudioPlayerError:@"无效的播放地址"];
        return;
    }
    
    if (self.audioPlayer == nil) {
        self.audioPlayer = [self makePlayerWithURLString:url];
    } else {
        if (self.audioPlayer.rate > 0) {
            [self stop];
        }
        
        [self replaceCurrentItemWithURLString:url];
    }
    
    [self resume];
    [self addPeriodicTimeObserver:self.audioPlayer];
    
}

- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
    
    BOOL playing = self.audioPlayer.rate > 0;
    self.audioPlayer.rate = speed;
    
    if (playing == false) {
        [self pause];
    }
}

- (void)stop {
    [self.audioPlayer pause];
    
    [self callbackDidFinishPlayingWithSuccessfully:false];
}

- (void)pause {
    [self.audioPlayer pause];
    
    [self callbackDidFinishPlayingWithSuccessfully:false];
}

- (void)resume {
    [self.audioPlayer play];
    self.audioPlayer.rate = self.speed;
    
    if ([self.delegate respondsToSelector:@selector(audioPlayerDidPlaying:)]) {
        [self.delegate audioPlayerDidPlaying:self];
    }
}

- (void)replay {
    [self seekToTime:0];
    [self resume];
}

- (void)seekToTime:(int)time {
    [self seekToTime:time completionHandler:^(BOOL finished) {
        
    }];
}

- (void)seekToTime:(int)time completionHandler:(void (^)(BOOL finished))completion {
    CMTime seekTime = CMTimeMake(time, 1);
    CMTime tolerance = CMTimeMake(2, 1);
    [self.audioPlayer seekToTime:seekTime toleranceBefore:tolerance toleranceAfter:tolerance completionHandler:^(BOOL finished) {
        if (completion) { completion(finished); }
    }];
}

// MARK: - Private Method

- (void)replaceCurrentItemWithURLString:(NSString *)url {
    AVPlayerItem *item = [self makePlayerItemWithURLString:url];
    [self.audioPlayer replaceCurrentItemWithPlayerItem:item];
    
}

- (AVPlayer *)makePlayerWithURLString:(NSString *)url {
    AVPlayerItem *item = [self makePlayerItemWithURLString:url];
    AVPlayer *audioPlayer = [AVPlayer playerWithPlayerItem:item];

    
    return audioPlayer;
}

- (AVPlayerItem *)makePlayerItemWithURLString:(NSString *)url {

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];

    self.playerItem = item;
    return item;
}

- (NSTimeInterval)getDurationTime{
    return self.duration;;
}

- (void)addPeriodicTimeObserver:(AVPlayer *)player {
    __weak typeof(self) weakself = self;
    [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time) {

        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakself.playerItem.duration);
        
        weakself.duration = duration;
        
        if (isnan(currentTime)) { currentTime = 0; }
        if (isnan(duration)) { duration = 0; }
        
        if (duration < 1.0) {// 不足1秒的处理
            duration = 1.0;
        }

        if ([weakself.delegate respondsToSelector:@selector(audioPlayerProgress:duration:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.delegate audioPlayerProgress:currentTime duration:duration];
            });
        }
    }];
}

- (void)callbackDidFinishPlayingWithSuccessfully:(BOOL)successfully {
    if ([self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
        [self.delegate audioPlayerDidFinishPlaying:self successfully:successfully];
        self.didCallbackBeginPlaying = false;
    }
}

- (void)callbackAudioPlayerError:(NSString *)message {
    if ([self.delegate respondsToSelector:@selector(audioPlayerError:)]) {
        [self.delegate audioPlayerError:message];
        self.didCallbackBeginPlaying = false;
    }
}

@end
