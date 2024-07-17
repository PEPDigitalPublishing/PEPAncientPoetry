//
//  YSAudioAncientPoetryToast.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "YSAudioAncientPoetryToast.h"
#import <Masonry/Masonry.h>
#import <ChameleonFramework/Chameleon.h>

@interface PEPToastView : UIView

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) YSAudioAncientPoetryType type;

@end

@implementation PEPToastView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)initSubviews {
    if (self.type == YSAudioAncientPoetryTypeNormal){
        [self initNormalView];
    }else if (self.type == YSAudioAncientPoetryTypeSignIn){
        [self initSignInView];
    }else{
        [self initNormalView];
    }
}

- (void)initNormalView{
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.alpha = 0.8;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label sizeToFit];
    if (UIDevice.currentDevice.systemVersion.floatValue >= 8.2) {
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    } else {
        label.font = [UIFont systemFontOfSize:14];
    }
    
    [self addSubview:effectView];
    [self addSubview:label];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(effectView.superview);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label.superview).insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    
    self.effectView = effectView;
    self.label = label;
}

- (void)initSignInView{
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.alpha = 0.8;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"#F7F7FE"];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    [label sizeToFit];
    label.font = [UIFont boldSystemFontOfSize:15];
    
    UIImageView * icon = [[UIImageView alloc] init];
    icon.backgroundColor = [UIColor colorWithHexString:@"#F7F7FE"];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 35;
    
    UIView *background = [[UIView alloc] init];
    background.backgroundColor = UIColor.whiteColor;
    background.layer.masksToBounds = YES;
    background.layer.cornerRadius = 10;
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"开心收下" forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithHexString:@"#20ACB1"];
    
    [self addSubview:effectView];
    [self addSubview:background];
    [background addSubview:icon];
    [background addSubview:label];
    [background addSubview:button];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(effectView.superview);
    }];
    
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((UIScreen.mainScreen.bounds.size.width-20)*9/16));
        make.width.equalTo(@(UIScreen.mainScreen.bounds.size.width-20));
        make.center.equalTo(effectView.superview);
    }];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(70));
        make.centerX.equalTo(background);
        make.top.equalTo(@(30));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(background);
        make.top.mas_equalTo(icon.mas_bottom).offset(20);
        make.width.equalTo(background);
        make.height.equalTo(@(20));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(40));
        make.bottom.equalTo(@(-20));
        make.right.equalTo(@(-40));
        make.height.equalTo(@(45));
    }];
    
    self.effectView = effectView;
    self.label = label;
    self.sureButton = button;
}

- (void)buttonClick:(UIButton *)button{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setText:(NSString *)text {
    
    self.label.text = text;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint lastPoint = [touch previousLocationInView:self];
    CGPoint offsetPoint = CGPointMake(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y);
    
    CGFloat offset_y = offsetPoint.y;
    
    CGFloat top = (UIScreen.mainScreen.bounds.size.height/UIScreen.mainScreen.bounds.size.width >= 2.16 ? 88 : 64) + 12;
    CGFloat bottom = self.superview.bounds.size.height - 34;
    if (self.frame.origin.y + offsetPoint.y <= top ) {
        offset_y = 0;
    } else if (self.frame.origin.y + self.frame.size.height + offsetPoint.y >= bottom) {
        offset_y = bottom - self.frame.origin.y - self.frame.size.height;
    }
    
    self.transform = CGAffineTransformTranslate(self.transform, 0, offset_y);
}

@end

@interface YSAudioAncientPoetryToast()

@property (nonatomic , strong) PEPToastView *toastView;

@end

@implementation YSAudioAncientPoetryToast

+ (PEPToastView *)toastViewWithToastType:(YSAudioAncientPoetryType)type {
    PEPToastView *toastView = [[PEPToastView alloc] init];
    toastView.alpha = 0;
    toastView.layer.masksToBounds = true;
    toastView.layer.cornerRadius = 5;
    toastView.type = type;
    [toastView initSubviews];
    return toastView;
}

+ (void)showToastByMessage:(NSString *)message inView:(UIView *)view andType:(YSAudioAncientPoetryType)type{
    if (!message){return;}
    if (message.length == 0) { return; }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [YSAudioAncientPoetryToast showToastViewByMessage:message inView:view toastType:type];
    });
}

+ (void)showToastViewByMessage:(NSString *)message inView:(UIView *)view toastType:(YSAudioAncientPoetryType)type{
    NSInteger tag = 23333;
    PEPToastView *toastView = [self toastViewWithToastType:type];
    toastView.tag = tag;
    if (view) {
        [[view viewWithTag:tag] removeFromSuperview];
        [view addSubview:toastView];
    } else {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [[keyWindow viewWithTag:tag] removeFromSuperview];
        [keyWindow addSubview:toastView];
    }
    
    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@" \n"];
    toastView.text = [NSString stringWithFormat:@" %@ ", message];
    if (type == YSAudioAncientPoetryTypeSignIn){
        toastView.frame = view.frame;
    }else{
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(toastView.superview);
            make.centerX.equalTo(toastView.superview);
            make.width.height.lessThanOrEqualTo(toastView.superview).multipliedBy(0.618).priorityHigh();
            make.height.greaterThanOrEqualTo(@30);
        }];
    }
    if (type == YSAudioAncientPoetryTypeSignIn){
        [self showSignInToastWith:toastView];
    }else{
        [self showNormalAnimateWith:toastView];
    }
}

+ (void)showSignInToastWith:(PEPToastView *)toastView{
    [UIView animateWithDuration:0.3 animations:^{
        toastView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)showNormalAnimateWith:(PEPToastView *)toastView{
    [UIView animateWithDuration:0.3 animations:^{
        toastView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                toastView.alpha = 0;
            } completion:^(BOOL finished) {
                [toastView removeFromSuperview];
            }];
        });
    }];
}

@end
