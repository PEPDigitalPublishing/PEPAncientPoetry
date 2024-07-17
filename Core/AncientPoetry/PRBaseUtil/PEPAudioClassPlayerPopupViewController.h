//
//  PEPAudioClassPlayerPopupViewController.h
//  PEPRead
//
//  Created by 韩帅 on 2021/12/2.
//  Copyright © 2021 PEP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRAudioPlayerControl.h"
#import "VoiceCourseModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^PEPAudioClassPlayerPopupVCBlock)(NSInteger index);
typedef void(^PEPAudioClassPlayerPopupVCCountDownBlock)(NSInteger countDown,NSInteger index);
@interface PEPAudioClassPlayerPopupViewController : UIViewController
@property (nonatomic, strong) VoiceCourseModel *dataSource;
@property(nonatomic,assign)AudioPlayerPopupMode mode;/**<  */
@property(nonatomic,copy)PEPAudioClassPlayerPopupVCBlock block;/**<  */
@property(nonatomic,copy)PEPAudioClassPlayerPopupVCCountDownBlock countDownBlock;/**<  */
@property (nonatomic, assign) BOOL isBuy;

@property(nonatomic,assign)NSInteger countDownIndex;/**<  选中的倒计时标志位*/
+(instancetype)initwithType:(AudioPlayerPopupMode)mode;


@end

NS_ASSUME_NONNULL_END
