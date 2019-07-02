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

@property (nonatomic, readonly) UIButton *button0;
@property (nonatomic, readonly) UIButton *button1;

@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *button0Label_cons;
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *button1Label_cons;

@property (nonatomic, assign) CGSize selfSizePre;

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
            _button0 = [[UIButton alloc] init];
            [self.buttonsView addSubview:self.button0];
            self.button0.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:[self.button0 jx_con_edgeEqual:self.button0Label]];
            [self.button0 addTarget:self action:@selector(JXPopupGeneralView_btn0Click) forControlEvents:UIControlEventTouchUpInside];
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
            _button1 = [[UIButton alloc] init];
            [self.buttonsView addSubview:self.button1];
            self.button1.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:[self.button1 jx_con_edgeEqual:self.button1Label]];
            [self.button1 addTarget:self action:@selector(JXPopupGeneralView_btn1Click) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)setCustomTitleView:(UIView *)customTitleView {
    _customTitleView = customTitleView;
    
    customTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleView addSubview:customTitleView];
    [NSLayoutConstraint activateConstraints:[customTitleView jx_con_edgeEqual:self.titleView]];
}

- (void)setCustomContentView:(UIView *)customContentView {
    _customContentView = customContentView;
    
    customContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:customContentView];
    [NSLayoutConstraint activateConstraints:[customContentView jx_con_edgeEqual:self.contentView]];
}

- (void)setCustomButtonsView:(UIView *)customButtonsView {
    _customButtonsView = customButtonsView;
    
    customButtonsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.buttonsView addSubview:customButtonsView];
    [NSLayoutConstraint activateConstraints:[customButtonsView jx_con_edgeEqual:self.buttonsView]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.frame.size.width > 0.0 && self.frame.size.height > 0.0 &&
        (self.frame.size.width != self.selfSizePre.width || self.frame.size.height != self.selfSizePre.height) &&
        self.didShowed) {
        
        self.selfSizePre = self.frame.size;
        
        [self JXPopupGeneralView_countLayout];
        
        [self refreshLayoutAnimated:YES];
    }
}

- (void)show {
    [self JXPopupGeneralView_countLayout];
    
    //
    [super show];
}

- (void)JXPopupGeneralView_countLayout {
    
#pragma mark 计算各部分控件高度
    
    // titleLabel
    if (self.customTitleView) {
        if (self.heightFor_customTitleView) {
            self.titleViewContentH = self.heightFor_customTitleView();
        }
        else {
            self.titleViewContentH = 0.0;
        }
    }
    else {
        CGFloat h = [self.titleLabel sizeThatFits:CGSizeMake(
                                                             JX_SCREEN_W - 2 * self.popupBgViewToLR - self.titleViewEdgeInsets.left - self.titleViewEdgeInsets.right,
                                                             CGFLOAT_MAX
                                                             )].height;
        self.titleViewContentH = h > 0.0 ? h + 1.0 : 0.0;
    }
    
    // contentLabel
    if (self.customContentView) {
        if (self.heightFor_customContentView) {
            self.contentViewContentH = self.heightFor_customContentView();
        }
        else {
            self.contentViewContentH = 0.0;
        }
    }
    else {
        CGFloat h = [self.contentLabel sizeThatFits:CGSizeMake(
                                                               JX_SCREEN_W - 2 * self.popupBgViewToLR - self.contentViewEdgeInsets.left - self.contentViewEdgeInsets.right,
                                                               CGFLOAT_MAX
                                                               )].height;
        self.contentViewContentH = h > 0.0 ? h + 1.0 : 0.0;
    }
    
    // button0Label & button1Label
    if (self.customButtonsView) {
        self.button0Label.hidden = YES;
        self.button0.hidden = YES;
        
        self.button1Label.hidden = YES;
        self.button1.hidden = YES;
        
        self.buttonVerticalLineView.hidden = YES;
        
        if (self.heightFor_customButtonsView) {
            self.buttonsViewContentH = self.heightFor_customButtonsView();
        }
        else {
            self.buttonsViewContentH = 0.0;
        }
    }
    else {
        BOOL haveB0 = self.button0Label.text || self.button0Label.attributedText;
        BOOL haveB1 = self.button1Label.text || self.button1Label.attributedText;
        if (haveB0 || haveB1) {
            self.buttonsViewContentH = 44.0;
            if (haveB0 && haveB1) {
                self.button0Label.hidden = NO;
                self.button0.hidden = NO;
                
                self.button1Label.hidden = NO;
                self.button1.hidden = NO;
                
                {
                    NSArray <NSLayoutConstraint *> *cons = @[
                                                             [self.button0Label jx_con_same:NSLayoutAttributeTop equal:self.buttonsView m:1.0 c:0.0],
                                                             [self.button0Label jx_con_same:NSLayoutAttributeLeft equal:self.buttonsView m:1.0 c:0.0],
                                                             [self.button0Label jx_con_same:NSLayoutAttributeBottom equal:self.buttonsView m:1.0 c:0.0],
                                                             [self.button0Label jx_con_diff:NSLayoutAttributeRight equal:self.buttonVerticalLineView att2:NSLayoutAttributeLeft m:1.0 c:0.0],
                                                             ];
                    if (self.button0Label_cons.count > 0) {
                        [NSLayoutConstraint deactivateConstraints:self.button0Label_cons];
                    }
                    self.button0Label_cons = cons;
                    [NSLayoutConstraint activateConstraints:self.button0Label_cons];
                }
                {
                    NSArray <NSLayoutConstraint *> *cons = @[
                                                             [self.button1Label jx_con_same:NSLayoutAttributeTop equal:self.buttonsView m:1.0 c:0.0],
                                                             [self.button1Label jx_con_diff:NSLayoutAttributeLeft equal:self.buttonVerticalLineView att2:NSLayoutAttributeRight m:1.0 c:0.0],
                                                             [self.button1Label jx_con_same:NSLayoutAttributeRight equal:self.buttonsView m:1.0 c:0.0],
                                                             [self.button1Label jx_con_same:NSLayoutAttributeBottom equal:self.buttonsView m:1.0 c:0.0],
                                                             ];
                    if (self.button1Label_cons.count > 0) {
                        [NSLayoutConstraint deactivateConstraints:self.button1Label_cons];
                    }
                    self.button1Label_cons = cons;
                    [NSLayoutConstraint activateConstraints:self.button1Label_cons];
                }
            }
            else if (haveB0 && !haveB1) {
                self.button0Label.hidden = NO;
                self.button0.hidden = NO;
                NSArray <NSLayoutConstraint *> *cons = [self.button0Label jx_con_edgeEqual:self.buttonsView];
                if (self.button0Label_cons.count > 0) {
                    [NSLayoutConstraint deactivateConstraints:self.button0Label_cons];
                }
                self.button0Label_cons = cons;
                [NSLayoutConstraint activateConstraints:self.button0Label_cons];
            }
            else if (!haveB0 && haveB1) {
                self.button1Label.hidden = NO;
                self.button1.hidden = NO;
                NSArray <NSLayoutConstraint *> *cons = [self.button1Label jx_con_edgeEqual:self.buttonsView];
                if (self.button1Label_cons.count > 0) {
                    [NSLayoutConstraint deactivateConstraints:self.button1Label_cons];
                }
                self.button1Label_cons = cons;
                [NSLayoutConstraint activateConstraints:self.button1Label_cons];
            }
            
            //
            self.buttonVerticalLineView.hidden = !(haveB0 && haveB1);
        }
        else {
            self.buttonsViewContentH = 0.0;
        }
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
    
    if (self.customButtonsView) {
        self.buttonHorizontalLineView.hidden = YES;
    }
    else {
        // 只有按钮的情况 隐藏 buttonHorizontalLineView
        self.buttonHorizontalLineView.hidden = !haveTitle && !haveContent && haveButtons;
    }
}

- (void)JXPopupGeneralView_btn0Click {
    JX_BLOCK_EXEC(self.button0Click);
    if (self.hideJustByClicking) {
        [self hide];
    }
}

- (void)JXPopupGeneralView_btn1Click {
    JX_BLOCK_EXEC(self.button1Click);
    if (self.hideJustByClicking) {
        [self hide];
    }
}

@end
