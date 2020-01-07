//
//  JXNaviView.m
//  JXEfficient
//
//  Created by augsun on 8/28/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import "JXNaviView.h"
#import "JXMacro.h"
#import "JXInline.h"

static UIImage *JXNaviView_white_img_ = nil;
static UIImage *JXNaviView_black_img_ = nil;

static UIImage *kNormalImage_ = nil;
static UIImage *kHighlightedImage_ = nil;
static UIImage *kDisabledImage_ = nil;

static UIImage *kNormalImage_bgColorStyle_ = nil;
static UIImage *kHighlightedImage_bgColorStyle_ = nil;
static UIImage *kDisabledImage_bgColorStyle_ = nil;

@interface JXNaviView ()

@property (nonatomic, strong) JXNavigationBarItem *back_item;

@property (nonatomic, strong) JXNavigationBarItem *title_item;

@property (nonatomic, strong) JXNavigationBarItem *left_item;
@property (nonatomic, strong) JXNavigationBarItem *right_item;
@property (nonatomic, strong) JXNavigationBarItem *subRight_item;

@property (nonatomic, assign) BOOL left_is_title;
@property (nonatomic, assign) BOOL right_is_title;
@property (nonatomic, assign) BOOL subRight_is_title;

@end

@implementation JXNaviView

+ (void)initialize {
    kNormalImage_ = [self jx_drawRightAngleArrow:JX_COLOR_HEX(JXNavigationBarItemNormalTitleColorDefault)];
    kHighlightedImage_ = [self jx_drawRightAngleArrow:JX_COLOR_HEX(JXNavigationBarItemHighlightedColorDefault)];
    kDisabledImage_ = [self jx_drawRightAngleArrow:JX_COLOR_HEX(JXNavigationBarItemDisabledColorDefault)];
    
    kNormalImage_bgColorStyle_ = [self jx_drawRightAngleArrow:[UIColor whiteColor]];
    kHighlightedImage_bgColorStyle_ = [self jx_drawRightAngleArrow:[UIColor whiteColor]];
    kDisabledImage_bgColorStyle_ = [self jx_drawRightAngleArrow:[UIColor whiteColor]];
}

/**
 绘制用于返回按钮的 直角箭头.
 
 @param color 箭头颜色
 @return 箭头图片
 */
+ (UIImage *)jx_drawRightAngleArrow:(UIColor *)color {
    CGFloat path_w = 1.5; // 线宽
    CGFloat path_r = path_w / 2.0; // 线 半径(半宽)
    
    CGFloat w = 10.5; // 布局边缘实际宽度
    CGFloat edge = 2.0; // 4边的边缘向外扩展宽度
    CGPoint a1 = CGPointMake(w - path_r, path_r); // 右上角 起点
    CGFloat a2_y = w - sqrt(2.0) * path_r;
    CGPoint a2 = CGPointMake(sqrt(2.0) * path_r, a2_y); // 左边拐点
    CGPoint a3 = CGPointMake(w - path_r, 2 * a2_y); // 右下角 终点
    
    CGPoint (^add_offset)(CGPoint) = ^ CGPoint (CGPoint point) { // 进行边缘扩展
        return CGPointMake(point.x + edge, point.y + edge);
    };
    a1 = add_offset(a1);
    a2 = add_offset(a2);
    a3 = add_offset(a3);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:a1];
    [path addLineToPoint:a2];
    [path addLineToPoint:a3];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = path_w;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    CGRect rect = CGRectMake(0, 0, w + 2 * edge, 2 * a2_y + 2 * edge); // 边缘扩展后的图片大小
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view.layer addSublayer:shapeLayer];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)naviView {
    JXNaviView *view = [[JXNaviView alloc] init];
    return view;
}

- (instancetype)init {
    self = [super init]; if (self) { [self JXNaviView_moreInit]; }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder]; if (self) { [self JXNaviView_moreInit]; }
    return self;
}

- (void)JXNaviView_moreInit {
    UIEdgeInsets insets = self.backItem.contentEdgeInsets;
    self.backItem.contentEdgeInsets = UIEdgeInsetsMake(insets.top, 11.0, insets.bottom, 24.0);
    [self JXNaviView_setBackClick];
    
    [self checkAndSet_back];
}

- (void)JXNaviView_setBackClick {
    self.back_item = self.backItem;
    JX_WEAK_SELF;
    self.backItem.click = ^{
        JX_STRONG_SELF;
        JX_BLOCK_EXEC(self.backClick);
    };
}

- (void)checkAndSet_back {
    if (!self.back_item) {
        return;
    }
    if (self.bgColorStyle) {
        [self.backItem setImageForNormal:kNormalImage_bgColorStyle_ highlighted:kHighlightedImage_bgColorStyle_ disabled:kDisabledImage_bgColorStyle_];
    }
    else {
        [self.backItem setImageForNormal:kNormalImage_ highlighted:kHighlightedImage_ disabled:kDisabledImage_];
    }
}

- (void)setBgColorStyle:(BOOL)bgColorStyle {
    _bgColorStyle = bgColorStyle;
    
    [self checkAndSet_back];
    [self checkAndSet_title];
    [self checkAndSet_left];
    [self checkAndSet_right];
    [self checkAndSet_subRight];
}

- (void)setBackButtonHidden:(BOOL)backButtonHidden {
    _backButtonHidden = backButtonHidden;
    self.backItem.hidden = backButtonHidden;
}

#pragma mark title

- (void)setTitle:(NSString *)title {
    title = jx_strValue(title);
    if (title.length > 0) {
        _title = title;
        self.title_item = self.titleItem;
        
        [self checkAndSet_title];
    }
}

- (void)checkAndSet_title {
    if (!self.title_item) {
        return;
    }
    if (self.bgColorStyle) {
        self.titleItem.title = self.title;
        self.titleItem.color = [UIColor whiteColor];
    }
    else {
        self.titleItem.title = self.title;
        self.titleItem.color = nil;
    }
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLineView.hidden = bottomLineHidden;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    self.bottomLineView.backgroundColor = bottomLineColor;
}

#pragma mark left

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle {
    _leftButtonTitle = leftButtonTitle;
    [self jx_setLeftClick];
    
    self.left_is_title = YES;
    [self checkAndSet_left];
}

- (void)setLeftButtonImage:(UIImage *)leftButtonImage {
    _leftButtonImage = leftButtonImage;
    [self jx_setLeftClick];

    [self.leftItem setImageForNormal:leftButtonImage highlighted:leftButtonImage disabled:leftButtonImage];
    
    self.left_is_title = NO;
    [self checkAndSet_left];
}

- (void)jx_setLeftClick {
    self.left_item = self.leftItem;
    JX_WEAK_SELF;
    self.leftItem.click = ^{
        JX_STRONG_SELF;
        JX_BLOCK_EXEC(self.leftButtonTap);
    };
}

- (void)checkAndSet_left {
    if (!self.left_item) {
        return;
    }
    if (self.left_is_title) {
        if (self.bgColorStyle) {
            self.leftItem.title = self.leftButtonTitle;
            self.leftItem.color = [UIColor whiteColor];
        }
        else {
            self.leftItem.title = self.leftButtonTitle;
            self.leftItem.color = nil;
        }
    }
}

- (void)setLeftButtonHidden:(BOOL)leftButtonHidden {
    _leftButtonHidden = leftButtonHidden;
    self.leftItem.hidden = leftButtonHidden;
}

#pragma mark right

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    _rightButtonTitle = rightButtonTitle;
    [self jx_setRightClick];
    
    self.right_is_title = YES;
    [self checkAndSet_right];
}

- (void)setRightButtonImage:(UIImage *)rightButtonImage {
    _rightButtonImage = rightButtonImage;
    [self jx_setRightClick];

    [self.rightItem setImageForNormal:rightButtonImage highlighted:rightButtonImage disabled:rightButtonImage];
    
    self.right_is_title = NO;
    [self checkAndSet_right];
}

- (void)jx_setRightClick {
    self.right_item = self.rightItem;
    
    UIEdgeInsets insets = self.right_item.contentEdgeInsets;
    self.right_item.contentEdgeInsets = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom, 11.0);
    
    JX_WEAK_SELF;
    self.rightItem.click = ^{
        JX_STRONG_SELF;
        JX_BLOCK_EXEC(self.rightButtonTap);
    };
}

- (void)checkAndSet_right {
    if (!self.right_item) {
        return;
    }
    if (self.right_is_title) {
        if (self.bgColorStyle) {
            self.rightItem.title = self.rightButtonTitle;
            self.rightItem.color = [UIColor whiteColor];
        }
        else {
            self.rightItem.title = self.rightButtonTitle;
            self.rightItem.color = nil;
        }
    }
}

- (void)setRightButtonHidden:(BOOL)rightButtonHidden {
    _rightButtonHidden = rightButtonHidden;
    self.rightItem.hidden = rightButtonHidden;
}

#pragma mark subRightButtonTitle

- (void)setSubRightButtonTitle:(NSString *)subRightButtonTitle {
    _subRightButtonTitle = subRightButtonTitle;
    [self jx_setSubRightClick];
    
    self.subRight_is_title = YES;
    [self checkAndSet_subRight];
}

- (void)setSubRightButtonImage:(UIImage *)subRightButtonImage {
    _subRightButtonImage = subRightButtonImage;
    [self jx_setSubRightClick];
    
    [self.subRightItem setImageForNormal:subRightButtonImage highlighted:subRightButtonImage disabled:subRightButtonImage];
    
    self.subRight_is_title = NO;
    [self checkAndSet_subRight];
}

- (void)jx_setSubRightClick {
    self.subRight_item = self.subRightItem;
    JX_WEAK_SELF;
    self.subRightItem.click = ^{
        JX_STRONG_SELF;
        JX_BLOCK_EXEC(self.subRightButtonTap);
        JX_BLOCK_EXEC(self.rightSubButtonTap);
    };
}

- (void)checkAndSet_subRight {
    if (!self.subRight_item) {
        return;
    }
    if (self.subRight_is_title) {
        NSString *subRightButtonTitle = self.subRightButtonTitle ? self.subRightButtonTitle : self.rightSubButtonTitle;
        if (self.bgColorStyle) {
            self.subRightItem.title = subRightButtonTitle;
            self.subRightItem.color = [UIColor whiteColor];
        }
        else {
            self.subRightItem.title = subRightButtonTitle;
            self.subRightItem.color = nil;
        }
    }
}

- (void)setSubRightButtonHidden:(BOOL)subRightButtonHidden {
    _subRightButtonHidden = subRightButtonHidden;
    self.subRightItem.hidden = YES;
}

// deprecated
- (void)setRightSubButtonTitle:(NSString *)rightSubButtonTitle {
    _rightSubButtonTitle = rightSubButtonTitle;
    [self jx_setSubRightClick];
    
    self.subRight_is_title = YES;
    [self checkAndSet_subRight];
}

- (void)setRightSubButtonImage:(UIImage *)rightSubButtonImage {
    _rightSubButtonImage = rightSubButtonImage;
    [self jx_setSubRightClick];
    
    [self.subRightItem setImageForNormal:rightSubButtonImage highlighted:rightSubButtonImage disabled:rightSubButtonImage];
    
    self.subRight_is_title = NO;
    [self checkAndSet_subRight];
}

- (void)setRightSubButtonHidden:(BOOL)rightSubButtonHidden {
    _rightSubButtonHidden = rightSubButtonHidden;
    self.subRightItem.hidden = YES;
}

@end

















