//
//  JXPopupView.m
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import "JXPopupView.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

static const CGFloat k_popupBgViewToT_min = 40.0;
static const CGFloat k_popupBgViewToLR = 20.0;
static const CGFloat k_popupBgViewToB_min = 60.0;

static const CGFloat k_popupBgViewContentEdgeT = 8.0;
static const CGFloat k_popupBgViewContentEdgeB = 8.0;

static const CGFloat k_titleViewToAboveWidget = 8.0;
static const UIEdgeInsets k_titleViewEdgeInsets = {0.0, 8.0, 0.0, 8.0};

static const CGFloat k_contentViewToAboveWidget = 8.0;
static const UIEdgeInsets k_contentViewEdgeInsets = {15.0, 15.0, 20.0, 15.0};

static const CGFloat k_buttonsViewToAboveWidget = 8.0;
static const UIEdgeInsets k_buttonsViewEdgeInsets = {0.0, 0.0, 0.0, 0.0};

@interface JXPopupView ()

@property (nonatomic, assign) CGFloat contentContainerViewH; ///< 内容容器高度

//
@property (nonatomic, readonly) UIView *titleBgView;
@property (nonatomic, readonly) UIView *contentBgView;
@property (nonatomic, readonly) UIScrollView *contentScrollView;
@property (nonatomic, readonly) UIView *buttonsBgView;

//
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *popupBgView_cons;

@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *titleBgView_cons;
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *titleView_cons;

@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *contentBgView_cons;
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *contentScrollView_cons;
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *contentView_cons;

@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *buttonsBgView_cons;
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *buttonsView_cons;

@end

@implementation JXPopupView

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self JXPopupView_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self JXPopupView_moreInit];
    }
    return self;
}

- (void)JXPopupView_moreInit {
    // popupBgView
    _popupBgView = [[UIView alloc] init];
    [self addSubview:self.popupBgView];
    self.popupBgView.backgroundColor = [UIColor whiteColor];
    self.popupBgView.backgroundColor = JX_COLOR_RANDOM;
    self.popupBgView.alpha = 0.0;
    self.popupBgView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.popupBgView.translatesAutoresizingMaskIntoConstraints = NO;

    // titleBgView
    _titleBgView = [[UIView alloc] init];
    [self.popupBgView addSubview:self.titleBgView];
    self.titleBgView.backgroundColor = JX_COLOR_RANDOM;
    self.titleBgView.translatesAutoresizingMaskIntoConstraints = NO;
    {
        _titleView = [[UIView alloc] init];
        [self.titleBgView addSubview:self.titleView];
        self.titleView.backgroundColor = [UIColor whiteColor];
        self.titleView.backgroundColor = JX_COLOR_RANDOM;
        self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    }

    // contentBgView
    _contentBgView = [[UIView alloc] init];
    [self.popupBgView addSubview:self.contentBgView];
    self.contentBgView.backgroundColor = JX_COLOR_RANDOM;
    self.contentBgView.translatesAutoresizingMaskIntoConstraints = NO;
    {
        _contentScrollView = [[UIScrollView alloc] init];
        [self.contentBgView addSubview:self.contentScrollView];
        self.contentScrollView.backgroundColor = JX_COLOR_RANDOM;
        self.contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        {
            _contentView = [[UIView alloc] init];
            [self.contentScrollView addSubview:self.contentView];
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.contentView.backgroundColor = JX_COLOR_RANDOM;
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        }
    }

    //
    _buttonsBgView = [[UIView alloc] init];
    [self.popupBgView addSubview:self.buttonsBgView];
    self.buttonsBgView.backgroundColor = JX_COLOR_RANDOM;
    self.buttonsBgView.translatesAutoresizingMaskIntoConstraints = NO;
    {
        _buttonsView = [[UIView alloc] init];
        [self.buttonsBgView addSubview:self.buttonsView];
        self.buttonsView.backgroundColor = [UIColor whiteColor];
        self.buttonsView.backgroundColor = JX_COLOR_RANDOM;
        self.buttonsView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    //
    self.popupBgViewToT_min = k_popupBgViewToT_min;
    self.popupBgViewToLR = k_popupBgViewToLR;
    self.popupBgViewToB_min = k_popupBgViewToB_min;
    
    self.popupBgViewContentEdgeT = k_popupBgViewContentEdgeT;
    self.popupBgViewContentEdgeB = k_popupBgViewContentEdgeB;

    self.titleViewToAboveWidget = k_titleViewToAboveWidget;
    self.titleViewEdgeInsets = k_titleViewEdgeInsets;

    self.contentViewToAboveWidget = k_contentViewToAboveWidget;
    self.contentViewEdgeInsets = k_contentViewEdgeInsets;

    self.buttonsViewToAboveWidget = k_buttonsViewToAboveWidget;
    self.buttonsViewEdgeInsets = k_buttonsViewEdgeInsets;

}

#pragma mark - setter

#pragma mark - show

- (void)show {
    [self JXPopupView_prepareForShow];

    [self show:self.animation change:^{
        self.popupBgView.alpha = 1.0;
        self.popupBgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^{
        
    }];
}

- (void)refreshAnimated:(BOOL)animated {
    [self JXPopupView_prepareForShow];
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)hide {
    [self hide:self.animation change:^{
        self.popupBgView.alpha = 0.f;
        self.popupBgView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^{
        
    }];
}

- (void)JXPopupView_prepareForShow {
    BOOL titleShow = self.titleViewContentH > 0.0;
    BOOL contentShow = self.contentViewContentH > 0.0;
    BOOL buttonsShow = self.buttonsViewContentH > 0.0;
    
    if (!titleShow && !contentShow && !buttonsShow) {
        JX_WEAK_SELF;
        self.popupBgView.hidden = YES;
        self.backgroundTap = ^{
            JX_STRONG_SELF;
            [self hide];
        };
        return;
    }
    else {
        self.popupBgView.hidden = NO;
    }
    
    // popupBgView
    CGFloat h_popupBgView_expect = 0.0;
    NSLayoutConstraint *con_popupBgView_h = [self.popupBgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:h_popupBgView_expect];
    NSLayoutConstraint *con_contentBgView_h = nil;
    NSMutableArray <NSLayoutConstraint *> *popupBgView_cons = [[NSMutableArray alloc] init];
    
    switch (self.closeTo) {
        case JXPopupViewCloseToTop:
        {
            [popupBgView_cons addObjectsFromArray:@[
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:self.popupBgViewToT_min],
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:self.popupBgViewToLR],
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:-self.popupBgViewToLR],
                                                    con_popupBgView_h,
                                                    ]];
        } break;
            
        case JXPopupViewCloseToBottom:
        {
            [popupBgView_cons addObjectsFromArray:@[
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:self.popupBgViewToLR],
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:-self.popupBgViewToB_min],
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:-self.popupBgViewToLR],
                                                    con_popupBgView_h,
                                                    ]];
        } break;
            
        default:
        {
            NSLayoutConstraint *con_popupBgView_Y = [self.popupBgView jx_con_same:NSLayoutAttributeCenterY equal:self m:1.0 c:0.0];
            con_popupBgView_Y.priority = UILayoutPriorityDefaultLow;
            [popupBgView_cons addObjectsFromArray:@[
                                                    con_popupBgView_Y,
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeTop greaterEqual:self m:1.0 c:self.popupBgViewToT_min],
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:self.popupBgViewToLR],
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeBottom lessEqual:self m:1.0 c:-self.popupBgViewToB_min],
                                                    [self.popupBgView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:-self.popupBgViewToLR],
                                                    con_popupBgView_h,
                                                    ]];
        } break;
    }
    
    if (self.popupBgView_cons.count > 0) {
        [NSLayoutConstraint deactivateConstraints:self.popupBgView_cons];
    }
    self.popupBgView_cons = popupBgView_cons;
    [NSLayoutConstraint activateConstraints:self.popupBgView_cons];
    
    // titleBgView
    CGFloat titleBgView_h = 0.0;
    if (titleShow) {
        {
            titleBgView_h = self.titleViewContentH + self.titleViewEdgeInsets.top + self.titleViewEdgeInsets.bottom;
            h_popupBgView_expect += self.popupBgViewContentEdgeT + titleBgView_h;
            NSArray <NSLayoutConstraint *> *cons = @[
                                                     [self.titleBgView jx_con_same:NSLayoutAttributeTop equal:self.popupBgView m:1.0 c:self.popupBgViewContentEdgeT],
                                                     [self.titleBgView jx_con_same:NSLayoutAttributeLeft equal:self.popupBgView m:1.0 c:0.0],
                                                     [self.titleBgView jx_con_same:NSLayoutAttributeRight equal:self.popupBgView m:1.0 c:0.0],
                                                     [self.titleBgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:titleBgView_h],
                                                     ];
            if (self.titleBgView_cons.count > 0) {
                [NSLayoutConstraint deactivateConstraints:self.titleBgView_cons];
            }
            self.titleBgView_cons = cons;
            [NSLayoutConstraint activateConstraints:self.titleBgView_cons];
        }
        {
            NSArray <NSLayoutConstraint *> *cons = @[
                                                     [self.titleView jx_con_same:NSLayoutAttributeTop equal:self.titleBgView m:1.0 c:self.titleViewEdgeInsets.top],
                                                     [self.titleView jx_con_same:NSLayoutAttributeLeft equal:self.titleBgView m:1.0 c:self.titleViewEdgeInsets.left],
                                                     [self.titleView jx_con_same:NSLayoutAttributeBottom equal:self.titleBgView m:1.0 c:-self.titleViewEdgeInsets.bottom],
                                                     [self.titleView jx_con_same:NSLayoutAttributeRight equal:self.titleBgView m:1.0 c:-self.titleViewEdgeInsets.right],
                                                     ];
            if (self.titleView_cons.count > 0) {
                [NSLayoutConstraint deactivateConstraints:self.titleView_cons];
            }
            self.titleView_cons = cons;
            [NSLayoutConstraint activateConstraints:self.titleView_cons];
        }
    }
    
    // contentBgView
    CGFloat contentBgView_h = 0.0;
    if (contentShow) {
        // contentBgView
        {
            CGFloat top_constant = 0.0;
            NSLayoutConstraint *att_T = nil;
            if (titleShow) {
                top_constant = self.contentViewToAboveWidget;
                att_T = [self.contentBgView jx_con_diff:NSLayoutAttributeTop equal:self.titleBgView att2:NSLayoutAttributeBottom m:1.0 c:top_constant];
            }
            else {
                top_constant = self.popupBgViewContentEdgeT;
                att_T = [self.contentBgView jx_con_same:NSLayoutAttributeTop equal:self.popupBgView m:1.0 c:top_constant];
            }
            
            contentBgView_h = self.contentViewContentH + self.contentViewEdgeInsets.top + self.contentViewEdgeInsets.bottom;
            h_popupBgView_expect += top_constant + contentBgView_h;
            
            con_contentBgView_h = [self.contentBgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:contentBgView_h];
            
            NSArray <NSLayoutConstraint *> *cons = @[
                                                     att_T,
                                                     [self.contentBgView jx_con_same:NSLayoutAttributeLeft equal:self.popupBgView m:1.0 c:0.0],
                                                     [self.contentBgView jx_con_same:NSLayoutAttributeRight equal:self.popupBgView m:1.0 c:0.0],
                                                     con_contentBgView_h,
                                                     ];
            if (self.contentBgView_cons.count > 0) {
                [NSLayoutConstraint deactivateConstraints:self.contentBgView_cons];
            }
            self.contentBgView_cons = cons;
            [NSLayoutConstraint activateConstraints:self.contentBgView_cons];
        }
        
        // contentScrollView
        {
            NSArray <NSLayoutConstraint *> *cons = [self.contentScrollView jx_con_edgeEqual:self.contentBgView];
            if (self.contentScrollView_cons.count > 0) {
                [NSLayoutConstraint deactivateConstraints:self.contentScrollView_cons];
            }
            self.contentScrollView_cons = cons;
            [NSLayoutConstraint activateConstraints:self.contentScrollView_cons];
        }
        
        // contentView
        {
            NSArray <NSLayoutConstraint *> *cons = @[
                                                     [self.contentView jx_con_same:NSLayoutAttributeTop equal:self.contentScrollView m:1.0 c:self.contentViewEdgeInsets.top],
                                                     [self.contentView jx_con_same:NSLayoutAttributeLeft equal:self.contentScrollView m:1.0 c:self.contentViewEdgeInsets.left],
                                                     [self.contentView jx_con_same:NSLayoutAttributeBottom equal:self.contentScrollView m:1.0 c:-self.contentViewEdgeInsets.bottom],
                                                     [self.contentView jx_con_same:NSLayoutAttributeRight equal:self.contentScrollView m:1.0 c:-self.contentViewEdgeInsets.right],
                                                     [self.contentView jx_con_same:NSLayoutAttributeCenterX equal:self.contentScrollView m:1.0 c:0.0],
                                                     [self.contentView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:self.contentViewContentH],
                                                     ];
            if (self.contentView_cons.count > 0) {
                [NSLayoutConstraint deactivateConstraints:self.contentView_cons];
            }
            self.contentView_cons = cons;
            [NSLayoutConstraint activateConstraints:self.contentView_cons];
        }
    }

    // buttonsBgView
    CGFloat buttonsBgView_h = 0.0;
    if (buttonsShow) {
        {
            CGFloat top_constant = 0.0;
            NSLayoutConstraint *att_T = nil;
            if (titleShow || contentShow) {
                top_constant = self.buttonsViewToAboveWidget;
                UIView *aboveWidgetView = contentShow ? self.contentBgView : self.titleBgView;
                att_T = [self.buttonsBgView jx_con_diff:NSLayoutAttributeTop equal:aboveWidgetView att2:NSLayoutAttributeBottom m:1.0 c:top_constant];
            }
            else {
                top_constant = self.popupBgViewContentEdgeT;
                att_T = [self.buttonsBgView jx_con_same:NSLayoutAttributeTop equal:self.popupBgView m:1.0 c:top_constant];
            }
            buttonsBgView_h = self.buttonsViewContentH + self.buttonsViewEdgeInsets.top + self.buttonsViewEdgeInsets.bottom;
            h_popupBgView_expect +=  top_constant + buttonsBgView_h;
            NSArray <NSLayoutConstraint *> *cons = @[
                                                     att_T,
                                                     [self.buttonsBgView jx_con_same:NSLayoutAttributeLeft equal:self.popupBgView m:1.0 c:0.0],
                                                     [self.buttonsBgView jx_con_same:NSLayoutAttributeRight equal:self.popupBgView m:1.0 c:0.0],
                                                     [self.buttonsBgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:buttonsBgView_h],
                                                     ];
            if (self.buttonsBgView_cons.count > 0) {
                [NSLayoutConstraint deactivateConstraints:self.buttonsBgView_cons];
            }
            self.buttonsBgView_cons = cons;
            [NSLayoutConstraint activateConstraints:self.buttonsBgView_cons];
        }
        {
            NSArray <NSLayoutConstraint *> *cons = @[
                                                     [self.buttonsView jx_con_same:NSLayoutAttributeTop equal:self.buttonsBgView m:1.0 c:self.buttonsViewEdgeInsets.top],
                                                     [self.buttonsView jx_con_same:NSLayoutAttributeLeft equal:self.buttonsBgView m:1.0 c:self.buttonsViewEdgeInsets.left],
                                                     [self.buttonsView jx_con_same:NSLayoutAttributeBottom equal:self.buttonsBgView m:1.0 c:-self.buttonsViewEdgeInsets.bottom],
                                                     [self.buttonsView jx_con_same:NSLayoutAttributeRight equal:self.buttonsBgView m:1.0 c:-self.buttonsViewEdgeInsets.right],
                                                     ];
            if (self.buttonsView_cons.count > 0) {
                [NSLayoutConstraint deactivateConstraints:self.buttonsView_cons];
            }
            self.buttonsView_cons = cons;
            [NSLayoutConstraint activateConstraints:self.buttonsView_cons];
        }
    }
    
    h_popupBgView_expect += self.popupBgViewContentEdgeB;
    
    // contentShow 时, 是否需要对 contentBgView 进行压缩.
    CGFloat h_popupBgView_max = JX_SCREEN_H - self.popupBgViewToT_min - self.popupBgViewToB_min; // 最大高度
    if (contentShow) {
        if (h_popupBgView_expect > h_popupBgView_max) {
            CGFloat diff = h_popupBgView_expect - h_popupBgView_max;
            contentBgView_h -= diff;
            con_contentBgView_h.constant = contentBgView_h;
            con_popupBgView_h.constant = h_popupBgView_expect - diff;
        }
        else {
            con_popupBgView_h.constant = h_popupBgView_expect;
        }
    }
    else {
        CGFloat h_popupBgView = h_popupBgView_expect > h_popupBgView_max ? h_popupBgView_max : h_popupBgView_expect;
        con_popupBgView_h.constant = h_popupBgView;
    }
}

@end
