//
//  PRWebVideoViewController.h
//  PEPRead
//BaseViewController
//  Created by 韩帅 on 2022/1/14.
//  Copyright © 2022 PEP. All rights reserved.
//


#import "PRWebVideoModuleModel.h"
#import <UIKit/UIKit.h>
#import "BaseAncientPoetryViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRWebVideoViewController : BaseAncientPoetryViewController
@property(nonatomic,strong)PRWebVideoModuleModel *model;/**<  */
@property(nonatomic,assign)bool is_poetry;/**<  诗歌类型*/

@end

NS_ASSUME_NONNULL_END
