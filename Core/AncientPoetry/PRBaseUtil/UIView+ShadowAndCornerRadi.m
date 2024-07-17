//
//  UIView+ShadowAndCornerRadi.m
//  PEPRead
//
//  Created by sunShine on 2022/10/13.
//  Copyright © 2022 PEP. All rights reserved.
//

#import "UIView+ShadowAndCornerRadi.h"
#import <ChameleonFramework/Chameleon.h>

@implementation UIView (ShadowAndCornerRadi)

-(void)createNoneShadowAndCornerRadii{
    [self setNeedsLayout];
    [self.superview layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
-(void)createShapeLayerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadi{
    [self setNeedsLayout];
    [self.superview layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadi];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)createShadowAndShapeLayerWithCornerRadii:(CGSize)cornerRadi{
    [self setNeedsLayout];
    [self.superview layoutIfNeeded];
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = self.frame;
    subLayer.cornerRadius = cornerRadi.width;
    subLayer.masksToBounds = NO;
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 3);
    subLayer.shadowOpacity = 0.3;
    subLayer.shadowRadius = 2;
    subLayer.shadowPath = [UIBezierPath bezierPathWithRect:subLayer.bounds].CGPath;
    [self.superview.layer insertSublayer:subLayer below:self.layer];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadi];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
-(void)createJFShadowAndShapeLayerWithCornerRadii:(CGSize)cornerRadi{
    [self setNeedsLayout];
    [self.superview layoutIfNeeded];
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = self.frame;
    subLayer.cornerRadius = cornerRadi.width;
    subLayer.masksToBounds = NO;
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 3);
    subLayer.shadowOpacity = 0.3;
    subLayer.shadowRadius = 5;
    subLayer.shadowPath = [UIBezierPath bezierPathWithRect:subLayer.bounds].CGPath;
    [self.superview.layer insertSublayer:subLayer below:self.layer];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadi];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
-(void)createShadowAndCornerRadiiStyleOne:(CGSize)cornerRadi{
    [self setNeedsLayout];
    [self.superview layoutIfNeeded];
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = self.frame;
    subLayer.cornerRadius = cornerRadi.width;
    subLayer.masksToBounds = NO;
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    subLayer.shadowOffset = CGSizeMake(3, 3);
    subLayer.shadowOpacity = 0.3;
    subLayer.shadowRadius = 2;
    subLayer.shadowPath = [UIBezierPath bezierPathWithRect:subLayer.bounds].CGPath;
    [self.superview.layer insertSublayer:subLayer below:self.layer];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadi];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)createCalendarShadowAndShapeLayerWithCornerRadii:(CGSize)cornerRadi{
    [self setNeedsLayout];
    [self.superview layoutIfNeeded];
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = self.frame;
    subLayer.cornerRadius = cornerRadi.width;
    subLayer.masksToBounds = NO;
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 3);
    subLayer.shadowOpacity = 0.2;
    subLayer.shadowRadius = 5;
    subLayer.shadowPath = [UIBezierPath bezierPathWithRect:subLayer.bounds].CGPath;
    [self.superview.layer insertSublayer:subLayer below:self.layer];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadi];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
-(void)createCalendarShadowAndShapeLayerAndDelOldLayerWithCornerRadii:(CGSize)cornerRadi{
//    [self setNeedsLayout];
//    [self.superview layoutIfNeeded];
//
    
    self.layer.shadowColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 5;
    self.clipsToBounds = NO;
    self.layer.cornerRadius = cornerRadi.width;
    if (@available(iOS 11.0, *)) {
        self.layer.maskedCorners = (CACornerMask)UIRectCornerAllCorners;
    } else {
        // Fallback on earlier versions
    }
}

-(void)createShadowAndShapeLayerWithCornerRadii:(CGSize)cornerRadi shadowRadius:(CGFloat)radius{
//    [self.superview.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self setNeedsLayout];
    [self.superview layoutIfNeeded];
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = self.frame;
    subLayer.cornerRadius = cornerRadi.width;
    subLayer.masksToBounds = NO;
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 3);
    subLayer.shadowOpacity = 0.2;
    subLayer.shadowRadius = radius;
    subLayer.shadowPath = [UIBezierPath bezierPathWithRect:subLayer.bounds].CGPath;
    [self.superview.layer insertSublayer:subLayer below:self.layer];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadi];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
