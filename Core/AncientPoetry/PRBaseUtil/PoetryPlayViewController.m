//
//  PoetryPlayViewController.m
//  PEPRead
//
//  Created by liudongsheng on 2018/7/4.
//  Copyright © 2018年 PEP. All rights reserved.
//

#import "PoetryPlayViewController.h"
#import "PoetryModel.h"
#import "PRUserDefaultManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VoiceCourseModel.h"

typedef NS_ENUM(NSUInteger, PlayMode) {
    PlayModeOnce,                   // 单曲播放一次
    PlayModeSingleCircle,           // 单曲循环
    PlayModeAllCircle,              // 全部循环
};

typedef NS_ENUM(NSUInteger, PlayVideoType){
    PlayVideoTypeCCTV,
    PlayVideoTypePoetry,
    PlayVideoTypeMusic
};


@interface PoetryPlayViewController ()<UIScrollViewDelegate,AudioPlayerControlPlayingDelegate>

@property (nonatomic, strong) NSArray <PoetryModel *> *dataArray;
@property (nonatomic,strong) NSArray <MusicTestChildrenItem *> *musicItemArray;
@property (nonatomic,strong) UIView * musicBackgroundView;// 音乐背景视图
@property (nonatomic,strong)UIImageView * themeImage;//主图

@property(nonatomic,assign)NSInteger currentIndex;//当前播放在数组的位置

@property(nonatomic,assign)NSInteger imgIndex;//当前播放对应图片在数组位置


@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;



@property (nonatomic, weak) UIBarButtonItem *shareBarItem;




@property (nonatomic, strong) UIImage *poetryPlaceholderImage;

//使用统一播放控制器
@property (nonatomic, strong) AncientPoetryPlayerControl *playerCtrl;
@property (nonatomic, assign) int currentTime;
@property (nonatomic, assign) int duration;

//@property (nonatomic, assign) BOOL isFirstLoading;//音频首次加载标志位
//@property (nonatomic, assign) BOOL isPauseFlag;//音频暂停标志位
@property(nonatomic,assign)NSInteger countDownIndex;/**<  选中的倒计时标志位*/

//@property(nonatomic,strong)MZTimerLabel *countDownL;/**<  */
//@property(nonatomic,assign)BOOL isFirstSeekFlag;/**<  首次跳转进度flag*/

@property(nonatomic,strong)VoiceCourseModel *compatibleModel;/**<  */

@end


@implementation PoetryPlayViewController
- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self requestData];
    [self initRemoteCommandCenter];

    [self createShareBarButtonItem];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self playOrPause];

}

// MARK: - Data


-(void)changeDataModel{
    self.compatibleModel = [VoiceCourseModel new];
    NSMutableArray *arrM = [NSMutableArray array];
    for (PoetryModel *pretry in self.dataArray) {
        AudioModel *model = [[AudioModel alloc]init];
        model.title = pretry.title;
        model.url = pretry.path;
        model.duration = pretry.duration;
        model.audioId = pretry.chapter_id;
        [arrM addObject:model];
    }
    if (arrM.count > 0) {
        self.compatibleModel.audios = [arrM copy];
        //计算进度
//        [self countProgress];
    }
    
}
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    PoetryModel *model = self.dataArray[self.currentIndex];
    
    if (self.compatibleModel) {
        self.compatibleModel.currentAudioIndex = currentIndex;
    }
}

// MARK: - UI

-(void)configPlayerAndThemeImage
{
    PoetryModel *model = self.dataArray[self.currentIndex];
    if(_dataArray[self.currentIndex].img.count>0){
        [_themeImage sd_setImageWithURL:[NSURL URLWithString:_dataArray[self.currentIndex].img[0].url] placeholderImage:self.poetryPlaceholderImage];
    }
    self.title = _dataArray[self.currentIndex].title;
    self.imgIndex = 0;
    [self.playerCtrl playAudioWithURLString:model.path];
    
    
//    [PRUserDefaultManager uploadResourcePlayInfo:model.book_id resID:model.chapter_id resType:@"mp3" resName:model.title];
}

// MARK: - AudioPlayerControlPlayingDelegate

- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl prevButtonAction:(UIButton *)sender {
    
    NSUInteger index = [self findTruePreAudioItem];
    
    PoetryModel *model = self.dataArray[self.currentIndex];
    self.currentIndex = index;
    [self configPlayerAndThemeImage];
    [self changeCountTime];
}
- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl nextButtonAction:(UIButton *)sender {
    NSUInteger index = [self findTrueNextAudioItem:self.currentIndex];
    
    PoetryModel *model = self.dataArray[self.currentIndex];
    self.currentIndex = index;
    [self configPlayerAndThemeImage];
    [self changeCountTime];
}
- (void)audioPlayerDidFinishPlayingSuccessfully:(BOOL)flag {

    if (flag) {
        PoetryModel *model = self.dataArray[self.currentIndex];
        [[PRUserDefaultManager shareInstance]setAudioPlayTime:model.chapter_id time:0];
        [[PRUserDefaultManager shareInstance]setAudioPlayProportion:model.chapter_id time:[model.duration integerValue]];
    }
}
- (void)audioPlayerProgressTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    NSLog(@"播放进度时间%lfs",currentTime);
    self.currentTime = currentTime;
    self.duration = duration;
    PoetryModel *model = self.dataArray[self.currentIndex];
    if (model.img.count > 1) {
        for (int i = (int)(model.img.count - 1); i >= 0 ; i --) {
            ImgModel *imgModel = model.img[i];
            if (imgModel.time <= currentTime) {
                self.imgIndex = i;
                [_themeImage sd_setImageWithURL:[NSURL URLWithString:model.img[i].url] placeholderImage:self.poetryPlaceholderImage];
                break;
            }
        }
    }
    
    [self showLockScreenTotaltime:duration andCurrentTime:currentTime];
    [[PRUserDefaultManager shareInstance]setAudioPlayTime:model.chapter_id time:self.currentTime];
}
- (void)audioPlayerPlayError:(NSString *)errorMessage {
    
}
-(void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl rewindButtonAction:(UIButton *)sender{
    int seek = MAX(self.currentTime-10, 0);
    [self.playerCtrl.playerEngine seekToTime:seek];
}
-(void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl forwardButtonAction:(UIButton *)sender{
    int seek = MIN(self.currentTime+10, self.duration);
    [self.playerCtrl.playerEngine seekToTime:seek];
}
-(void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl currentSpeed:(CGFloat)speed{
    self.playerCtrl.playerEngine.speed = speed;
}

-(void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl popupMode:(AudioPlayerPopupMode)mode{
    
}
- (void)audioPlayerControlWithCountDownFinished:(AncientPoetryPlayerControl *)audioPlayerControl{
    self.countDownIndex = 0;
}
- (void)audioPlayerControl:(AncientPoetryPlayerControl *)audioPlayerControl changePlayMode:(AudioPlayerControlPlayingMode)playMode{
    
}

-(void)changeCountTime{
    if (self.countDownIndex == 1 || self.countDownIndex == 2 || self.countDownIndex == 3) {
        NSInteger time = [self calculationTimeWithAudioIndex:self.currentIndex :self.playerCtrl.audioTimes - 10 :self.playerCtrl.playingMode];
        NSInteger countDown = time ;
        [self.playerCtrl configCountDown:countDown];
        
    }
}
+(NSInteger)findTruePreAudioItem:(NSInteger)currentIndex dataArr:(NSArray<PoetryModel*>*)dataArray{
    NSInteger index = 0;
    if (currentIndex == 0) {
        index = dataArray.count - 1;
    }else{
        index = currentIndex - 1;
    }
    while (index >= 0) {
        PoetryModel *temp = dataArray[index];
        if (!temp.is_fakeHeader) {
            NSLog(@"kkk真的下一首");
            break;
        }
        index -= 1;
        NSLog(@"kkk跳过了一个假头");
    }
    if (index < 0) {
        //容错处理
        index = dataArray.count - 1;
        while (index >= 0) {
            PoetryModel *temp = dataArray[index];
            if (!temp.is_fakeHeader) {
                NSLog(@"kkk真的下一首");
                break;
            }
            index -= 1;
            NSLog(@"kkk跳过了一个假头");
        }
    }
    return index;
}
-(NSInteger)findTruePreAudioItem{
    NSInteger index = 0;
    if (self.currentIndex == 0) {
        index = self.dataArray.count - 1;
    }else{
        index = self.currentIndex - 1;
    }
    while (index >= 0) {
        PoetryModel *temp = self.dataArray[index];
        if (!temp.is_fakeHeader) {
            NSLog(@"kkk真的下一首");
            break;
        }
        index -= 1;
        NSLog(@"kkk跳过了一个假头");
    }
    if (index < 0) {
        //容错处理
        index = self.dataArray.count - 1;
        while (index >= 0) {
            PoetryModel *temp = self.dataArray[index];
            if (!temp.is_fakeHeader) {
                NSLog(@"kkk真的下一首");
                break;
            }
            index -= 1;
            NSLog(@"kkk跳过了一个假头");
        }
    }
    return index;
}
+(NSInteger)findTrueNextAudioItem:(int)currentIndex dataArr:(NSArray<PoetryModel*>*)dataArray{
    NSInteger index = 0;
    if (currentIndex == dataArray.count -1) {
        //切换到第一首
        index = 0;
    }else{
        index = currentIndex + 1;
    }
    while (index <= dataArray.count -1) {
        PoetryModel *temp = dataArray[index];
        if (!temp.is_fakeHeader) {
            NSLog(@"kkk真的下一首");
            break;
        }
        index += 1;
        NSLog(@"kkk跳过了一个假头");
    }
    if (index > dataArray.count -1) {
        //容错处理
        index = 0;
        while (index <= dataArray.count -1) {
            PoetryModel *temp = dataArray[index];
            if (!temp.is_fakeHeader) {
                NSLog(@"kkk真的下一首");
                break;
            }
            index += 1;
            NSLog(@"kkk跳过了一个假头");
        }
    }
    
    return index;
}
/// 考虑红歌类型数据类型特殊,用此方法寻找下一个音频
/// @param index 当前音频index,
-(NSInteger)findTrueNextAudioItem:(NSInteger)currentIndex{
    NSInteger index = 0;
    if (currentIndex == self.dataArray.count -1) {
        //切换到第一首
        index = 0;
    }else{
        index = currentIndex + 1;
    }
    while (index <= self.dataArray.count -1) {
        PoetryModel *temp = self.dataArray[index];
        if (!temp.is_fakeHeader) {
            NSLog(@"kkk真的下一首");
            break;
        }
        index += 1;
        NSLog(@"kkk跳过了一个假头");
    }
    if (index > self.dataArray.count -1) {
        //容错处理
        index = 0;
        while (index <= self.dataArray.count -1) {
            PoetryModel *temp = self.dataArray[index];
            if (!temp.is_fakeHeader) {
                NSLog(@"kkk真的下一首");
                break;
            }
            index += 1;
            NSLog(@"kkk跳过了一个假头");
        }
    }
    
    return index;
}
+(NSInteger)calculationTimeWithAudioIndex:(int)audioIndex :(NSInteger)countDownOptionIndex :(AudioPlayerControlPlayingMode) playingMode dataArr:(NSArray<PoetryModel*>*)dataArray{
    NSInteger countDownTime = 0;
    //计算时间
    if (countDownOptionIndex == 0) {
        countDownTime = 0;
    }else if (playingMode == AudioPlayerControlPlayingModeSingleOnce){
        //单曲播放模式
        PoetryModel *audio = dataArray[audioIndex];
        countDownTime = ceilf([audio.duration floatValue]);
    }
    else if (countDownOptionIndex == 1){//播放一集
        PoetryModel *audioM = dataArray[audioIndex];
        NSString *currentAudioLength = audioM.duration;
        countDownTime = ceilf([currentAudioLength floatValue]);
    }
    else if (countDownOptionIndex == 2){
        //2集
        PoetryModel *audio1 = dataArray[audioIndex];
        if (playingMode == AudioPlayerControlPlayingModeSingleCycle) {
            
            countDownTime = ceilf([audio1.duration floatValue]) * 2;
        }
        else{
            
            PoetryModel *audio2 = dataArray[[self findTrueNextAudioItem:audioIndex dataArr:dataArray]];
            
            countDownTime = ceilf([audio1.duration floatValue]) + ceilf([audio2.duration floatValue]);
        }
        
    }
    else if (countDownOptionIndex == 3){
        //3集
        PoetryModel *audio1 = dataArray[audioIndex];
        if (playingMode == AudioPlayerControlPlayingModeSingleCycle) {
            
            countDownTime = ceilf([audio1.duration floatValue]) * 3;
        }else{
            NSInteger audio2Index = [self findTrueNextAudioItem:audioIndex dataArr:dataArray];
            NSInteger audio3Index = [self findTrueNextAudioItem:audio2Index dataArr:dataArray];
            PoetryModel *audio2 = dataArray[audio2Index];
            PoetryModel *audio3 = dataArray[audio3Index];;

            countDownTime = ceilf([audio1.duration floatValue]) + ceilf([audio2.duration floatValue]) + ceilf([audio3.duration floatValue]);
        }
        
        
    }else{}
    
    return countDownTime;
}
-(NSInteger)calculationTimeWithAudioIndex:(NSInteger)audioIndex :(NSInteger)countDownOptionIndex :(AudioPlayerControlPlayingMode) playingMode{
    NSInteger countDownTime = 0;
    //计算时间
    if (countDownOptionIndex == 0) {
        countDownTime = 0;
    }else if (playingMode == AudioPlayerControlPlayingModeSingleOnce){
        //单曲播放模式
        PoetryModel *audio = self.dataArray[audioIndex];
        countDownTime = ceilf([audio.duration floatValue]);
    }
    else if (countDownOptionIndex == 1){//播放一集
        PoetryModel *audioM = self.dataArray[audioIndex];
        NSString *currentAudioLength = audioM.duration;
        countDownTime = ceilf([currentAudioLength floatValue]);
    }
    else if (countDownOptionIndex == 2){
        //2集
        PoetryModel *audio1 = self.dataArray[audioIndex];
        if (playingMode == AudioPlayerControlPlayingModeSingleCycle) {
            
            countDownTime = ceilf([audio1.duration floatValue]) * 2;
        }
        else{
            
            PoetryModel *audio2 = self.dataArray[[self findTrueNextAudioItem:self.currentIndex]];
            
            countDownTime = ceilf([audio1.duration floatValue]) + ceilf([audio2.duration floatValue]);
        }
        
    }
    else if (countDownOptionIndex == 3){
        //3集
        PoetryModel *audio1 = self.dataArray[audioIndex];
        if (playingMode == AudioPlayerControlPlayingModeSingleCycle) {
            
            countDownTime = ceilf([audio1.duration floatValue]) * 3;
        }else{
            NSInteger audio2Index = [self findTrueNextAudioItem:self.currentIndex];
            NSInteger audio3Index = [self findTrueNextAudioItem:audio2Index];
            PoetryModel *audio2 = self.dataArray[audio2Index];
            PoetryModel *audio3 = self.dataArray[audio3Index];;

            countDownTime = ceilf([audio1.duration floatValue]) + ceilf([audio2.duration floatValue]) + ceilf([audio3.duration floatValue]);
        }
        
        
    }else{}
    
    return countDownTime;
}
- (UIImage *)poetryPlaceholderImage {
    if (!_poetryPlaceholderImage) {
        _poetryPlaceholderImage = [UIImage imageNamed:@"placeholder"];
    }
    return _poetryPlaceholderImage;
}


//左右滑动切换音频
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self audioPlayerControl:self.playerCtrl nextButtonAction:[UIButton new]];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self audioPlayerControl:self.playerCtrl prevButtonAction:[UIButton new]];
    }
}




//开始暂停
- (void)playOrPause{
    
    if (self.playerCtrl.playButton.isSelected) {
        [self.playerCtrl.playerEngine pause];
        
    } else {
        [self.playerCtrl.playerEngine resume];
    }
}

//上一曲
-(void)beforeBtnClick{
    [self audioPlayerControl:self.playerCtrl prevButtonAction:[UIButton new]];
}

//下一曲
- (void)nextBtnClick
{
    [self audioPlayerControl:self.playerCtrl nextButtonAction:[UIButton new]];
}

- (void)initRemoteCommandCenter {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
//    commandCenter.togglePlayPauseCommand 耳机线控的暂停/播放
    
    __weak typeof(self) weakself = self;
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        [weakself playOrPause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        [weakself playOrPause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        // 上一首
        [weakself beforeBtnClick];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        // 下一首
        
        [weakself nextBtnClick];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
    //在控制台拖动进度条调节进度
    if (@available(iOS 9.1, *)) {
        [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            if (weakself.playerCtrl.playerEngine.isPausing) { [weakself playOrPause]; }
            
            MPChangePlaybackPositionCommandEvent *playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
            NSLog(@"positionTime--%lf",playbackPositionEvent.positionTime);
            
            [weakself.playerCtrl.playerEngine seekToTime:playbackPositionEvent.positionTime];

            return MPRemoteCommandHandlerStatusSuccess;
        }];
    }

}

//展示锁屏歌曲信息：图片、歌词、进度、歌曲名、演唱者、专辑、（歌词是绘制在图片上的）
- (void)showLockScreenTotaltime:(float)totalTime andCurrentTime:(float)currentTime {
    
    NSMutableDictionary *songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:self.title forKey:MPMediaItemPropertyTitle];
    //设置歌手名
//    [songDict setObject:@"" forKey:MPMediaItemPropertyArtist];
    
    NSString *album = @"中小学语文诗词朗读";
    
    //设置专辑名
    [songDict setObject:album forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    

    //设置显示的海报图片
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:self.themeImage.image]
                 forKey:MPMediaItemPropertyArtwork];
    //加入正在播放媒体的信息中心
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

         return self.themeImage;
    
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect frame = self.themeImage.frame;
    
    frame.origin.y = (self.scrollView.frame.size.height - self.themeImage.frame.size.height) > 0 ? (self.scrollView.frame.size.height - self.themeImage.frame.size.height) * 1 : 0;
    frame.origin.x = (self.scrollView.frame.size.width - self.themeImage.frame.size.width) > 0 ? (self.scrollView.frame.size.width - self.themeImage.frame.size.width) * 1 : 0;
    self.themeImage.frame = frame;
    
    self.scrollView.contentSize = CGSizeMake(self.themeImage.frame.size.width, self.themeImage.frame.size.height);

}


// MARK: - Share

- (void)createShareBarButtonItem {
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pr_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    self.shareBarItem = shareItem;
}

- (void)shareBarButtonItemAction:(UIBarButtonItem *)sender {
    
}







@end
