//
//  AncientPoetryCommonUtil.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "AncientPoetryCommonUtil.h"

@implementation AncientPoetryCommonUtil

/*
 *  获取顶层控制器
 */
+ (UIViewController *)findVisibleViewController {
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
