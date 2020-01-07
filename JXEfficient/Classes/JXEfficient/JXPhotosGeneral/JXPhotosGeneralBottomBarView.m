//
//  JXPhotosGeneralBottomBarView.m
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralBottomBarView.h"

#import "JXNavigationBar.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

const CGFloat JXPhotosGeneralBottomBarViewFixedHeight = 49.0;

@interface JXPhotosGeneralBottomBarView ()

@property (nonatomic, strong) JXNavigationBar *navigationBar;

@property (nonatomic, strong) UIView *bgView; ///< 49 高度

@end

@implementation JXPhotosGeneralBottomBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [JX_COLOR_GRAY(40) colorWithAlphaComponent:0.9];

        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.bgView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                                  [self.bgView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.bgView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [self.bgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:49.0],
                                                  ]];
        self.bgView.backgroundColor = [UIColor clearColor];
        
        _navigationBar = [[JXNavigationBar alloc] init];
        [self.bgView addSubview:self.navigationBar];
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.navigationBar jx_con_edgeEqual:self.bgView]];
        self.navigationBar.backgroundColor = [UIColor clearColor];
        self.navigationBar.leftItem.contentEdgeInsets = UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0);
        self.navigationBar.rightItem.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 8.0);
    }
    return self;
}

- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
    [self.navigationBar.leftItem setTitle:leftTitle normalColor:[UIColor whiteColor]
                         highlightedColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]
                            disabledColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]
                                     font:[UIFont systemFontOfSize:17.0]];
}

- (void)setLeftClick:(void (^)(void))leftClick {
    _leftClick = leftClick;
    JX_WEAK_SELF;
    self.navigationBar.leftItem.click = ^{
        JX_STRONG_SELF;
        JX_BLOCK_EXEC(self.leftClick);
    };
}

- (void)setLeftButtonEnable:(BOOL)leftButtonEnable {
    _leftButtonEnable = leftButtonEnable;
    self.navigationBar.leftItem.enable = leftButtonEnable;
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    [self.navigationBar.rightItem setTitle:rightTitle normalColor:[UIColor whiteColor]
                          highlightedColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]
                             disabledColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]
                                      font:[UIFont systemFontOfSize:17.0]];
}

- (void)setRightClick:(void (^)(void))rightClick {
    _rightClick = rightClick;
    JX_WEAK_SELF;
    self.navigationBar.rightItem.click = ^{
        JX_STRONG_SELF;
        JX_BLOCK_EXEC(self.rightClick);
    };
}

- (void)setRightButtonEnable:(BOOL)rightButtonEnable {
    _rightButtonEnable = rightButtonEnable;
    self.navigationBar.rightItem.enable = rightButtonEnable;
}

@end
