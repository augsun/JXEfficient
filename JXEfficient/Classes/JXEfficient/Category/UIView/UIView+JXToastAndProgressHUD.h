//
//  UIView+JXToastAndProgressHUD.h
//  JXEfficient
//
//  Created by augsun on 6/12/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCircleProgressHUDView.h>

@interface UIView (JXToastAndProgressHUD)

#pragma mark Toast

// toast 样式 <全局>
+ (void)jx_toastStyleBgColor:(UIColor *)bgColor; ///< 背景颜色
+ (void)jx_toastStyleTextColor:(UIColor *)textColor; ///< 文本颜色
+ (void)jx_toastStyleResetToDefault; ///< 重置

// toast 提示
- (void)jx_showToast:(NSString *)toast animated:(BOOL)animated;
- (void)jx_showToast:(NSString *)toast animated:(BOOL)animated complete:(void (^)(void))complete;
- (void)jx_showToast:(NSString *)toast animated:(BOOL)animated yOffset:(CGFloat)yOffset;
- (void)jx_showToast:(NSString *)toast animated:(BOOL)animated yOffset:(CGFloat)yOffset complete:(void (^)(void))complete;
- (BOOL)jx_toastShowing;

#pragma mark ProgresssHUD

// ProgresssHUD 样式 <全局>
+ (void)jx_progressHUDStyleBgColor:(UIColor *)bgColor; ///< 背景色
+ (void)jx_progressHUDStyleTextColor:(UIColor *)textColor; ///< 文本颜色
+ (void)jx_progressHUDStyleActivityIndicatorColor:(UIColor *)activityIndicatorColor; ///< 菊花颜色
+ (void)jx_progressHUDStyleResetToDefault; ///< 重置

// ProgresssHUD
- (void)jx_showProgressHUD:(NSString *)title;
- (void)jx_showProgressHUD:(NSString *)title animation:(BOOL)animation;
- (void)jx_hideProgressHUD:(BOOL)animation;
- (BOOL)jx_progressHUDShowing; ///< 当前页面是否正在显示 ProgresssHUD

//
- (JXCircleProgressHUDView *)jx_circleProgressHUD;


@end










