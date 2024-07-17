//
//  PRWebVideoViewController.m
//  PEPRead
//
//  Created by 韩帅 on 2022/1/14.
//  Copyright © 2022 PEP. All rights reserved.
//

#import "PRWebVideoViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <SJBaseVideoPlayer/SJBaseVideoPlayer.h>
#import <Masonry/Masonry.h>

@interface PRWebVideoViewController ()
@property(nonatomic,strong)SJVideoPlayer *sjPlayer;/**<  */
@property (nonatomic, strong) UIImageView *playImageView;
@property(nonatomic,strong)UILabel *shareNumLabel;/**<  */
@property(nonatomic,strong)UILabel *likeNumLabel;/**<  */
@property(nonatomic,strong)UIButton *likeBtn;/**<  */
@property(nonatomic,strong)UIButton *shareBtn;/**<  */
//@property (nonatomic, strong) PRShareManager *shareManager;
@end

@implementation PRWebVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    [self configPlayer];
    
    
    
    if (self.is_poetry){
//        [self requestLikeData];
    }else{
        
    }
}

-(void)configPlayer{
    SJVideoPlayer.updateResources(^(id<SJVideoPlayerControlLayerResources>  _Nonnull resources) {
        resources.progressThumbSize = 8;
        resources.progressTrackColor = [UIColor colorWithWhite:1 alpha:0.5];
        resources.progressTraceColor = [UIColor colorWithWhite:1 alpha:1];
        resources.progressBufferColor = [UIColor colorWithWhite:1 alpha:0.1];
        resources.timeLabelFont = [UIFont systemFontOfSize:14];
        resources.progressThumbColor = UIColor.whiteColor;
        resources.timeLabelColor = [UIColor colorWithWhite:1 alpha:0.5];
        resources.backImage = [UIImage imageNamed:@"back_white"];
    });
    self.sjPlayer = [SJVideoPlayer lightweightPlayer];
    [self setupPlayer];
    [self.view addSubview:self.sjPlayer.view];
    [self.sjPlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-80);
        } else {
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        }
        
    }];
    if (@available(iOS 14.0, *)) {
        self.sjPlayer.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    }
// https://rjddresw.mypep.cn/xueln/%E5%92%8F%E9%B9%85_720P.mp4
    self.sjPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc]initWithURL:[NSURL URLWithString:self.model.videoUrl]];
    
    _playImageView = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"pr_icon_webPlayer"]];
    _playImageView.hidden = YES;
    [self.view addSubview:_playImageView];
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    UIView *desView = [[UIView alloc]init];
    desView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:desView];
    [desView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.sjPlayer.view.mas_bottom);
        make.height.mas_equalTo(80);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.title,self.model.label];
    titleLabel.textColor = UIColor.whiteColor;
    [desView addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    
    UIButton *supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [supportBtn setImage:[UIImage imageNamed:@"pr_icon_webPlayer_support"] forState:UIControlStateNormal];
    [supportBtn setImage:[UIImage imageNamed:@"pr_icon_webPlayer_supported"] forState:UIControlStateSelected];
    [desView addSubview:supportBtn];
    [supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(desView).offset(-6);
        make.right.equalTo(desView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
//    [supportBtn addTarget:self action:@selector(clickLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
    //从本地记录获取点赞情况
    BOOL status = [NSUserDefaults.standardUserDefaults boolForKey:[@"kExpandUserLikeBtnStatus" stringByAppendingString:self.model.code]];
    supportBtn.selected = status;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"pr_icon_webPlayer_share"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"pr_icon_webPlayer_share"] forState:UIControlStateSelected];
    [desView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(desView).offset(-6);
        make.right.equalTo(supportBtn.mas_left).offset(-25);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(desView);
        make.left.equalTo(desView).offset(15);
        make.right.equalTo(shareBtn.mas_left).offset(-35);
    }];
//    [shareBtn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    UILabel *shareNumLabel = [[UILabel alloc]init];
    shareNumLabel.font = [UIFont systemFontOfSize:13];
    shareNumLabel.text = [NSString stringWithFormat:@"%ld",self.model.forwardCount];
    shareNumLabel.textColor = UIColor.whiteColor;
    [desView addSubview:shareNumLabel];
    
    UILabel *likeNumLabel = [[UILabel alloc]init];
    likeNumLabel.font = [UIFont systemFontOfSize:13];
    likeNumLabel.text = [NSString stringWithFormat:@"%ld",self.model.likeCount];
    likeNumLabel.textColor = UIColor.whiteColor;
    [desView addSubview:likeNumLabel];
    [desView addSubview:shareNumLabel];
    [likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(supportBtn);
        make.top.equalTo(supportBtn.mas_bottom).offset(2);
    }];
    [shareNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareBtn);
        make.top.equalTo(shareBtn.mas_bottom).offset(2);
    }];
    self.shareNumLabel = shareNumLabel;
    self.likeNumLabel  = likeNumLabel;
    self.shareBtn = shareBtn;
    self.likeBtn = supportBtn;
}

-(void)configLikeBtnStatus:(UIButton*)btn{
    [self impactFeedback];
    NSInteger currentNum = [self.likeNumLabel.text integerValue];
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        //记录在本地
        self.likeNumLabel.text = [NSString stringWithFormat:@"%ld",currentNum +1];
        
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:[@"kExpandUserLikeBtnStatus" stringByAppendingString:self.model.code]];
        
    }else{
        //删除本地记录
        currentNum -= 1;
        if (currentNum < 0) {
            currentNum = 0;
        }
        self.likeNumLabel.text = [NSString stringWithFormat:@"%ld",currentNum];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:[@"kExpandUserLikeBtnStatus" stringByAppendingString:self.model.code]];
        
    }
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (void)setupPlayer {
    _sjPlayer.pausedToKeepAppearState = YES;

    __weak typeof(self) _self = self;
    

    // 设置仅支持单击手势
    _sjPlayer.gestureController.supportedGestureTypes = SJPlayerGestureTypeMask_SingleTap;
    // 重定义单击手势的处理
    _sjPlayer.gestureController.singleTapHandler = ^(id<SJGestureController>  _Nonnull control, CGPoint location) {
        // 此处改为单击暂停或播放
        __strong typeof(_self) self = _self;
        self.sjPlayer.isPaused ? [self.sjPlayer play] : [self.sjPlayer pauseForUser];
    };

    // 播放完毕后, 重新播放. 也就是循环播放
    _sjPlayer.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        [(SJBaseVideoPlayer*)player replay];
    };
    // 播放状态改变后刷新播放按钮显示状态
    _sjPlayer.playbackObserver.didReplayExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        
        [player controlLayerNeedDisappear];
    };
    _sjPlayer.playbackObserver.playbackStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        // 当前资源被播放过
        if ( player.isPlayed ) {
            // 只要被播放过的并且是用户暂停时, 才显示播放按钮
            BOOL isPaused = player.isUserPaused;
            self.playImageView.hidden = !isPaused;
        }
        // 未播放过的, 不显示播放按钮
        else {
            self.playImageView.hidden = YES;
        }
    };
    
    _sjPlayer.defaultEdgeControlLayer.draggingObserver.willBeginDraggingExeBlock = ^(NSTimeInterval time) {
        __strong typeof(_self) self = _self;
        self.playImageView.hidden = YES;
    };
    _sjPlayer.defaultEdgeControlLayer.fixesBackItem = YES;
    _sjPlayer.defaultEdgeControlLayer.hiddenBottomProgressIndicator = YES;
    [_sjPlayer.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Play];
    [_sjPlayer.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Full];
    [_sjPlayer.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Separator];
    [_sjPlayer.defaultEdgeControlLayer.bottomAdapter exchangeItemForTag:SJEdgeControlLayerBottomItem_DurationTime withItemForTag:SJEdgeControlLayerBottomItem_Progress];
    _sjPlayer.defaultEdgeControlLayer.bottomContainerView.backgroundColor = [UIColor clearColor];
    _sjPlayer.defaultEdgeControlLayer.topContainerView.backgroundColor = [UIColor clearColor];
    _sjPlayer.defaultEdgeControlLayer.topContainerView.backgroundColor = [UIColor clearColor];
    _sjPlayer.defaultEdgeControlLayer.bottomMargin = 15;
    _sjPlayer.controlLayerAppearObserver.onAppearChanged = ^(id<SJControlLayerAppearManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        mgr.interval = 1.5;
        if (mgr.isAppeared) {
            [self.sjPlayer.defaultEdgeControlLayer.bottomAdapter mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.right.offset(-15);
            }];
        }
    };

    [_sjPlayer.defaultEdgeControlLayer.bottomAdapter reload];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.sjPlayer vc_viewDidAppear];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView performWithoutAnimation:^{
        [self.navigationController setNavigationBarHidden:true animated:true];
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sjPlayer vc_viewWillDisappear];
    if (self.is_poetry){
        [self.navigationController setNavigationBarHidden:false animated:true];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.sjPlayer vc_viewDidDisappear];
    
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}
- (void)impactFeedback {
    if (@available(iOS 10.0, *)) {
        
        [[UIImpactFeedbackGenerator.alloc initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
        
    }
}

@end
