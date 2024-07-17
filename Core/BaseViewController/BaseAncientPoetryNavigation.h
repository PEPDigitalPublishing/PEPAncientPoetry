//
//  BaseAncientPoetryNavigation.h
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PCNavigationControllerPopDelegate <NSObject>

@optional

- (void)navigationBarShouldPopViewController:(UINavigationController *)nvigationController onBackBarButtonAction:(UIBarButtonItem *)backBarButtonItem;

@end


@interface UINavigationController (Pop)

/** 如果需要禁用右划pop手势，将此参数设置为true */
@property (nonatomic, assign, getter=isLimitPopGesture) BOOL limitPopGesture;

/** 如果需要pop到指定视图控制器，设置此参数 */
@property (nonatomic, weak) UIViewController *popToViewController;

/** 如果需要pop回根视图控制器，将此参数设置为true */
@property (nonatomic, assign, getter=isPopToRootViewController) BOOL popToRootViewController;

/** pop delegate */
@property (nonatomic, weak) id<PCNavigationControllerPopDelegate> navigationPopDelegate;

@end

@interface BaseAncientPoetryNavigation : UINavigationController

@end

NS_ASSUME_NONNULL_END
