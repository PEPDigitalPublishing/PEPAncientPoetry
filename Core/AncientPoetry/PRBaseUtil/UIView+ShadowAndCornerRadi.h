//
//  UIView+ShadowAndCornerRadi.h
//  PEPRead
//
//  Created by sunShine on 2022/10/13.
//  Copyright © 2022 PEP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ShadowAndCornerRadi)

-(void)createNoneShadowAndCornerRadii;
/// 添加圆角
/// @param corners 圆角类型
/// @param cornerRadi 圆角尺寸
-(void)createShapeLayerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadi;

-(void)createShadowAndShapeLayerWithCornerRadii:(CGSize)cornerRadi;

//
-(void)createJFShadowAndShapeLayerWithCornerRadii:(CGSize)cornerRadi;
// 特殊样式
-(void)createShadowAndCornerRadiiStyleOne:(CGSize)cornerRadi;


-(void)createCalendarShadowAndShapeLayerWithCornerRadii:(CGSize)cornerRadi;

// 先删除后添加
-(void)createCalendarShadowAndShapeLayerAndDelOldLayerWithCornerRadii:(CGSize)cornerRadi;
/// 添加圆角和阴影
/// - Parameters:
///   - cornerRadi: 圆角半径
///   - radius: 阴影半径
-(void)createShadowAndShapeLayerWithCornerRadii:(CGSize)cornerRadi shadowRadius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
