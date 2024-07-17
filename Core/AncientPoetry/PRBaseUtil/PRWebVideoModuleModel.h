//
//  PRWebVideoModuleModel.h
//  PEPRead
//
//  Created by 韩帅 on 2022/1/18.
//  Copyright © 2022 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRWebVideoModuleModel : NSObject
@property(nonatomic,copy)NSString *code;/**<  */
@property(nonatomic,copy)NSString *title;/**<  */
@property(nonatomic,copy)NSString *thumbUrl;/**<  */
@property(nonatomic,copy)NSString *label;/**<  */
@property(nonatomic,copy)NSString *videoUrl;/**<  */
@property(nonatomic,copy)NSString *command;/**<  */

@property(nonatomic,assign)NSInteger likeCount;/**<  */
@property(nonatomic,assign)NSInteger forwardCount;/**<  */
@end

NS_ASSUME_NONNULL_END
