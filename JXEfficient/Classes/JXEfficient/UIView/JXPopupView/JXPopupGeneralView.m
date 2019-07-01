//
//  JXPopupGeneralView.m
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import "JXPopupGeneralView.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

@interface JXPopupGeneralView ()

@end

@implementation JXPopupGeneralView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self JXPopupGeneralView_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self JXPopupGeneralView_moreInit];
    }
    return self;
}

- (void)JXPopupGeneralView_moreInit {
    self.animation = YES;
    self.popupBgViewToT_min = 30.0;
    self.popupBgViewToB_min = 30.0 + JX_UNUSE_AREA_OF_BOTTOM;

    // titleLabel
    {
        _titleLabel = [[UILabel alloc] init];
        [self.titleView addSubview:self.titleLabel];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray <NSLayoutConstraint *> *cons = [self.titleLabel jx_con_edgeEqual:self.titleView];
        [NSLayoutConstraint activateConstraints:cons];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:18.0];
        self.titleLabel.textColor = JX_COLOR_GRAY(51);
    }
    
    // contentLabel
    {
        _contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray <NSLayoutConstraint *> *cons = [self.contentLabel jx_con_edgeEqual:self.contentView];
        [NSLayoutConstraint activateConstraints:cons];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:14.0];
        self.contentLabel.textColor = JX_COLOR_GRAY(51);
    }
    
    // buttonHorizontalLineView
    {
        _buttonHorizontalLineView = [[UIView alloc] init];
        [self.buttonsView addSubview:self.buttonHorizontalLineView];
        self.buttonHorizontalLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.buttonHorizontalLineView jx_con_same:NSLayoutAttributeTop equal:self.buttonsView m:1.0 c:0.0],
                                                  [self.buttonHorizontalLineView jx_con_same:NSLayoutAttributeLeft equal:self.buttonsView m:1.0 c:0.0],
                                                  [self.buttonHorizontalLineView jx_con_same:NSLayoutAttributeRight equal:self.buttonsView m:1.0 c:0.0],
                                                  [self.buttonHorizontalLineView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_SCREEN_ONE_PIX],
                                                  ]];
        self.buttonHorizontalLineView.backgroundColor = JX_COLOR_GRAY(222);
        self.buttonHorizontalLineView.userInteractionEnabled = NO;
    }
    
    // buttonVerticalLineView
    {
        _buttonVerticalLineView = [[UIView alloc] init];
        [self.buttonsView addSubview:self.buttonVerticalLineView];
        self.buttonVerticalLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.buttonVerticalLineView jx_con_diff:NSLayoutAttributeTop equal:self.buttonHorizontalLineView att2:NSLayoutAttributeBottom m:1.0 c:0.0],
                                                  [self.buttonVerticalLineView jx_con_same:NSLayoutAttributeCenterX equal:self.buttonsView m:1.0 c:0.0],
                                                  [self.buttonVerticalLineView jx_con_same:NSLayoutAttributeBottom equal:self.buttonsView m:1.0 c:0.0],
                                                  [self.buttonVerticalLineView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:JX_SCREEN_ONE_PIX],
                                                  ]];
        self.buttonVerticalLineView.backgroundColor = JX_COLOR_GRAY(222);
        self.buttonVerticalLineView.userInteractionEnabled = NO;
    }
    
    // button0Label
    {
        _button0Label = [[UILabel alloc] init];
        [self.buttonsView addSubview:self.button0Label];
        self.button0Label.translatesAutoresizingMaskIntoConstraints = NO;
        self.button0Label.textAlignment = NSTextAlignmentCenter;
        self.button0Label.font = [UIFont systemFontOfSize:16.0];
        self.button0Label.textColor = JX_COLOR_GRAY(51);
        {
            UIButton *btn = [[UIButton alloc] init];
            [self.buttonsView addSubview:btn];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:[btn jx_con_edgeEqual:self.button0Label]];
            [btn addTarget:self action:@selector(btn0Click) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // button1Label
    {
        _button1Label = [[UILabel alloc] init];
        [self.buttonsView addSubview:self.button1Label];
        self.button1Label.translatesAutoresizingMaskIntoConstraints = NO;
        self.button1Label.textAlignment = NSTextAlignmentCenter;
        self.button1Label.font = [UIFont systemFontOfSize:16.0];
        self.button1Label.textColor = JX_COLOR_GRAY(51);
        {
            UIButton *btn = [[UIButton alloc] init];
            [self.buttonsView addSubview:btn];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:[btn jx_con_edgeEqual:self.button1Label]];
            [btn addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)show {
    
#pragma mark 计算各部分高度
    
    // titleLabel
    {
        CGFloat h = [self.titleLabel sizeThatFits:CGSizeMake(
                                                             JX_SCREEN_W - 2 * self.popupBgViewToLR - self.titleViewEdgeInsets.left - self.titleViewEdgeInsets.right,
                                                             CGFLOAT_MAX
                                                             )].height;
        self.titleViewContentH = h > 0.0 ? h + 1.0 : 0.0;
    }
    
    // contentLabel
    {
        CGFloat h = [self.contentLabel sizeThatFits:CGSizeMake(
                                                               JX_SCREEN_W - 2 * self.popupBgViewToLR - self.contentViewEdgeInsets.left - self.contentViewEdgeInsets.right,
                                                               CGFLOAT_MAX
                                                               )].height;
        self.contentViewContentH = h > 0.0 ? h + 1.0 : 0.0;
    }
    
    // button0Label & button1Label
    BOOL haveB0 = self.button0Label.text || self.button0Label.attributedText;
    BOOL haveB1 = self.button1Label.text || self.button1Label.attributedText;
    if (haveB0 || haveB1) {
        self.buttonsViewContentH = 44.0;
        if (haveB0 && haveB1) {
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.button0Label jx_con_same:NSLayoutAttributeTop equal:self.buttonsView m:1.0 c:0.0],
                                                      [self.button0Label jx_con_same:NSLayoutAttributeLeft equal:self.buttonsView m:1.0 c:0.0],
                                                      [self.button0Label jx_con_same:NSLayoutAttributeBottom equal:self.buttonsView m:1.0 c:0.0],
                                                      [self.button0Label jx_con_diff:NSLayoutAttributeRight equal:self.buttonVerticalLineView att2:NSLayoutAttributeLeft m:1.0 c:0.0],
                                                      ]];
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.button1Label jx_con_same:NSLayoutAttributeTop equal:self.buttonsView m:1.0 c:0.0],
                                                      [self.button1Label jx_con_diff:NSLayoutAttributeLeft equal:self.buttonVerticalLineView att2:NSLayoutAttributeRight m:1.0 c:0.0],
                                                      [self.button1Label jx_con_same:NSLayoutAttributeRight equal:self.buttonsView m:1.0 c:0.0],
                                                      [self.button1Label jx_con_same:NSLayoutAttributeBottom equal:self.buttonsView m:1.0 c:0.0],
                                                      ]];
        }
        else if (haveB0 && !haveB1) {
            [NSLayoutConstraint activateConstraints:[self.button0Label jx_con_edgeEqual:self.buttonsView]];
        }
        else if (!haveB0 && haveB1) {
            [NSLayoutConstraint activateConstraints:[self.button1Label jx_con_edgeEqual:self.buttonsView]];
        }
        
        //
        self.buttonVerticalLineView.hidden = !(haveB0 && haveB1);
    }
    
#pragma mark 边距调整
    
    BOOL haveTitle = self.titleViewContentH > 0.0;
    BOOL haveContent = self.contentViewContentH > 0.0;
    BOOL haveButtons = self.buttonsViewContentH > 0.0;

    if (haveTitle && haveContent && haveButtons) {
        self.popupBgViewContentEdgeT = 20.0;
        self.contentViewToAboveWidget = 3.0;
        self.popupBgViewContentEdgeB = 0.0;
    }
    else if (haveTitle && haveContent && !haveButtons) {
        self.popupBgViewContentEdgeT = 20.0;
        self.contentViewToAboveWidget = 3.0;

    }
    else if (haveTitle && !haveContent && haveButtons) {
        self.popupBgViewContentEdgeT = 20.0;
        self.buttonsViewToAboveWidget = 20.0;
        self.popupBgViewContentEdgeB = 0.0;
    }
    else if (haveTitle && !haveContent && !haveButtons) {
        self.popupBgViewContentEdgeT = 20.0;
        self.popupBgViewContentEdgeB = 20.0;
    }
    else if (!haveTitle && haveContent && haveButtons) {
        self.popupBgViewContentEdgeT = 10.0;
        self.contentViewToAboveWidget = 3.0;
        self.popupBgViewContentEdgeB = 0.0;
    }
    else if (!haveTitle && haveContent && !haveButtons) {
        self.popupBgViewContentEdgeT = 10.0;
        self.contentViewToAboveWidget = 3.0;
        self.popupBgViewContentEdgeB = 10.0;
    }
    else if (!haveTitle && !haveContent && haveButtons) {
        self.popupBgViewContentEdgeT = 0.0;
        self.popupBgViewContentEdgeB = 0.0;
    }
    else if (!haveTitle && !haveContent && !haveButtons) {
        
    }
    
    // 只有按钮的情况 隐藏 buttonHorizontalLineView
    self.buttonHorizontalLineView.hidden = !haveTitle && !haveContent && haveButtons;

    //
    [super show];
}

- (void)btn0Click {
    JX_BLOCK_EXEC(self.button0Click);
}

- (void)btn1Click {
    JX_BLOCK_EXEC(self.button1Click);
}

@end
