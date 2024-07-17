//
//  AncientPoetryNavigation.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "AncientPoetryNavigation.h"
#import "UIColor+AudioAncientPoetry.h"

#define __YS_iPhoneX [UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width >= 2.16

#define __YS_StatusBarHeight (__YS_iPhoneX ? 44.f : 20.f)

@implementation AncientPoetryNavigation


+ (instancetype)sharePEPNavigation{
    static AncientPoetryNavigation *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[self alloc] init];
        sharedInstance.backgroundColor = UIColor.whiteColor;
        sharedInstance.frame = CGRectMake(0, __YS_iPhoneX ? 44.f : 20.f, [UIScreen mainScreen].bounds.size.width, 44);
    });
    return sharedInstance;
}

- (void)initWithType:(PEPNavigationType)type andDelegate:(nonnull id)target{
    self.delegate = target;
    if (type == PEPNavigationTypeMain){
        [self initMainNavigationBar];
    }else if (type == PEPNavigationTypeMainNormal){
        [self initPEPNavigationNormal];
    }
}

//MARK: method

//创建首页的nav
- (void)initMainNavigationBar
{
    
    // 用户头像
    _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, __YS_StatusBarHeight+2, 40, 40)];
    _userIcon.backgroundColor = UIColor.placehoderColor;
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.cornerRadius = 20;
    _userIcon.userInteractionEnabled = YES;
    [self addSubview:_userIcon];
    // 用户名
    _userTitle = [[UILabel alloc] initWithFrame:CGRectMake(_userIcon.frame.origin.x+_userIcon.frame.size.width+10,__YS_StatusBarHeight+ 0, [UIScreen mainScreen].bounds.size.width-50-120, 44)];
    _userTitle.text = @"未登录";
    _userTitle.textColor = UIColor.whiteColor;
    _userTitle.tag = PEPNavigationButtonTypeUserName;
    _userTitle.textAlignment = NSTextAlignmentLeft;
    _userTitle.font = [UIFont systemFontOfSize:15];
    [self addSubview:_userTitle];
    
    // 消息
    UIImageView * messageimg = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100,[UIScreen mainScreen].bounds.size.height+7, 30, 30)];
    messageimg.image = [UIImage imageNamed:@"yst_message_icon"];
    messageimg.userInteractionEnabled = YES;
    messageimg.layer.masksToBounds = YES;
    messageimg.layer.cornerRadius = 10;
    messageimg.tag = PEPNavigationButtonTypeMessage;
    [self addSubview:messageimg];
    // 签到
    UIImageView * signUpimg = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, __YS_StatusBarHeight+7, 30, 30)];
    signUpimg.backgroundColor = UIColor.placehoderColor;
    signUpimg.image = [UIImage imageNamed:@"yst_signup_icon"];
    signUpimg.layer.masksToBounds = YES;
    signUpimg.layer.cornerRadius = 10;
    signUpimg.userInteractionEnabled = YES;
    signUpimg.tag = PEPNavigationButtonTypeSignIn;
    [self addSubview:signUpimg];
    
    UITapGestureRecognizer *userTitleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
    [_userIcon addGestureRecognizer:userTitleTap];
    
    UITapGestureRecognizer *messageimgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
    [messageimg addGestureRecognizer:messageimgTap];
    
    UITapGestureRecognizer *signUpimgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
    [signUpimg addGestureRecognizer:signUpimgTap];
}
//通用nav
- (void)initPEPNavigationNormal{
    //返回按钮
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, __YS_StatusBarHeight, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"yst_back_white"] forState:UIControlStateNormal];
    backButton.tag = PEPNavigationButtonTypeBack;
    [backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    _backButton = backButton;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, __YS_StatusBarHeight, [UIScreen mainScreen].bounds.size.width - 140, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:21];
    titleLabel.textColor = UIColor.whiteColor;
    [self addSubview:titleLabel];
    
    self.title = titleLabel;
}

- (UIButton*)rightButton
{
    if (_rightButton == nil) {
        UIButton *readButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, [UIScreen mainScreen].bounds.size.height, 80, 44)];
        [readButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        readButton.tag = PEPNavigationButtonTypeRight;
        readButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [readButton addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:readButton];
        _rightButton = readButton;
    }
    return _rightButton;
}

//MARK: Actions

#pragma mark - 导航栏左右按钮事件
-(void)clickBack {
    if (self.onClickLeftButton) {
        self.onClickLeftButton();
    } else {
        [self backToLastViewController];
    }
}
-(void)clickRight {
    if (self.onClickRightButton) {
        self.onClickRightButton();
    }
}

- (void)backButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(navigationBarClick:)]){
        [self.delegate navigationBarClick:button.tag];
    }
}

- (void)rightButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(navigationBarClick:)]){
        [self.delegate navigationBarClick:button.tag];
    }
}

- (void)tapActions:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(navigationBarClick:)]){
        [self.delegate navigationBarClick:tap.view.tag];
    }
}

- (void)backToLastViewController
{
    UIViewController *currentVC = [self findVisibleViewController];
    if (currentVC.navigationController) {
        if (currentVC.navigationController.viewControllers.count == 1) {
            if (currentVC.presentingViewController) {
                [currentVC dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [currentVC.navigationController popViewControllerAnimated:YES];
        }
    } else if(currentVC.presentingViewController) {
        [currentVC dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIViewController *)findVisibleViewController {
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController* currentViewController = window.rootViewController;

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

@end
