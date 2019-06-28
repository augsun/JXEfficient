//
//  UIButton+JXCategory.m
//  JXEfficient
//
//  Created by augsun on 9/8/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import "UIButton+JXCategory.h"
#import "UIImage+JXCategory.h"

@implementation UIButton (JXCategory)

- (void)jx_backgroundColorStyleNormalColor:(UIColor *)normalColor
                          highlightedColor:(UIColor *)highlightedColor
                             disabledColor:(UIColor *)disabledColor
                                    radius:(CGFloat)radius
{
    UIImage *normalImage = nil;
    if (normalColor) {
        normalImage = [UIImage jx_imageFromColor:normalColor radius:radius];
    }
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];

    UIImage *highlightedImage = nil;
    if (highlightedColor) {
         highlightedImage = [UIImage jx_imageFromColor:highlightedColor radius:radius];
    }
    [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    UIImage *disabledImage = nil;
    if (disabledColor) {
         disabledImage = [UIImage jx_imageFromColor:disabledColor radius:radius];
    }
    [self setBackgroundImage:disabledImage forState:UIControlStateDisabled];
}

- (void)jx_titleColorStyleNormalColor:(UIColor *)normalColor
                     highlightedColor:(UIColor *)highlightedColor
                        disabledColor:(UIColor *)disabledColor
{
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:disabledColor forState:UIControlStateDisabled];
}

- (void)jx_titleForAllStatus:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
    self.titleLabel.text = title;
}

@end










