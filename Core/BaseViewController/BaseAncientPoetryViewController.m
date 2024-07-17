//
//  BaseAncientPoetryViewController.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "BaseAncientPoetryViewController.h"
#import "BaseAncientPoetryNavigation.h"
#import "AncientPoetryButton.h"
#import "UIColor+AudioAncientPoetry.h"

#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDAutoLayout/SDAutoLayout.h>

#define kProgressHUDOpacity    0.7f
#define kProgressHUDViewMargin 15.0f

@interface BaseAncientPoetryViewController ()<PCNavigationControllerPopDelegate,PEPNavigationDelegate>
{
    BOOL _isAnimating;
}

@property (nonatomic, strong) MBProgressHUD *loadingHUD;
@property (nonatomic, strong) UIImageView *loadingHUDSuccess;
@property (nonatomic, strong) UIImageView *loadingHUDFailure;
/**
 默认样式导航栏（返回+标题）
 */


@end

@implementation BaseAncientPoetryViewController
#pragma maek - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationPopDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_scrollView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor whiteColor];
    //统一添加默认导航栏
    [self resetNavigationBar];

    [self createScrollView];
//    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notificationActionOfNetworkStatusChanged:) name:PCNotificationNameNetworkReachabilityDidChanged object:nil];
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = true;
        
        if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
            loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            loadingView.color = [UIColor darkGrayColor];
        }

        [self.view addSubview:loadingView];
        
        [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(loadingView.superview);
            make.edges.equalTo(loadingView.superview);

        }];
        
        _loadingView = loadingView;
    }
    
    return _loadingView;
}

// navigtionbar
- (void)resetNavigationBar{
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navigationBar];
}

//MARK: Lazy
- (AncientPoetryNavigation *)navigationBar{
    if (!_navigationBar){
        _navigationBar = [[AncientPoetryNavigation alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height/UIScreen.mainScreen.bounds.size.width >= 2.16 ? 88.f : 64.f)];
        _navigationBar.delegate = self;
        [_navigationBar initWithType:PEPNavigationTypeMainNormal andDelegate:self];
        _navigationBar.backgroundColor = UIColor.themeColor;
    }
    return _navigationBar;
}

//MARK: NAVIGATION_DELEGATE
- (void)navigationBarClick:(PEPNavigationButtonType)type
{
    if (type == PEPNavigationButtonTypeBack){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


// MARK: - Public Method

- (void)requestData {
    
}

- (void)showLoadingView {
    
    [self.view bringSubviewToFront:self.loadingView];
    [self.loadingView startAnimating];
}


- (void)hideLoadingView {
    
    [self.loadingView stopAnimating];
}

- (void)showAlertWithMessage:(NSString *)message sureTitle:(NSString*)sureTitle sureHandle:(void (^)(void))sureHandle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelActio = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (sureHandle) { sureHandle(); }
    }];
    [alert addAction:cancelActio];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message sureHandle:(void (^)(void))sureHandle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (sureHandle) { sureHandle(); }
    }];
    
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

// MARK: - Notification Action

- (void)notificationActionOfUserDidLogin {
    
}

- (void)notificationActionOfUserDidLogout {
    
}

- (void)notificationActionOfNetworkStatusChanged:(NSNotification *)sender {
//    self.networkStatus = (PEPNetworkResponseStatus)[sender.object integerValue];
}


// MARK: - Network Error

- (UIButton *)networkErrorView {
    if (!_networkErrorView) {
        AncientPoetryButton *networkErrorView = [self placeholderButtonModel];
        UIImage *image = [UIImage imageNamed:@"network_error"];
        [networkErrorView setImage:image forState:UIControlStateNormal];
        [networkErrorView setImage:image forState:UIControlStateHighlighted];
        [networkErrorView addTarget:self action:@selector(networkErrorViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [networkErrorView setTitle:@"网络连接失败" forState:UIControlStateNormal];
        
        [self.view addSubview:networkErrorView];
        [networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.left.top.right.equalTo(networkErrorView.superview);
                make.bottom.equalTo(networkErrorView.superview.mas_safeAreaLayoutGuideBottom);
            } else {
                make.edges.equalTo(networkErrorView.superview);
            }
        }];
        
        _networkErrorView = networkErrorView;
    }
    
    return _networkErrorView;
}


- (void)showNetworkErrorView {
    
    [self.view bringSubviewToFront:self.networkErrorView];
    self.networkErrorView.hidden = false;
    [self.networkErrorView setNeedsLayout];
}

- (void)hideNetworkErrorView {
    
    self.networkErrorView.hidden = true;
    [self.view sendSubviewToBack:self.networkErrorView];
    
}

- (void)networkErrorViewAction:(UIButton *)sender {
    [self hideNetworkErrorView];
    [self requestData];
}

- (UIButton *)haveNoDataView {
    if (!_haveNoDataView) {
        AncientPoetryButton *haveNoDataView = [self placeholderButtonModel];
        UIImage *image = [UIImage imageNamed:@"nodata"];
        [haveNoDataView setImage:image forState:UIControlStateNormal];
        [haveNoDataView setImage:image forState:UIControlStateHighlighted];
        [haveNoDataView addTarget:self action:@selector(networkErrorViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [haveNoDataView setTitle:@"没有数据" forState:UIControlStateNormal];
        
        [self.view addSubview:haveNoDataView];
        
        [haveNoDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(haveNoDataView.superview);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(haveNoDataView.superview.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(haveNoDataView.superview.mas_bottom);
            }
        }];
        
        _haveNoDataView = haveNoDataView;
    }
    
    return _haveNoDataView;
}

- (void)showHaveNoDataView {
    
    [self.view bringSubviewToFront:self.haveNoDataView];
    self.haveNoDataView.hidden = false;
    [self.haveNoDataView setNeedsLayout];
}

- (void)hideHaveNoDataView {
    
    self.haveNoDataView.hidden = true;
    [self.view sendSubviewToBack:self.networkErrorView];
    
}

- (AncientPoetryButton *)placeholderButtonModel {
    AncientPoetryButton *placeholderButton = [AncientPoetryButton buttonWithType:UIButtonTypeCustom];
    placeholderButton.backgroundColor = [UIColor whiteColor];
    placeholderButton.contentMode = UIViewContentModeScaleAspectFit;
    [placeholderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    placeholderButton.hidden = true;
    placeholderButton.titleLabel.numberOfLines = 0;
    placeholderButton.titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightLight];
    
    return placeholderButton;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - UI

-(void)createScrollView
{
    self.view.backgroundColor =[UIColor whiteColor];
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled =YES;
    [self.view addSubview:scrollView];
    self.scrollView =scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView.superview);
    }];
}



#pragma mark - Action

/**
 是否移除父视图

 @param removeScrollView YES or NO
 */
- (void)setRemoveScrollView:(BOOL)removeScrollView
{
    _removeScrollView =removeScrollView;
    if(_removeScrollView)
    {
        [_scrollView removeFromSuperview];
    }
}


/**
 设置视图是否可以滚动

 @param scrollEnabled YES or NO
 */
- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled =scrollEnabled;
    if(_scrollEnabled){
        self.scrollView.scrollEnabled = YES;
    }else{
        self.scrollView.scrollEnabled = NO;
    }
}

/**
 设置背景色
 
 @param bgColor 背景色
 */
- (void)setBackgroudColor:(UIColor *)bgColor
{
    self.view.backgroundColor =bgColor;
}

#pragma mark - MBProgressHUD

/**
 普通提示

 @param tip 提示内容
 */
- (void)showNormalText:(NSString *)tip
{
    [self showNormalText:tip hideAfterDelay:1];
}

- (void)showNormalText:(NSString *)tip hideAfterDelay:(NSTimeInterval)afterDelay {
    
    UIView *view =self.view;
    if (view  == nil) view = [[UIApplication sharedApplication].windows lastObject];
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.margin = kProgressHUDViewMargin;
    self.loadingHUD.removeFromSuperViewOnHide = YES;
    self.loadingHUD.label.font = [UIFont systemFontOfSize:13];
    
    if (!self.loadingHUDSuccess) {
        self.loadingHUDSuccess = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    
    self.loadingHUD.customView = self.loadingHUDSuccess;
    self.loadingHUD.mode = MBProgressHUDModeCustomView;
    self.loadingHUD.label.text = tip;
    self.loadingHUD.label.numberOfLines = 0;
    self.loadingHUD.bezelView.layer.opacity = kProgressHUDOpacity;
    [self.loadingHUD hideAnimated:YES afterDelay:afterDelay];
}


/**
 加载成功
 
 @param tip 成功提示语
 */
- (void)showHudSuccess:(NSString *)tip {
    [self checkHudLoading];
    if (!self.loadingHUDSuccess) {
        self.loadingHUDSuccess = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    
    
    self.loadingHUD.customView = self.loadingHUDSuccess;
    self.loadingHUD.mode = MBProgressHUDModeCustomView;
    self.loadingHUD.label.text = tip;
    self.loadingHUD.bezelView.layer.opacity = kProgressHUDOpacity;
    [self.loadingHUD hideAnimated:YES afterDelay:1.5];
}


/**
 加载失败
 
 @param tip 失败提示语
 */
- (void)showHudFailure:(NSString *)tip {
    [self checkHudLoading];
    if (!self.loadingHUDFailure) {
        self.loadingHUDFailure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_file_cancel"]];
    }
    [self.loadingHUD showAnimated:NO];
    self.loadingHUD.bezelView.layer.opacity = kProgressHUDOpacity;
    self.loadingHUD.customView = self.loadingHUDFailure;
    self.loadingHUD.mode = MBProgressHUDModeCustomView;
    self.loadingHUD.label.text = tip;
    [self.loadingHUD hideAnimated:NO afterDelay:1.5];
}


/**
 加载成功后回调事件
 
 @param tip 成功标题
 @param aSelector 触发事件
 @param obj 参数
 */
- (void)showHudSuccess:(NSString *)tip withSelector:(SEL)aSelector withObject:(id)obj {
    [self showHudSuccess:tip];
    [self performSelector:aSelector withObject:obj afterDelay:1.5];
}


/**
 加载失败后的回调事件
 
 @param tip 失败标题
 @param aSelector 触发事件
 @param obj 参数
 */
- (void)showHudFailure:(NSString *)tip withSelector:(SEL)aSelector withObject:(id)obj {
    [self showHudFailure:tip];
    [self performSelector:aSelector withObject:obj afterDelay:1.5];
}


/**
 隐藏加载
 */
- (void)hideHudLoading {
    [self.loadingHUD hideAnimated:YES afterDelay:1.5];
}

/**立即隐藏Loading视图*/
- (void)immediatelyHideHudLoading {
    
    [self.loadingHUD hideAnimated:true];
    
}


#pragma Private
- (void)checkHudLoading {
    if (!self.loadingHUD) {
        self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loadingHUD.margin = kProgressHUDViewMargin;
        self.loadingHUD.removeFromSuperViewOnHide = YES;
        self.loadingHUD.label.font = [UIFont systemFontOfSize:13];
    }
    
}


//是否可以旋转
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice].model containsString:@"iPhone"]) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskLandscape;
    }
    
}
//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    if ([[UIDevice currentDevice].model containsString:@"iPhone"]) {
        return UIInterfaceOrientationPortrait;
    }else{
        return [[UIApplication sharedApplication] statusBarOrientation];
    }
}

- (BOOL)isViewControllerVisible:(UIViewController *)viewController {
    if (viewController.isViewLoaded && viewController.view.window) {
        return YES;
    } else {
        return NO;
    }
}

-(void)showGSCNavBarStyle{
    _navigationBar.backgroundColor = UIColor.clearColor;
}
-(void)resetGSCNavBarStyle{
    _navigationBar.backgroundColor = UIColor.themeColor;
}
@end
