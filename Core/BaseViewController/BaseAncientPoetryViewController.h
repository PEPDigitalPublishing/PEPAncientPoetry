//
//  BaseAncientPoetryViewController.h
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import <UIKit/UIKit.h>
#import "AncientPoetryNavigation.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseAncientPoetryViewController : UIViewController



@property (nonatomic , strong)AncientPoetryNavigation *navigationBar;
/**
 滚动视图,添加子视图,请添加在scrollView上,如果需要添加到view上,请调用removeScrollView.
 */
@property(nonatomic, strong) UIScrollView *scrollView;


/**
 移除滚动视图,移除后scrollView相关设置无效,默认为NO
 */
@property(nonatomic, assign) BOOL removeScrollView;


/**
 设置是否隐藏tabbar,默认为NO
 */
@property(nonatomic, assign) BOOL shouldHideTabbar;


/**
 设置视图是否可滚动,默认为YES
 */
@property(nonatomic, assign) BOOL scrollEnabled;

//pc新增
@property (nonatomic, assign, readonly) UIEdgeInsets safeAreaInsets;

/**
 设置背景色

 @param bgColor 背景色
 */
- (void)setBackgroudColor:(UIColor *)bgColor;


///**
// 屏幕发生旋转时调用
//
// */
//- (void)statusBarOrientationChange;


///**
// 返回按钮点击事件
//
// @param sender 按钮
// */
//- (void)handleBackButton:(id)sender;


///**
// 导航条返回事件(默认返回上一级)
// */
//- (void)back;



/**
 只有一个按钮的Alert（无取消按钮）

 @param title 标题
 @param message 提示文本
 @param buttonTitle 按钮标题
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

/**
 单个按钮提示框

 @param message 提示框文字
 */
- (void)showAlertViewByMessage:(NSString *)message;


/**
 带标题的提示框

 @param message 提示文字
 @param title 标题
 */
- (void)showAlertViewByMessage:(NSString *)message title:(NSString *)title;


/**
 可定制按钮提示框

 @param title 标题
 @param message 内容
 @param firstTitle 第一个按钮标题
 @param fristHandler 第一个按钮触发事件
 @param secondTitle 第二个按钮标题
 @param secondHandler 第二个按钮触发事件
 */
- (void)showAlertViewByTitle:(NSString *)title message:(NSString *)message
               firstBtnTitle:(NSString *)firstTitle fristHandler:(void (^)(UIAlertAction *action))fristHandler
              secondBtnTitle:(NSString *)secondTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler;


/**
 显示普通提示框

 @param tip 提示语
 */
- (void)showNormalText:(NSString *)tip;
- (void)showNormalText:(NSString *)tip hideAfterDelay:(NSTimeInterval)afterDelay;


/**
 隐藏加载
 */
- (void)hideHudLoading;

/**立即隐藏Loading视图*/
- (void)immediatelyHideHudLoading;


/**
 显示加载

 @param tip 加载标题
 */
- (void)showHudLoading:(NSString *)tip;


/**
 加载成功

 @param tip 成功提示语
 */
- (void)showHudSuccess:(NSString *)tip;


/**
 加载失败

 @param tip 失败提示语
 */
- (void)showHudFailure:(NSString *)tip;


/**
 加载成功后回调事件

 @param tip 成功标题
 @param aSelector 触发事件
 @param obj 参数
 */
- (void)showHudSuccess:(NSString *)tip withSelector:(SEL)aSelector withObject:(id)obj;


/**
 加载失败后的回调事件

 @param tip 失败标题
 @param aSelector 触发事件
 @param obj 参数
 */
- (void)showHudFailure:(NSString *)tip withSelector:(SEL)aSelector withObject:(id)obj;


//pc新增
// MARK: - Override

/**
 请求数据方法：基类不做具体实现，建议每个子类需要请求数据时分别实现该方法，以便别处可通过基类调用该方法以刷新数据和页面（多态）
 */
- (void)requestData;

/** 用户已经登录后将调用此方法，基类不做具体实现。子类若需要，可实现该方法 */
- (void)notificationActionOfUserDidLogin;

/** 用户已经退出后将调用此方法，基类不做具体实现。子类若需要，可实现该方法 */
- (void)notificationActionOfUserDidLogout;


// MARK: - Alert

- (void)showLogOutAlert;

- (void)showSessionInvalidAlert;

//带取消按钮
- (void)showAlertWithMessage:(NSString *)message sureTitle:(NSString*)sureTitle sureHandle:(void (^)(void))sureHandle;

- (void)showAlertWithMessage:(NSString *)message sureHandle:(void (^)(void))sureHandle;



// MARK: - Loading

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

- (void)showLoadingView;

- (void)hideLoadingView;




// MARK: - Network Error

@property (nonatomic, strong) UIButton *networkErrorView;
@property (nonatomic, strong) UIButton *haveNoDataView;

@property (nonatomic, copy) void(^networkErrorViewClicked)(void);

- (void)showNetworkErrorView;

- (void)hideNetworkErrorView;

- (void)showHaveNoDataView;

- (void)hideHaveNoDataView;

/// 判断当前控制器是否在显示
/// - Parameter viewController: 当前控制器
- (BOOL)isViewControllerVisible:(UIViewController *)viewController;

-(void)showGSCNavBarStyle;
-(void)resetGSCNavBarStyle;

@end

NS_ASSUME_NONNULL_END
