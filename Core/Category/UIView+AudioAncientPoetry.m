//
//  UIView+AudioAncientPoetry.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "UIView+AudioAncientPoetry.h"
#import <objc/runtime.h>

static CGFloat const animationDuration = 0.1;
@implementation UIView (AudioAncientPoetry)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = true;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

/**
 获取x坐标
 */
- (CGFloat)x
{
    return self.frame.origin.x;
}

/**
 获取y坐标
 */
- (CGFloat)y
{
    return self.frame.origin.y;
}

+ (instancetype)viewFromNibByDefaultClassName:(id)owner option:(NSDictionary *)dic {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:owner options:dic] firstObject];
}

/**
 清除所有子视图
 */
-(void)removeAllSubViews{
    for (UIView *subview in self.subviews){
        [subview removeFromSuperview];
    }
}

#pragma mark - Position
- (void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setLeft:(CGFloat)left {
    CGRect newFrame = self.frame;
    newFrame.origin.x = left;
    self.frame = newFrame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setTop:(CGFloat)top {
    CGRect newFrame = self.frame;
    newFrame.origin.y = top;
    self.frame = newFrame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect newFrame = self.frame;
    newFrame.origin.y = bottom - self.height;
    self.frame = newFrame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.height;
}

- (void)setRight:(CGFloat)right {
    CGRect newFrame = self.frame;
    newFrame.origin.x = right - self.left;
    self.frame = newFrame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.width;
}

- (void)setSize:(CGSize)size {
    CGRect newFrame = self.frame;
    newFrame.size = size;
    self.frame = newFrame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect newFrame = self.frame;
    newFrame.origin = origin;
    self.frame = newFrame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint newCenter = self.center;
    newCenter.x = centerX;
    self.center = newCenter;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint newCenter = self.center;
    newCenter.y = centerY;
    self.center = newCenter;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGPoint)getCenterWithRect:(CGRect)rect {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

- (void)scaleRelativeOriginByFactor:(CGFloat)scaleFactor {
    [self scaleRelativeOriginByFactor:scaleFactor animation:false];
}

- (void)scaleRelativeOriginByFactor:(CGFloat)scaleFactor animation:(BOOL)allowAnimation {
    if (scaleFactor <= 0) { return; }
    
    CGRect newFrame = self.frame;
    newFrame.size.width  *= scaleFactor;
    newFrame.size.height *= scaleFactor;
    [UIView animateWithDuration:(allowAnimation ? 0.2 : 0) animations:^{
        self.frame = newFrame;
    }];
}

- (void)scaleRelativeCenterByFactor:(CGFloat)scaleFactor {
    [self scaleRelativeCenterByFactor:scaleFactor animation:false];
}

- (void)scaleRelativeCenterByFactor:(CGFloat)scaleFactor animation:(BOOL)allowAnimation {
    if (scaleFactor <= 0) { return; }
    
    CGFloat insetWidth = (1-scaleFactor) * self.width;
    CGFloat insetHeight = (1-scaleFactor) * self.height;
    
    CGRect newFrame = CGRectInset(self.frame, insetWidth/2, insetHeight/2);
    [UIView animateWithDuration:(allowAnimation ? 0.2 : 0) animations:^{
        self.frame = newFrame;
    }];
}

#pragma mark - Responder Chain
- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

- (UINavigationController *)navigationController {
    return self.viewController.navigationController;
}

#pragma mark - Associated Proprety
- (void)setAllowFollowDraging:(BOOL)allowFollowDraging {
    self.userInteractionEnabled = true;
    objc_setAssociatedObject(self, @selector(allowFollowDraging), @(allowFollowDraging), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)allowFollowDraging {
    NSNumber *num = (NSNumber *)objc_getAssociatedObject(self, @selector(allowFollowDraging));
    return num.boolValue;
}

- (void)setSpringback:(BOOL)springback {
    objc_setAssociatedObject(self, @selector(springback), @(springback), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)springback {
    NSNumber *num = (NSNumber *)objc_getAssociatedObject(self, @selector(springback));
    return num.boolValue;
}

- (BOOL)allowSpring {
    NSNumber *num = (NSNumber *)objc_getAssociatedObject(self, @selector(allowSpring));
    return num.boolValue;
}

- (void)setAllowSpring:(BOOL)allowSpring {
    objc_setAssociatedObject(self, @selector(allowSpring), @(allowSpring), OBJC_ASSOCIATION_ASSIGN);
    if (allowSpring == true) {
        self.userInteractionEnabled = allowSpring;
    }
}

- (BOOL)allowForceTouchScale {
    NSNumber *num = objc_getAssociatedObject(self, @selector(allowForceTouchScale));
    return num.boolValue;
}

- (void)setAllowForceTouchScale:(BOOL)allowForceTouchScale {
    objc_setAssociatedObject(self, @selector(allowForceTouchScale), @(allowForceTouchScale), OBJC_ASSOCIATION_ASSIGN);
    if (allowForceTouchScale == true) {
        self.userInteractionEnabled = allowForceTouchScale;
    }
}

- (CGFloat)maxForceTouchScale {
    NSNumber *num = objc_getAssociatedObject(self, @selector(maxForceTouchScale));
    return num != nil ? num.floatValue : 1.2;
}

- (void)setMaxForceTouchScale:(CGFloat)maxForceTouchScale {
    objc_setAssociatedObject(self, @selector(maxForceTouchScale), @(maxForceTouchScale), OBJC_ASSOCIATION_ASSIGN);
}

- (void)showZoomAnimation {
    [self showZoomAnimationWithMaxScale:0];
    
}
- (void)showZoomAnimationWithMaxScale:(CGFloat)scale {
    [self.layer removeAllAnimations];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(1);
    animation.toValue = @(MAX(1, scale));
    animation.duration = 0.2;
    animation.autoreverses = YES;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
    
}




#pragma mark - Touch Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (self.allowSpring == true) {
        CGFloat scale = 0.97;
        [UIView animateWithDuration:animationDuration animations:^{
            self.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    if (self.allowFollowDraging == true) {
        CGPoint currentPoint = [touch locationInView:self];
        CGPoint lastPoint = [touch previousLocationInView:self];
        CGPoint offsetPoint = CGPointMake(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y);
        
        self.transform = CGAffineTransformTranslate(self.transform, offsetPoint.x, offsetPoint.y);
    }
    
    if (@available(iOS 9.0, *)) {
        if (self.allowForceTouchScale == true) {
            CGFloat scale = touch.force / touch.maximumPossibleForce * (self.maxForceTouchScale - 1) + 1;
            [UIView animateWithDuration:animationDuration animations:^{
                self.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.allowFollowDraging == true && self.springback == true) {
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
    
    if (self.allowSpring) {
        CGFloat scale = 1.03;
        [UIView animateWithDuration:animationDuration animations:^{
            self.transform = CGAffineTransformMakeScale(scale, scale);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    
    if (@available(iOS 9.0, *)) {
        if (self.allowForceTouchScale == true) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    if (self.allowFollowDraging == true && self.springback == true) {
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
    
    if (@available(iOS 9.0, *)) {
        if (self.allowForceTouchScale == true) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)roundedRect:(UIRectCorner)corner raduis:(CGFloat)raduis {
    [self roundedRect:corner bounds:self.bounds raduis:raduis];
}

- (void)roundedRect:(UIRectCorner)corner bounds:(CGRect)bounds raduis:(CGFloat)raduis {
    NSLog(@">>>%@", NSStringFromCGRect(bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corner cornerRadii:CGSizeMake(raduis, raduis)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}


- (void)setCornerWithTopLeftCorner:(CGFloat)topLeft
                    topRightCorner:(CGFloat)topRight
                  bottomLeftCorner:(CGFloat)bottemLeft
                 bottomRightCorner:(CGFloat)bottemRight
                            bounds:(CGRect)bounds {
    
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1.0;
    maskPath.lineCapStyle = kCGLineCapRound;
    maskPath.lineJoinStyle = kCGLineJoinRound;
    [maskPath moveToPoint:CGPointMake(bottemRight, height)]; //左下角
    [maskPath addLineToPoint:CGPointMake(width - bottemRight, height)];
    
    [maskPath addQuadCurveToPoint:CGPointMake(width, height- bottemRight) controlPoint:CGPointMake(width, height)]; //右下角的圆弧
    [maskPath addLineToPoint:CGPointMake(width, topRight)]; //右边直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(width - topRight, 0) controlPoint:CGPointMake(width, 0)]; //右上角圆弧
    [maskPath addLineToPoint:CGPointMake(topLeft, 0)]; //顶部直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(0, topLeft) controlPoint:CGPointMake(0, 0)]; //左上角圆弧
    [maskPath addLineToPoint:CGPointMake(0, height - bottemLeft)]; //左边直线
    [maskPath addQuadCurveToPoint:CGPointMake(bottemLeft, height) controlPoint:CGPointMake(0, height)]; //左下角圆弧

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
