//
//  YSAudioAncientPoetryToast.h
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , YSAudioAncientPoetryType){
    YSAudioAncientPoetryTypeNormal = 0,
    YSAudioAncientPoetryTypeSignIn,
};

@interface YSAudioAncientPoetryToast : UIView

+ (void)showToastByMessage:(NSString *)message inView:(UIView *)view andType:(YSAudioAncientPoetryType)type;

@end

NS_ASSUME_NONNULL_END
