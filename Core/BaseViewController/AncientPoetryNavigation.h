//
//  AncientPoetryNavigation.h
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PEPNavigationType){
    PEPNavigationTypeMain = 1,
    PEPNavigationTypeMainNormal,
};

typedef NS_ENUM(NSInteger,PEPNavigationButtonType){
    PEPNavigationButtonTypeMessage = 1,
    PEPNavigationButtonTypeSignIn,
    PEPNavigationButtonTypeUserName,
    PEPNavigationButtonTypeBack,
    PEPNavigationButtonTypeRight,
};

@protocol PEPNavigationDelegate <NSObject>

- (void)navigationBarClick:(PEPNavigationButtonType)type;

@end

@interface AncientPoetryNavigation : UIView

/** 用户头像*/
@property (nonatomic , strong)UIImageView * userIcon;
/** 用户名*/
@property (nonatomic , strong)UILabel * userTitle;
/** 消息*/
@property (nonatomic , strong)UIButton * messageButton;
/** 签到*/
@property (nonatomic , strong)UIButton * signUpButton;
/** 标题*/
@property (nonatomic , strong)UILabel * title;
/** 左侧单按钮*/
@property (nonatomic , strong)UIButton * backButton;
/** 右侧单按钮*/
@property (nonatomic , strong)UIButton * rightButton;
/** 导航条类型*/
@property (nonatomic , assign)PEPNavigationType navType;
/** 代理返回按钮点击*/
@property (nonatomic , weak)id <PEPNavigationDelegate>delegate;

/** Block返回按钮点击*/
@property (nonatomic, copy) void(^onClickLeftButton)(void);
@property (nonatomic, copy) void(^onClickRightButton)(void);

+ (instancetype)sharePEPNavigation;

- (void)initWithType:(PEPNavigationType)type andDelegate:(id)target;


@end

NS_ASSUME_NONNULL_END
