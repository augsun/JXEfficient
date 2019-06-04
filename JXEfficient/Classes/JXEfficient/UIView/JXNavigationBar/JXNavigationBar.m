//
//  JXNavigationBar.m
//  JXEfficient
//
//  Created by augsun on 3/5/19.
//

#import "JXNavigationBar.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"
#import "UIView+JXCategory.h"

static const CGFloat kLeftSpacingDefault = 4.0;
static const CGFloat kRightSpacingDefault = 4.0;
static const CGFloat kInteritemDefault = 4.0;

@interface JXUINavigationBar : UINavigationBar

@end

@implementation JXUINavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *view in self.subviews) {
        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.frame = self.bounds;
            break;
        }
    }
}

@end

@interface JXNavigationBar ()

@property (nonatomic, strong) UIView *bgColorView; ///< JXNavigationBar 本身不参与颜色设置, 外部设置也会被重写为 clearColor, 而设置该属以展示颜色
@property (nonatomic, strong) JXUINavigationBar *uiNavigationBar; ///< 以获取系统原生 translucent 样式

@property (nonatomic, strong) UIView *itemsBgView; /// 放置 JXNavigationBarItem 实例

@property (nonatomic, strong) NSLayoutConstraint *con_backItem_w;
@property (nonatomic, strong) NSLayoutConstraint *con_backItem_toL;

@property (nonatomic, strong) NSLayoutConstraint *con_leftItem_w;
@property (nonatomic, strong) NSLayoutConstraint *con_leftItem_toL;

@property (nonatomic, strong) NSLayoutConstraint *con_titleItem_toL;
@property (nonatomic, strong) NSLayoutConstraint *con_titleItem_toR;
@property (nonatomic, strong) NSLayoutConstraint *con_titleItem_w;

@property (nonatomic, strong) NSLayoutConstraint *con_rightItem_w;
@property (nonatomic, strong) NSLayoutConstraint *con_rightItem_toR;

@property (nonatomic, strong) NSLayoutConstraint *con_subRightItem_w;
@property (nonatomic, strong) NSLayoutConstraint *con_subRightItem_toR;

@end

@implementation JXNavigationBar

@synthesize
backgroundImageView = _backgroundImageView,
backItem = _backItem, leftItem = _leftItem,
titleItem = _titleItem,
rightItem = _rightItem, subRightItem = _subRightItem,
bottomLineView = _bottomLineView;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self jx_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self jx_moreInit];
    }
    return self;
}

- (JXUINavigationBar *)uiNavigationBar {
    if (!_uiNavigationBar) {
        _uiNavigationBar = [[JXUINavigationBar alloc] init];
        [self addSubview:_uiNavigationBar];
        _uiNavigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[_uiNavigationBar jx_con_edgeEqual:self]];

        _uiNavigationBar.clipsToBounds = YES; // 可以隐藏系统导航条底部默认线
        [self reAddSubviews];
    }
    return _uiNavigationBar;
}

- (void)jx_moreInit {
    self.backgroundColor = [UIColor whiteColor];
    _leftSpacing = kLeftSpacingDefault;
    _rightSpacing = kRightSpacingDefault;
    _interitemSpacing = kInteritemDefault;
    
    // bgColorView
    self.bgColorView = [[UIView alloc] init];
    [self addSubview:self.bgColorView];
    self.bgColorView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[self.bgColorView jx_con_edgeEqual:self]];
    self.bgColorView.backgroundColor = [UIColor whiteColor];
    
    // itemsBgView
    self.itemsBgView = [[UIView alloc] init];
    [self addSubview:self.itemsBgView];
    self.itemsBgView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.itemsBgView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                              [self.itemsBgView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                              [self.itemsBgView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                              [self.itemsBgView jx_con_same:NSLayoutAttributeHeight equal:self m:1.0 c:44.0],
                                              ]];
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:_backgroundImageView];
        _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[_backgroundImageView jx_con_edgeEqual:self]];
        [self reAddSubviews];
    }
    return _backgroundImageView;
}

- (JXNavigationBarItem *)backItem {
    if (!_backItem) {
        JXNavigationBarItem *itemView = [self createOneItemView];
        self.con_backItem_toL = [itemView jx_con_same:NSLayoutAttributeLeft equal:self.itemsBgView m:1.0 c:0.0];
        self.con_backItem_w = [itemView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:0.0];
        self.con_backItem_w.priority = UILayoutPriorityDefaultHigh;
        [NSLayoutConstraint activateConstraints:@[
                                                  [itemView jx_con_same:NSLayoutAttributeBottom equal:self.itemsBgView m:1.0 c:0.0],
                                                  [itemView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:44.0],
                                                  self.con_backItem_toL,
                                                  self.con_backItem_w,
                                                  [itemView jx_con_same:NSLayoutAttributeWidth greaterEqual:nil m:1.0 c:20.0],
                                                  ]];
        _backItem = itemView;
    }
    return _backItem;
}

- (JXNavigationBarItem *)leftItem {
    if (!_leftItem) {
        JXNavigationBarItem *itemView = [self createOneItemView];
        self.con_leftItem_toL = [itemView jx_con_same:NSLayoutAttributeLeft equal:self.itemsBgView m:1.0 c:0.0];
        self.con_leftItem_w = [itemView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:0.0];
        self.con_leftItem_w.priority = UILayoutPriorityDefaultHigh;
        [NSLayoutConstraint activateConstraints:@[
                                                  [itemView jx_con_same:NSLayoutAttributeBottom equal:self.itemsBgView m:1.0 c:0.0],
                                                  [itemView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:44.0],
                                                  self.con_leftItem_toL,
                                                  self.con_leftItem_w,
                                                  [itemView jx_con_same:NSLayoutAttributeWidth greaterEqual:nil m:1.0 c:20.0],
                                                  ]];
        _leftItem = itemView;
    }
    return _leftItem;
}

- (JXNavigationBarItem *)titleItem {
    if (!_titleItem) {
        JXNavigationBarItem *itemView = [self createOneItemView];
        self.con_titleItem_toL = [itemView jx_con_same:NSLayoutAttributeLeft greaterEqual:self.itemsBgView m:1.0 c:0.0];
        self.con_titleItem_toR = [itemView jx_con_same:NSLayoutAttributeRight lessEqual:self.itemsBgView m:1.0 c:0.0];
        
        self.con_titleItem_w = [itemView jx_con_same:NSLayoutAttributeWidth lessEqual:nil m:1.0 c:0.0];
        self.con_titleItem_w.priority = UILayoutPriorityDefaultHigh;
        
        NSLayoutConstraint *con_titleItem_cX = [itemView jx_con_same:NSLayoutAttributeCenterX equal:self.itemsBgView m:1.0 c:0.0];
        con_titleItem_cX.priority = UILayoutPriorityDefaultLow;
        
        [NSLayoutConstraint activateConstraints:@[
                                                  con_titleItem_cX,
                                                  [itemView jx_con_same:NSLayoutAttributeBottom equal:self.itemsBgView m:1.0 c:0.0],
                                                  [itemView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:44.0],
                                                  self.con_titleItem_toL,
                                                  self.con_titleItem_toR,
                                                  self.con_titleItem_w,
                                                  [itemView jx_con_same:NSLayoutAttributeWidth greaterEqual:nil m:1.0 c:20.0],
                                                  ]];
        _titleItem = itemView;
    }
    return _titleItem;
}

- (JXNavigationBarItem *)rightItem {
    if (!_rightItem) {
        JXNavigationBarItem *itemView = [self createOneItemView];
        self.con_rightItem_toR = [itemView jx_con_same:NSLayoutAttributeRight equal:self.itemsBgView m:1.0 c:0.0];
        self.con_rightItem_w = [itemView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:0.0];
        self.con_rightItem_w.priority = UILayoutPriorityDefaultHigh;
        [NSLayoutConstraint activateConstraints:@[
                                                  [itemView jx_con_same:NSLayoutAttributeBottom equal:self.itemsBgView m:1.0 c:0.0],
                                                  [itemView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:44.0],
                                                  self.con_rightItem_toR,
                                                  self.con_rightItem_w,
                                                  [itemView jx_con_same:NSLayoutAttributeWidth greaterEqual:nil m:1.0 c:20.0],
                                                  ]];
        _rightItem = itemView;
    }
    return _rightItem;
}

- (JXNavigationBarItem *)subRightItem {
    if (!_subRightItem) {
        JXNavigationBarItem *itemView = [self createOneItemView];
        self.con_subRightItem_toR = [itemView jx_con_same:NSLayoutAttributeRight equal:self.itemsBgView m:1.0 c:0.0];
        self.con_subRightItem_w = [itemView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:0.0];
        self.con_subRightItem_w.priority = UILayoutPriorityDefaultHigh;
        [NSLayoutConstraint activateConstraints:@[
                                                  [itemView jx_con_same:NSLayoutAttributeBottom equal:self.itemsBgView m:1.0 c:0.0],
                                                  [itemView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:44.0],
                                                  self.con_subRightItem_toR,
                                                  self.con_subRightItem_w,
                                                  [itemView jx_con_same:NSLayoutAttributeWidth greaterEqual:nil m:1.0 c:20.0],
                                                  ]];
        _subRightItem = itemView;
    }
    return _subRightItem;
}

- (JXNavigationBarItem *)createOneItemView {
    JXNavigationBarItem *button = [[JXNavigationBarItem alloc] init];
    [self.itemsBgView addSubview:button];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    JX_WEAK_SELF;
    button.needLayout = ^{
        JX_STRONG_SELF;
        [self jx_layout];
    };
    
    return button;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        [self addSubview:_bottomLineView];
        _bottomLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [_bottomLineView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [_bottomLineView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                                  [_bottomLineView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [_bottomLineView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_SCREEN_ONE_PIX],
                                                  ]];
        _bottomLineView.backgroundColor = JX_COLOR_HEX(0xDEDEDE);
    }
    return _bottomLineView;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.bgColorView.backgroundColor = backgroundColor;
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    if (translucent) {
        self.uiNavigationBar.hidden = NO;
        self.bgColorView.hidden = YES;
        _backgroundImageView.hidden = YES;
    }
    else {
        _uiNavigationBar.hidden = YES;
        self.bgColorView.hidden = NO;
    }
}

- (void)setLeftSpacing:(CGFloat)leftSpacing {
    if (leftSpacing >= 0.0) { _leftSpacing = leftSpacing; [self jx_layout]; }
}

- (void)setRightSpacing:(CGFloat)rightSpacing {
    if (rightSpacing >= 0.0) { _rightSpacing = rightSpacing; [self jx_layout]; }
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    if (interitemSpacing >= 0.0) { _interitemSpacing = interitemSpacing; [self jx_layout]; }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self jx_layout];
}

- (void)jx_layout {
    if (self.jx_width == 0) {
        return;
    }
    
    CGFloat leftSpacing = self.leftSpacing;
    CGFloat rightSpacing = self.rightSpacing;
    CGFloat interitemSpacing = self.interitemSpacing;
    
    BOOL back_show = _backItem && !_backItem.hidden && _backItem.rightForShowing;
    BOOL left_show = _leftItem && !_leftItem.hidden && _leftItem.rightForShowing;
    BOOL title_show = _titleItem && !_titleItem.hidden && _titleItem.rightForShowing;
    BOOL right_show = _rightItem && !_rightItem.hidden && _rightItem.rightForShowing;
    BOOL subRight_show = _subRightItem && !_subRightItem.hidden && _subRightItem.rightForShowing;
    
    NSMutableArray <NSLayoutConstraint *> *cons_deactivate = [[NSMutableArray alloc] init];
    NSMutableArray <NSLayoutConstraint *> *cons_activate = [[NSMutableArray alloc] init];
    
    NSLayoutConstraint * (^deal_con)(NSLayoutConstraint *,
                                     NSLayoutConstraint *) = ^ NSLayoutConstraint * (NSLayoutConstraint *con_old,
                                                                                     NSLayoutConstraint *con_new)
    {
        [cons_deactivate addObject:con_old];
        [cons_activate addObject:con_new];
        return con_new;
    };
    
    if (back_show) {
        self.con_backItem_w.constant = self.backItem.itemWidth;
        self.con_backItem_toL = deal_con(self.con_backItem_toL,
                                         [self.backItem jx_con_same:NSLayoutAttributeLeft
                                                              equal:self.itemsBgView
                                                                  m:1.0
                                                                  c:leftSpacing]);
    }
    else {
        if (_backItem) {
            self.con_backItem_w.constant = 0.0;
        }
    }
    
    if (left_show) {
        self.con_leftItem_w.constant = self.leftItem.itemWidth;
        if (back_show) {
            self.con_leftItem_toL = deal_con(self.con_leftItem_toL,
                                             [self.leftItem jx_con_diff:NSLayoutAttributeLeft
                                                                  equal:self.backItem
                                                                   att2:NSLayoutAttributeRight
                                                                      m:1.0
                                                                      c:interitemSpacing]);
        }
        else {
            self.con_leftItem_toL = deal_con(self.con_leftItem_toL,
                                             [self.leftItem jx_con_same:NSLayoutAttributeLeft
                                                                  equal:self.itemsBgView
                                                                      m:1.0
                                                                      c:leftSpacing]);
        }
    }
    else {
        if (_leftItem) {
            self.con_leftItem_w.constant = 0.0;
        }
    }
    
    if (right_show) {
        self.con_rightItem_w.constant = self.rightItem.itemWidth;
        self.con_rightItem_toR = deal_con(self.con_rightItem_toR,
                                          [self.rightItem jx_con_same:NSLayoutAttributeRight
                                                                equal:self.itemsBgView
                                                                    m:1.0
                                                                    c:-rightSpacing]);
    }
    else {
        if (_rightItem) {
            self.con_rightItem_w.constant = 0.0;
        }
    }

    if (subRight_show) {
        self.con_subRightItem_w.constant = self.subRightItem.itemWidth;
        if (right_show) {
            self.con_subRightItem_toR = deal_con(self.con_subRightItem_toR,
                                                 [self.subRightItem jx_con_diff:NSLayoutAttributeRight
                                                                          equal:self.rightItem
                                                                           att2:NSLayoutAttributeLeft
                                                                              m:1.0
                                                                              c:-interitemSpacing]);
        }
        else {
            self.con_subRightItem_toR = deal_con(self.con_subRightItem_toR,
                                                 [self.subRightItem jx_con_same:NSLayoutAttributeRight
                                                                          equal:self.itemsBgView
                                                                              m:1.0
                                                                              c:-rightSpacing]);
        }
    }
    else {
        if (_subRightItem) {
            self.con_subRightItem_w.constant = 0.0;
        }
    }

    if (title_show) {
        self.con_titleItem_w.constant = self.titleItem.itemWidth;
        if (left_show || back_show) {
            self.con_titleItem_toL = deal_con(self.con_titleItem_toL,
                                              [self.titleItem jx_con_diff:NSLayoutAttributeLeft
                                                             greaterEqual:left_show ? self.leftItem : self.backItem
                                                                     att2:NSLayoutAttributeRight
                                                                        m:1.0
                                                                        c:interitemSpacing]);
        }
        if (subRight_show || right_show) {
            self.con_titleItem_toR = deal_con(self.con_titleItem_toR,
                                              [self.titleItem jx_con_diff:NSLayoutAttributeRight
                                                                lessEqual:subRight_show ? self.subRightItem : self.rightItem
                                                                     att2:NSLayoutAttributeLeft
                                                                        m:1.0
                                                                        c:-interitemSpacing]);
        }
    }
    else {
        if (_titleItem) {
            self.con_titleItem_w.constant = 0.0;
        }
    }

    [NSLayoutConstraint deactivateConstraints:cons_deactivate];
    [NSLayoutConstraint activateConstraints:cons_activate];
}

- (void)reAddSubviews {
    if (_uiNavigationBar) {
        [self addSubview:_uiNavigationBar];
    }
    if (_backgroundImageView) {
        [self addSubview:_backgroundImageView];
    }
    if (_itemsBgView) {
        [self addSubview:_itemsBgView];
    }
    if (_bottomLineView) {
        [self addSubview:_bottomLineView];
    }
}

@end


