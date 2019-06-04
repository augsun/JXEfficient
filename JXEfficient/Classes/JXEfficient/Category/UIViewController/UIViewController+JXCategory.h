//
//  UIViewController+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 6/12/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (JXCategory)

/**
 默认 push <hidesBottomBarWhenPushed:YES && animated:YES>
 */
- (void)jx_pushVC:(UIViewController *)vc;

/**
 默认 push <hidesBottomBarWhenPushed:YES && animated:YES>, 同时将当前控制器从 UINavigationController 的 viewControllers 中移除.
 */
- (void)jx_pushVCAndRemoveSelf:(UIViewController *)vc;

/**
 @param vc push 的控制器
 @param hidesBottomBarWhenPushed 隐藏 tabbar
 @param animated 动画 push
 */
- (void)jx_pushVC:(UIViewController *)vc hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed animated:(BOOL)animated;

- (nullable UIViewController *)jx_popVC; ///< pop 控制器 <animated:YES>
- (nullable UIViewController *)jx_popVCAnimated:(BOOL)animated; ///< pop 控制器

@end

NS_ASSUME_NONNULL_END
