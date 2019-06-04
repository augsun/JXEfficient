//
//  UIView+JXToastAndProgressHUD.m
//  JXEfficient
//
//  Created by augsun on 6/12/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import "UIView+JXToastAndProgressHUD.h"
#import "JXMacro.h"
#import "JXInline.h"

static const CGFloat kToastViewShowAnimTime = .15f;
static const CGFloat kToastViewHideAnimTime = .35f;
static const CGFloat kToastViewStayDuration = 1.6f;

static const CGFloat kToastViewMinW = 100.f;

static const CGFloat kToastViewEdgeT = 20.f;
static const CGFloat kToastViewEdgeL = 20.f;
static const CGFloat kToastViewEdgeB = 20.f;
static const CGFloat kToastViewEdgeR = 20.f;

static const CGFloat kToastLabelEdgeT = 12.f;
static const CGFloat kToastLabelEdgeL = 12.f;
static const CGFloat kToastLabelEdgeB = 12.f;
static const CGFloat kToastLabelEdgeR = 12.f;

//
static UIColor *kToastBgColor = nil;
static UIColor *kToastTextColor = nil;

static UIColor *kProgressHUDBgColor = nil;
static UIColor *kProgressHUDTextColor = nil;
static UIColor *kProgressHUDActivityIndicatorColor = nil;

// ====================================================================================================
#pragma mark - JX_Toast_View

@interface JX_Toast_View : UIView

+ (void)resetStyle;

@property (nonatomic, copy) NSString *toast;

@end

@implementation JX_Toast_View

+ (void)initialize {
    if (!kToastBgColor) {
        kToastBgColor = JX_COLOR_RGBA(0, 0, 0, .6f);
    }
    if (!kToastTextColor) {
        kToastTextColor = [UIColor whiteColor];
    }
}

+ (void)resetStyle {
    kToastBgColor = JX_COLOR_RGBA(0, 0, 0, .6f);
    kToastTextColor = [UIColor whiteColor];
}

@end

// ====================================================================================================
#pragma mark - JX_ProgressHUD_View

@interface JX_ProgressHUD_View : UIView

+ (void)resetStyle;

@end

@implementation JX_ProgressHUD_View

+ (void)initialize {
    if (!kProgressHUDBgColor) {
        kProgressHUDBgColor = JX_COLOR_RGBA(0, 0, 0, .6f);
    }
    if (!kProgressHUDTextColor) {
        kProgressHUDTextColor = [UIColor whiteColor];
    }
    if (!kProgressHUDActivityIndicatorColor) {
        kProgressHUDActivityIndicatorColor = [UIColor whiteColor];
    }
}

+ (void)resetStyle {
    kProgressHUDBgColor = JX_COLOR_RGBA(0, 0, 0, .6f);
    kProgressHUDTextColor = [UIColor whiteColor];
    kProgressHUDActivityIndicatorColor = [UIColor whiteColor];
}

@end

// ====================================================================================================
#pragma mark - UIView (JXToastAndProgressHUD)

@implementation UIView (JXToastAndProgressHUD)

+ (void)jx_toastStyleBgColor:(UIColor *)bgColor {
    kToastBgColor = bgColor;
}

+ (void)jx_toastStyleTextColor:(UIColor *)textColor {
    kToastTextColor = textColor;
}

+ (void)jx_toastStyleResetToDefault {
    [JX_Toast_View resetStyle];
}

+ (void)jx_progressHUDStyleBgColor:(UIColor *)bgColor {
    kProgressHUDBgColor = bgColor;
}

+ (void)jx_progressHUDStyleTextColor:(UIColor *)textColor {
    kProgressHUDTextColor = textColor;
}

+ (void)jx_progressHUDStyleActivityIndicatorColor:(UIColor *)activityIndicatorColor {
    kProgressHUDActivityIndicatorColor = activityIndicatorColor;
}

+ (void)jx_progressHUDStyleResetToDefault {
    [JX_ProgressHUD_View resetStyle];
}

#pragma mark 消息弹窗提示
// toast 提示
- (void)jx_showToast:(NSString *)toast animated:(BOOL)animated {
    [self showToast:toast animated:animated inCenter:YES yOffset:0 complete:nil];
}

- (void)jx_showToast:(NSString *)toast animated:(BOOL)animated complete:(void (^)(void))complete {
    [self showToast:toast animated:animated inCenter:YES yOffset:0 complete:complete];
}

- (void)jx_showToast:(NSString *)toast animated:(BOOL)animated yOffset:(CGFloat)yOffset {
    [self showToast:toast animated:animated inCenter:NO yOffset:yOffset complete:nil];
}

- (void)jx_showToast:(NSString *)toast animated:(BOOL)animated yOffset:(CGFloat)yOffset complete:(void (^)(void))complete {
    [self showToast:toast animated:animated inCenter:NO yOffset:yOffset complete:complete];
}

- (void)showToast:(NSString *)toast
         animated:(BOOL)animated
         inCenter:(BOOL)inCenter
          yOffset:(CGFloat)yOffset
         complete:(void (^)(void))complete
{
    //
    toast = jx_strValue(toast);
    if (toast.length == 0) {
        return;
    }
    
    //
    NSString *toast_found = [self jx_toastInSelf];
    NSString *toast_now = jx_strValue(toast);
    if (toast_found && [toast_found isEqualToString:toast] ) {
        return;
    }
    
    //
    [self hideToastImmediately];
    
    //
    JX_Toast_View *toastView = [[JX_Toast_View alloc] init];
    [self addSubview:toastView];
    toastView.backgroundColor = kToastBgColor;
    toastView.translatesAutoresizingMaskIntoConstraints = NO;
    toastView.layer.cornerRadius = 6.f;
    toastView.clipsToBounds = YES;
    toastView.toast = toast_now;
    
    //
    UILabel *toastLabel = [[UILabel alloc] init];
    [toastView addSubview:toastLabel];
    toastLabel.translatesAutoresizingMaskIntoConstraints = NO;
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.font = [UIFont systemFontOfSize:14.f];
    toastLabel.textColor = kToastTextColor;
    toastLabel.numberOfLines = 0;
    toastLabel.text = toast;
    
    //
    if (inCenter) {
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:toastView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.f
                                                             constant:0.f],
                               [NSLayoutConstraint constraintWithItem:toastView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.f
                                                             constant:kToastViewEdgeT],
                               ]
         ];
    }
    else {
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:toastView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.f
                                                             constant:yOffset],
                               ]
         ];
    }
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:toastView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f
                                                         constant:0.f],
                           
                           [NSLayoutConstraint constraintWithItem:toastView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.f
                                                         constant:kToastViewEdgeL],
                           [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:toastView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:kToastViewEdgeB],
                           [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:toastView
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:kToastViewEdgeR],
                           ]
     ];

    [toastView addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:toastLabel
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:toastView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.f
                                                              constant:kToastLabelEdgeT],
                                [NSLayoutConstraint constraintWithItem:toastLabel
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:toastView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.f
                                                              constant:kToastLabelEdgeL],
                                [NSLayoutConstraint constraintWithItem:toastView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:toastLabel
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.f
                                                              constant:kToastLabelEdgeB],
                                [NSLayoutConstraint constraintWithItem:toastView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:toastLabel
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.f
                                                              constant:kToastLabelEdgeR],
                                ]
     ];

    [toastLabel addConstraints:@[
                                 [NSLayoutConstraint constraintWithItem:toastLabel
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.f
                                                               constant:kToastViewMinW - kToastLabelEdgeL - kToastLabelEdgeR],
                                 ]
     ];
    
    //
    if (animated) {
        toastView.alpha = 0.f;
        [UIView animateWithDuration:kToastViewShowAnimTime animations:^{
            toastView.alpha = 1.f;
        } completion:^(BOOL finished) {
            [self hideToastView:toastView complete:complete];
        }];
    }
    else {
        [self hideToastView:toastView complete:complete];
    }
}

- (void)hideToastView:(JX_Toast_View *)toastView complete:(void (^)(void))complete {
    [UIView animateWithDuration:kToastViewHideAnimTime delay:kToastViewStayDuration options:UIViewAnimationOptionTransitionNone animations:^{
        toastView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [toastView removeFromSuperview];
        !complete ? : complete();
    }];
}

- (void)hideToastImmediately {
    for (UIView *viewEnum in self.subviews) {
        if ([viewEnum isKindOfClass:[JX_Toast_View class]]) { [viewEnum removeFromSuperview]; }
    }
}

- (BOOL)jx_toastShowing {
    BOOL ret = NO;
    for (UIView *viewEnum in self.subviews) {
        if ([viewEnum isKindOfClass:[JX_Toast_View class]]) {
            ret = YES;
            break;
        }
    }
    return ret;
}

- (NSString *)jx_toastInSelf {
    NSString *toast = nil;
    for (UIView *viewEnum in self.subviews) {
        if ([viewEnum isKindOfClass:[JX_Toast_View class]]) {
            JX_Toast_View *toastView = (JX_Toast_View *)viewEnum;
            toast = toastView.toast;
            break;
        }
    }
    return toast;
}

#pragma mark progresssHUD
- (void)jx_showProgressHUD:(NSString *)title {
    [self jx_showProgressHUD:title animation:NO];
}

- (void)jx_showProgressHUD:(NSString *)title animation:(BOOL)animation {
    CGFloat indicatorViewToTop = 20.f;
    CGFloat viewBgMinToTB = 20.f;
    CGFloat viewBgMinToLR = 20.f;
    CGFloat viewBgMinW = 80.f;
    CGFloat titleToLR = 20.f;
    CGFloat titleToB = 20.f;
    CGFloat titleToTop = 61.f;
    
    JX_ProgressHUD_View *progressHUDView = [[JX_ProgressHUD_View alloc] init];
    [self addSubview:progressHUDView];
    progressHUDView.backgroundColor = kProgressHUDBgColor;
    progressHUDView.translatesAutoresizingMaskIntoConstraints = NO;
    progressHUDView.layer.cornerRadius = 6.f;
    progressHUDView.clipsToBounds = YES;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicatorView.color = kProgressHUDActivityIndicatorColor;
    indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [progressHUDView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    UILabel *msgLabel = [[UILabel alloc] init];
    [progressHUDView addSubview:msgLabel];
    msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = [UIFont systemFontOfSize:14.f];
    msgLabel.textColor = kProgressHUDTextColor;
    msgLabel.numberOfLines = 0;
    msgLabel.text = title;
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:progressHUDView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:progressHUDView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:progressHUDView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:viewBgMinToTB],
                           [NSLayoutConstraint constraintWithItem:progressHUDView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.f
                                                         constant:viewBgMinToLR],
                           [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:progressHUDView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:viewBgMinToTB],
                           [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:progressHUDView
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:viewBgMinToLR],
                           ]
     ];
    
    //
    [progressHUDView addConstraints:@[
                                      [NSLayoutConstraint constraintWithItem:msgLabel
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:progressHUDView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.f
                                                                    constant:titleToTop],
                                      [NSLayoutConstraint constraintWithItem:msgLabel
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:progressHUDView
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.f
                                                                    constant:titleToLR],
                                      [NSLayoutConstraint constraintWithItem:progressHUDView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:msgLabel
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.f
                                                                    constant:titleToLR],
                                      [NSLayoutConstraint constraintWithItem:progressHUDView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:msgLabel
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.f
                                                                    constant:titleToB],
                                      [NSLayoutConstraint constraintWithItem:indicatorView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:progressHUDView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.f
                                                                    constant:indicatorViewToTop],
                                      [NSLayoutConstraint constraintWithItem:indicatorView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:progressHUDView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.f
                                                                    constant:0],
                                      ]
     ];
    
    [msgLabel addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:msgLabel
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.f
                                                             constant:viewBgMinW - 2 * titleToLR],
                               ]
     ];
    
    if (animation) {
        progressHUDView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        progressHUDView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:.25f animations:^{
            progressHUDView.transform = CGAffineTransformMakeScale(1.f, 1.f);
            progressHUDView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
        } completion:nil];
    }
}

- (void)jx_hideProgressHUD:(BOOL)animation {
    for (UIView *viewEnum in self.subviews) {
        if ([viewEnum isKindOfClass:[JX_ProgressHUD_View class]]) {
            if (animation) {
                [UIView animateWithDuration:.3f animations:^{
                    viewEnum.transform = CGAffineTransformMakeScale(.5f, .5f);
                    viewEnum.alpha = 0.f;
                } completion:^(BOOL finished) {
                    [viewEnum removeFromSuperview];
                }];
            }
            else {
                [viewEnum removeFromSuperview];
            }
        }
    }
}

- (BOOL)jx_progressHUDShowing {
    BOOL showing = NO;
    for (UIView *viewEnum in self.subviews) {
        if ([viewEnum isKindOfClass:[JX_ProgressHUD_View class]]) {
            showing = YES;
            break;
        }
    }
    return showing;
}

@end










