//
//  AncientPoetryButton.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "AncientPoetryButton.h"

@implementation AncientPoetryButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.hidden) { return; }
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return;
    }
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height-5, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height-5, 0, 0, -titleSize.width);
    
}

@end
