//
//  UIButton+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 9/8/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (JXCategory)

/**
 设置三种 UIControlState 状态下的背景颜色.

 @param normalColor UIControlStateNormal 状态下背景颜色
 @param highlightedColor UIControlStateHighlighted 状态下背景颜色
 @param disabledColor UIControlStateDisabled 状态下背景颜色
 @param radius 圆角半径 (图片圆角)
 @discussion 其实质是生成不同状态的图片
 */
- (void)jx_backgroundColorStyleNormalColor:(nullable UIColor *)normalColor
                          highlightedColor:(nullable UIColor *)highlightedColor
                             disabledColor:(nullable UIColor *)disabledColor
                                    radius:(CGFloat)radius;

/**
 设置三种 UIControlState 状态下的文字颜色.

 @param normalColor UIControlStateNormal 状态下文字颜色
 @param highlightedColor UIControlStateHighlighted 状态下文字颜色
 @param disabledColor UIControlStateDisabled 状态下文字颜色
 */
- (void)jx_titleColorStyleNormalColor:(nullable UIColor *)normalColor
                     highlightedColor:(nullable UIColor *)highlightedColor
                        disabledColor:(nullable UIColor *)disabledColor;

/**
 统一设置 UIControlStateNormal UIControlStateHighlighted UIControlStateDisabled 三种状态下的标题

 @param title 标题
 */
- (void)jx_titleForAllStatus:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
