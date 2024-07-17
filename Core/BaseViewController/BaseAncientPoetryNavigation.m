//
//  BaseAncientPoetryNavigation.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "BaseAncientPoetryNavigation.h"
#import <objc/runtime.h>
// MARK: -
// MARK: - UINavigationController (Pop)

@implementation UINavigationController (Pop)

- (void)setLimitPopGesture:(BOOL)limitPopGesture {
    objc_setAssociatedObject(self, @selector(isLimitPopGesture), @(limitPopGesture), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isLimitPopGesture {
    NSNumber *num = (NSNumber *)objc_getAssociatedObject(self, @selector(isLimitPopGesture));
    return num.boolValue;
}


- (void)setPopToRootViewController:(BOOL)popToRootViewController {
    objc_setAssociatedObject(self, @selector(isPopToRootViewController), @(popToRootViewController), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isPopToRootViewController {
    NSNumber *num = (NSNumber *)objc_getAssociatedObject(self, @selector(isPopToRootViewController));
    return num.boolValue;
}


- (void)setPopToViewController:(UIViewController *)popToViewController {
    objc_setAssociatedObject(self, @selector(popToViewController), popToViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)popToViewController {
    return objc_getAssociatedObject(self, @selector(popToViewController));
}


- (void)setNavigationPopDelegate:(id<PCNavigationControllerPopDelegate>)navigationPopDelegate {
    objc_setAssociatedObject(self, @selector(navigationPopDelegate), navigationPopDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<PCNavigationControllerPopDelegate>)navigationPopDelegate {
    return objc_getAssociatedObject(self, @selector(navigationPopDelegate));
}

// MARK: - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end


// MARK: -
// MARK: - BaseNavigationController

@interface BaseAncientPoetryNavigation ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation BaseAncientPoetryNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    [self replacePopGesture];   //设置右滑返回
}
// MARK: - Action

- (void)backBarButtonItemAction:(UIBarButtonItem *)sender {
    
    if ([self.navigationPopDelegate respondsToSelector:@selector(navigationBarShouldPopViewController:onBackBarButtonAction:)]) {
        [self.navigationPopDelegate navigationBarShouldPopViewController:self onBackBarButtonAction:sender];
    } else {
        
        if (self.popToViewController) {
            [self popToViewController:self.popToViewController animated:true];
            self.popToViewController = nil;
        } else if (self.popToRootViewController) {
            [self popToRootViewControllerAnimated:true];
            self.popToRootViewController = false;
        } else {
            [self popViewControllerAnimated:true];
        }
        
    }
}


// MARK: - Override

// 点击跳转时隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


// MARK: - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self configNavigationBarBackItem];
    self.limitPopGesture = false;
}


// MARK: - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.limitPopGesture == true) { return false; }
    
    // 左划Pop手势作用范围为屏幕的左40%宽度
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    if (touchPoint.x > CGRectGetWidth(self.view.bounds) * 0.4) {
        return false;
    }
    
    return self.viewControllers.count != 1;
}



// MARK: - UI

- (void)replacePopGesture {
    
    SEL sel = NSSelectorFromString(@"handleNavigationTransition:");
    
    if ([self.interactivePopGestureRecognizer.delegate respondsToSelector:sel]) {
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:sel];
        
        pan.delegate = self;
        
        [self.view addGestureRecognizer:pan];
    }
    
}

- (void)configNavigationBarBackItem {
    if (self.viewControllers.count < 2) { return; }
    
    UIBarButtonItem *backItem = [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemAction:)];
    self.topViewController.navigationItem.leftBarButtonItem = backItem;
}


// MARK: - Interface Orientation

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}
//是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return NO;
}
//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


@end
