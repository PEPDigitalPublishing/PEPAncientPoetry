//
//  AudioPlayerControl.m
//  PEPRead
//
//  Created by 李沛倬 on 2019/11/26.
//  Copyright © 2019 PEP. All rights reserved.
//

#import "AncientPoetryPlayerControl.h"
#import "AncientPoetryCommonUtil.h"
#import "NSString+AudioAncientPoetry.h"
#import "MZTimerLabel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YSAudioAncientPoetryToast.h"
#import <Masonry/Masonry.h>
#import "UIColor+AudioAncientPoetry.h"
#import <ChameleonFramework/Chameleon.h>

@interface AncientPoetryPlayerControl ()<AudioPlayerOnlineEngineDelegate, MZTimerLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;





@property (weak, nonatomic) IBOutlet UILabel *progressTimeL;
@property (weak, nonatomic) IBOutlet UILabel *durationTimeL;


@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@property (nonatomic, assign) AudioPlayerControlPlayingMode playingMode;

/** 标志slider是否在滑动过程中 */
@property (nonatomic, assign) BOOL sliding;


@property (nonatomic, strong) id pauseCommandTarget;
@property (nonatomic, strong) id playCommandTarget;
@property (nonatomic, strong) id previousTrackCommandTarget;
@property (nonatomic, strong) id nextTrackCommandTarget;
@property (nonatomic, strong) id changePlaybackPositionCommandTarget;

@property (nonatomic, strong) UIAlertController *speedAlertController;

@property (nonatomic, strong) NSArray<NSString *> *speedItems;

@property (weak, nonatomic) IBOutlet MZTimerLabel *timeL;



@end
static NSString *kLocalMusicPlayModeKey = @"kLocalMusicPlayModeKey";
@implementation AncientPoetryPlayerControl

// MARK: - Lifecycle

- (void)dealloc {
    if (_playerEngine) {
        [self.playerEngine stop];
        self.playerEngine.delegate = nil;
    }

    [self removeRemoteCommand];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
   

}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

// MARK: - Public Method

- (void)playAudioWithURLString:(NSString *)url {
    
    [self.playerEngine playAudioWithURLString:url];
}

-(void)configOldStyle{
    self.prevButton.hidden = YES;
    self.nextButton.hidden = YES;
    self.playModeButton.hidden = YES;
    self.back10sBtn.hidden = YES;
    self.forward10sBtn.hidden = YES;
    self.settingButton.hidden = NO;
    self.playMenuView.hidden = YES;
}

// MARK: - Action

- (IBAction)progressSliderValueChanged:(UISlider *)sender {
    self.sliding = true;
//    self.playShowTimeView.hidden = NO;//时间显示框
    [self configProgressBarWithProgressValue:sender.value duration:sender.maximumValue];
    
}
- (IBAction)progressSliderTouchUpInside:(UISlider *)sender {
    
    __weak typeof(self) weakself = self;
    [self.playerEngine seekToTime:(int)sender.value completionHandler:^(BOOL finished) {
        weakself.sliding = false;
        [weakself configProgressBarWithProgressValue:sender.value duration:sender.maximumValue];
    }];

    
    
}

- (IBAction)playButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.playerEngine pause];
        if ([self.delegate respondsToSelector:@selector(audioPlayerPlayButtonStatus:)]) {
            [self.delegate audioPlayerPlayButtonStatus:1];
        }
    } else {
        [self.playerEngine resume];
        if ([self.delegate respondsToSelector:@selector(audioPlayerPlayButtonStatus:)]) {
            [self.delegate audioPlayerPlayButtonStatus:0];
        }
    }
}

- (IBAction)prevButtonAction:(UIButton *)sender {
    [self.playerEngine pause];
    if ([self.delegate respondsToSelector:@selector(audioPlayerControl:prevButtonAction:)]) {
        [self resetPlayingProgressAndPlayStatus];
        
        [self.delegate audioPlayerControl:self prevButtonAction:sender];
    }
    if ([self.delegate respondsToSelector:@selector(audioPlayerPlayButtonStatus:)]) {
//        [self.delegate audioPlayerPlayButtonStatus:0];
    }
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    [self.playerEngine pause];
    if ([self.delegate respondsToSelector:@selector(audioPlayerControl:nextButtonAction:)]) {
        [self resetPlayingProgressAndPlayStatus];
        NSLog(@"进度回调=暂停");
        [self.delegate audioPlayerControl:self nextButtonAction:sender];
    }
    if ([self.delegate respondsToSelector:@selector(audioPlayerPlayButtonStatus:)]) {
//        [self.delegate audioPlayerPlayButtonStatus:0];
    }
}
- (IBAction)rewindButtonAction:(UIButton *)sender {
    [self.delegate audioPlayerControl:self rewindButtonAction:sender];
}


- (IBAction)forwordButtonAction:(UIButton *)sender {
    [self.delegate audioPlayerControl:self forwardButtonAction:sender];
}


- (IBAction)speedControlAction:(UIControl *)sender {
    
    if ([AncientPoetryCommonUtil findVisibleViewController].presentedViewController == self.speedAlertController) {
        [self.speedAlertController dismissViewControllerAnimated:true completion:nil];
    } else {
        self.speedAlertController.popoverPresentationController.sourceView = self.playSpeedBtn;
        [[AncientPoetryCommonUtil findVisibleViewController] presentViewController:self.speedAlertController animated:true completion:^{
            
        }];
    }
}

- (UIAlertController *)speedAlertController {
    if (_speedAlertController) {
        return _speedAlertController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *speed in self.speedItems) {
        NSString *title = [NSString stringWithFormat:@"%@倍速", speed];
        __weak typeof(self) weakself = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.playSpeedText.text = [NSString stringWithFormat:@"x%@", speed];
            
            [weakself.delegate audioPlayerControl:weakself currentSpeed:[speed floatValue]];
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    
    _speedAlertController = alert;
    return alert;
}
- (NSArray<NSString *> *)speedItems {
    if (_speedItems == nil) {
        _speedItems = @[@"0.5", @"0.75", @"1.0", @"1.25", @"1.5", @"1.75", @"2.0"];
    }
    
    return _speedItems;
}

- (IBAction)clickAudioListBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(audioPlayerControl:playModeButtonAction:)]) {
        [self.delegate audioPlayerControl:self playModeButtonAction:sender];
    }
}


- (IBAction)playModeButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(audioPlayerControl:changePlayMode:)]) {
        [self.delegate audioPlayerControl:self changePlayMode:self.playingMode];
    }
    [NSUserDefaults.standardUserDefaults setInteger:self.playingMode forKey:kLocalMusicPlayModeKey];
    [NSUserDefaults.standardUserDefaults synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kLocalMusicPlayModeChange" object:@(self.playingMode)];
}
- (IBAction)clickCountDownBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(audioPlayerControl:popupMode:)]) {
        [self.delegate audioPlayerControl:self popupMode:AudioPlayerPopupCountDownOption];
    }
}
- (IBAction)repeatButtonActions:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(audioPlayerControl:repeatModel:)]){
        [self.delegate audioPlayerControl:self repeatModel:sender];
    }
}

- (IBAction)settingButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(audioPlayerControl:settingButtonAction:)]) {
        [self.delegate audioPlayerControl:self settingButtonAction:sender];
    }
}


// MARK: - AudioPlayerOnlineEngineDelegate

- (void)audioPlayerDidPlaying:(AncientPoetryPlayerOnlineEngine *)engine {
    self.playButton.selected = true;
    
    if ([self.delegate respondsToSelector:@selector(audioPlayerDidPlaying)]) {
        [self.delegate audioPlayerDidPlaying];
    }
}

/**
 播放器播放进度回调
 
 @param currentTime 当前播放时间
 @param duration 总时间
 */
- (void)audioPlayerProgress:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    if (!self.cleanSlider) {
        if (!self.sliding) {
            [self configProgressBarWithProgressValue:currentTime duration:duration];
            NSLog(@"进度回调%lf--%lf",currentTime,duration);
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(audioPlayerProgressTime:duration:)]) {
        [self.delegate audioPlayerProgressTime:currentTime duration:duration];
    }
}

/**
 播放器播放完成后将回调该代理方法
 
 @param engine AudioPlayerOnlineEngine instance
 @param flag 如果为true，说明成功播放完成。若为false，说明播放被中断
 */
- (void)audioPlayerDidFinishPlaying:(AncientPoetryPlayerOnlineEngine *)engine successfully:(BOOL)flag {
    self.playButton.selected = false;
    if ([self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlayingSuccessfully:)]) {
        [self.delegate audioPlayerDidFinishPlayingSuccessfully:flag];
    }
    if (flag == true) {
        
        if ([self.timeL counting]) {
            if (self.playingMode == AudioPlayerControlPlayingModeSingleOnce) {
                [self.playerEngine pause];
                [self.playerEngine seekToTime:0];
                [self configCountDown:0];
                self.audioTimes = 0;
                return;
            }else{
                self.audioTimes = self.audioTimes - 1;
                NSLog(@"播放完一集,还剩%ld",self.audioTimes);
                if (self.audioTimes >0 && self.audioTimes <= 10) {
                    //暂停
                    [self.playerEngine pause];
                    [self.playerEngine seekToTime:0];
                    [self configCountDown:0];
                    self.audioTimes = 0;
                    return;
                }
                [YSAudioAncientPoetryToast showToastByMessage:[NSString stringWithFormat:@"%ld集后关闭播放",self.audioTimes - 10] inView:[AncientPoetryCommonUtil findVisibleViewController].view andType:YSAudioAncientPoetryTypeNormal];
            }
            
            
        }
        
        
        [self configProgressBarWithProgressValue:0 duration:0];
        switch (self.playingMode) {
            case AudioPlayerControlPlayingModeSingleOnce: {
                [self.playerEngine seekToTime:0];
                break;
            }
            case AudioPlayerControlPlayingModeSingleCycle: {
                
                [self.playerEngine replay];
                break;
            }
            case AudioPlayerControlPlayingModeListCycle: {
                [self nextButtonAction:self.nextButton];
                break;
            }
        }
    }else{
//        self.playButton.selected = false;
    }
   
}

/**
 播放器播放错误将会回调该代理方法
 
 @param errorMessage 错误信息
 */
- (void)audioPlayerError:(NSString *)errorMessage {
    self.playButton.selected = false;
    
    if ([self.delegate respondsToSelector:@selector(audioPlayerPlayError:)]) {
        [self.delegate audioPlayerPlayError:errorMessage];
    }
}


// MARK: - Remote

- (void)setupRemoteCommandCenter {
    MPRemoteCommandCenter *commandCenter = MPRemoteCommandCenter.sharedCommandCenter;
    
    commandCenter.previousTrackCommand.enabled = true;
    commandCenter.nextTrackCommand.enabled = true;
    commandCenter.playCommand.enabled = true;
    commandCenter.pauseCommand.enabled = true;
        
    __weak typeof(self) weakself = self;
    self.pauseCommandTarget = [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        [weakself.playerEngine pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    self.playCommandTarget = [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        [weakself.playerEngine resume];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    

    self.previousTrackCommandTarget = [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        // 上一首
        
        [weakself prevButtonAction:weakself.prevButton];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    self.nextTrackCommandTarget = [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        // 下一首
        
        [weakself nextButtonAction:weakself.nextButton];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
    //在控制台拖动进度条调节进度
    if (@available(iOS 9.1, *)) {
        commandCenter.changePlaybackPositionCommand.enabled = true;

        self.changePlaybackPositionCommandTarget = [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            
            [weakself.playerEngine pause];
                        
//            CMTime totlaTime = weakself.playerEngine.audioPlayer.currentItem.duration;
            MPChangePlaybackPositionCommandEvent *playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
            
//            int seek = totlaTime.value*playbackPositionEvent.positionTime/CMTimeGetSeconds(totlaTime);
            
            [weakself.playerEngine seekToTime:playbackPositionEvent.positionTime completionHandler:^(BOOL finished) {
                if (finished) {
                    [weakself.playerEngine resume];
                }
            }];
            
            return MPRemoteCommandHandlerStatusSuccess;
        }];
    }
    
}

- (void)removeRemoteCommand {
    MPRemoteCommandCenter *commandCenter = MPRemoteCommandCenter.sharedCommandCenter;
    
    commandCenter.previousTrackCommand.enabled = false;
    commandCenter.nextTrackCommand.enabled = false;
    commandCenter.playCommand.enabled = false;
    commandCenter.pauseCommand.enabled = false;
    
    [commandCenter.playCommand removeTarget:self.playCommandTarget];
    [commandCenter.pauseCommand removeTarget:self.pauseCommandTarget];
    [commandCenter.previousTrackCommand removeTarget:self.previousTrackCommandTarget];
    [commandCenter.nextTrackCommand removeTarget:self.nextTrackCommandTarget];
    
    if (@available(iOS 9.1, *)) {
        commandCenter.changePlaybackPositionCommand.enabled = false;
        [commandCenter.changePlaybackPositionCommand removeTarget:self.changePlaybackPositionCommandTarget];
    }
}





// MARK: - UI

- (void)setupSubviews {
    self.settingButton.hidden = YES;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"speed"] forState:UIControlStateNormal];
    //本地保存用户播放方式
    
    AudioPlayerControlPlayingMode localMode =  [NSUserDefaults.standardUserDefaults integerForKey:kLocalMusicPlayModeKey];
    self.playingMode = localMode;
    switch (self.playingMode) {
        case AudioPlayerControlPlayingModeSingleOnce: {
            
            self.playModeImg.image = [UIImage imageNamed:@"PlayModeOnce"];
            break;
        }
        case AudioPlayerControlPlayingModeSingleCycle: {
            
            self.playModeImg.image = [UIImage imageNamed:@"PlayModeSingleCircle"];

            break;
        }
        case AudioPlayerControlPlayingModeListCycle: {
            
            self.playModeImg.image = [UIImage imageNamed:@"PlayModeAllCircle"];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kLocalMusicPlayModeChange" object:@(self.playingMode)];
    [self setupRemoteCommandCenter];
    self.playButton.adjustsImageWhenHighlighted = NO;
    self.nextButton.adjustsImageWhenHighlighted = NO;
    self.prevButton.adjustsImageWhenHighlighted = NO;
    self.playModeButton.adjustsImageWhenHighlighted = NO;
    self.settingButton.adjustsImageWhenHighlighted = NO;
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F0F0EC"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    self.playSpeedTextBg.layer.borderColor = UIColor.themeColor.CGColor;
    self.playSpeedTextBg.layer.borderWidth = 1.5;
    self.playSpeedTextBg.layer.cornerRadius = 5;
    self.timeL.timeFormat = @"mm:ss";
    self.timeL.delegate = self;
    self.timeL.timerType = MZTimerLabelTypeTimer;
}

- (void)configProgressBarWithProgressValue:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    if (duration < 1 || currentTime < 0 || duration < currentTime) { return; }
    if (self.sliding == false) {
        self.progressSlider.maximumValue = duration;
        [self.progressSlider setValue:currentTime animated:true];
        self.playShowTimeView.hidden = YES;
    }
    self.progressTimeL.text = [NSString PEP_formatTimeProgressString:currentTime];
    self.durationTimeL.text = [NSString PEP_formatTimeProgressString:duration];
    self.progressLabel.text = [NSString PEP_formatTimeProgressString:currentTime];
    self.durationLabel.text = [NSString PEP_formatTimeProgressString:duration];
}

- (void)resetPlayingProgressAndPlayStatus {
    self.progressLabel.text = [NSString PEP_formatTimeProgressString:0];
    self.durationLabel.text = [NSString PEP_formatTimeProgressString:0];
    self.progressSlider.value = 0;
    self.playButton.selected = false;
}

- (AncientPoetryPlayerOnlineEngine *)playerEngine {
    if (_playerEngine == nil) {
        _playerEngine = AncientPoetryPlayerOnlineEngine.shareInstance;
        _playerEngine.speed = 1.0;
        _playerEngine.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
    return _playerEngine;
}
- (void)playbackFinished:(NSNotification*)noti{
    NSLog(@"当前视频播放完成.");
    AVPlayerItem *notiItem = noti.object;
    AVURLAsset *notiAsset = (AVURLAsset*)notiItem.asset;
    NSString *notiUrl = notiAsset.URL.path;
    
    AVPlayer *currentAudioPlayer = self.playerEngine.audioPlayer;
    AVPlayerItem *currentItem = currentAudioPlayer.currentItem;
    if (currentItem != nil) {
        AVAsset *currentAsset = currentItem.asset;
        if ([currentAsset isKindOfClass:[AVURLAsset class]]) {
            AVURLAsset *currentUrlAsset = (AVURLAsset *)currentAsset;
            NSString *currentUrl = currentUrlAsset.URL.path;
            if (currentUrl.length <= 0 || ![currentUrl isEqualToString:notiUrl]) {
                
                return;
            }
            
        }
    }
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [self audioPlayerDidFinishPlaying:self.playerEngine successfully:YES];
    
}

-(void)configCountDown:(NSInteger)time{
    if (time > 0) {
        self.countDownTimeL.hidden = YES;
        self.countDownTimeImg.image = [UIImage imageNamed:@"pep_apIcon_countDowning"];
        self.timeL.hidden = NO;
        if ([self.timeL counting]) {
            [self.timeL pause];
            [self.timeL reset];
        }
       
        [self.timeL setCountDownTime:time];
        [self.timeL start];
    }else{
        self.countDownTimeImg.image = [UIImage imageNamed:@"pep_apIcon_countDown"];
        self.countDownTimeL.hidden = NO;
        self.timeL.hidden = YES;
        if ([self.timeL counting]) {
            [self.timeL pause];
            [self.timeL reset];
        }
    }
}
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    NSLog(@"暂停");
    if (self.playButton.selected) {
        [self.playerEngine pause];
        if ([self.delegate respondsToSelector:@selector(audioPlayerPlayButtonStatus:)]) {
            [self.delegate audioPlayerPlayButtonStatus:1];
        }
    }
    self.audioTimes = 0;
    if ([self.delegate respondsToSelector:@selector(audioPlayerControlWithCountDownFinished:)]) {
        [self.delegate audioPlayerControlWithCountDownFinished:self];
    }
    [self configCountDown:0];
}

- (void)setUiModel:(AudioPlayerUIMode)uiModel{
    _uiModel = uiModel;
    if (uiModel == AudioPlayerUIModeGreen){
        //加载其他样式的UI
        [self.back10sBtn setImage:[UIImage imageNamed:@"-10s_w"] forState:UIControlStateNormal];
        [self.forward10sBtn setImage:[UIImage imageNamed:@"+10s_w"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"playN_w"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"pauseN_w"] forState:UIControlStateSelected];
        //倍速
        [self.playModeImg setImage:[UIImage imageNamed:@"PlayMode_1_w"]];
        self.playModeText.textColor = [UIColor colorWithHexString:@"#666666"];
        //复读
        [self.repeatImg setImage:[UIImage imageNamed:@"play_mode_repeat_w"]];
        self.repeatLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//        //循环
        [self.loopImg setImage:[UIImage imageNamed:@"PlayModeSingleCircle_w"]];
        self.loopLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//        //列表
        self.countDownTimeImg.image = [UIImage imageNamed:@"pep_apIcon_countDown_w"];
        self.countDownTimeL.textColor = [UIColor colorWithHexString:@"#666666"];
        self.progressLabel.textColor = UIColor.textThemeColorBlack;
        self.durationLabel.textColor = UIColor.textThemeColorBlack;
        
        self.progressSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#F8AB1E"];
        self.progressSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#E0E0E0"];
        [self.progressSlider setThumbImage:[UIImage imageNamed:@"yst-english-s-进度"] forState:UIControlStateNormal];
    }
    else if (uiModel == AudioPlayerUIModeEnglish) {
        self.progressSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#F8AB1E"];
        self.progressSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#E0E0E0"];
        [self.progressSlider setThumbImage:[UIImage imageNamed:@"yst-english-s-进度"] forState:UIControlStateNormal];
        [self.playModeImg setImage:[UIImage imageNamed:@"yst-english-s-倍速"]];
    }
}

@end
