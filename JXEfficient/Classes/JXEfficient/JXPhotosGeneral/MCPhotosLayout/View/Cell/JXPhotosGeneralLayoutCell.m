//
//  JXPhotosGeneralLayoutCell.m
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralLayoutCell.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

@interface JXPhotosGeneralLayoutCell ()

@property (nonatomic, strong) UIView *bgView; ///< 主背景视图

@property (nonatomic, strong) UIView *selNumBgView; ///< 选中后显示数字的背景视图
@property (nonatomic, strong) UILabel *selNumLabel; ///< 选中后显示数据

@property (nonatomic, strong) UIView *unSelBgView; ///< 未选中背景视图
@property (nonatomic, strong) UILabel *unSelHookLabel; ///< 未选中打钩

@property (nonatomic, strong) UIView *coverView; ///< 超过最大可选后的蒙层

@property (nonatomic, strong) UIButton *selButton; ///< 触发 选中/非选中 按钮

@end

@implementation JXPhotosGeneralLayoutCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // bgView
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.bgView jx_con_edgeEqual:self.contentView]];
        
        // selBgView
        self.selNumBgView = [[UIView alloc] init];
        [self.bgView addSubview:self.selNumBgView];
        self.selNumBgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.selNumBgView jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:5.0],
                                                  [self.selNumBgView jx_con_same:NSLayoutAttributeRight equal:self.bgView m:1.0 c:-5.0],
                                                  [self.selNumBgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:22.0],
                                                  [self.selNumBgView jx_con_same:NSLayoutAttributeLeft greaterEqual:self.bgView m:1.0 c:5.0],
                                                  [self.selNumBgView jx_con_same:NSLayoutAttributeWidth greaterEqual:nil m:1.0 c:22.0],
                                                  ]];
        self.selNumBgView.layer.cornerRadius = 22.0 / 2.0;
        self.selNumBgView.clipsToBounds = YES;
        self.selNumBgView.backgroundColor = JX_COLOR_RGB(254, 105, 75);
        
        // selNumLabel
        self.selNumLabel = [[UILabel alloc] init];
        self.selNumLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.selNumBgView addSubview:self.selNumLabel];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.selNumLabel jx_con_same:NSLayoutAttributeTop equal:self.selNumBgView m:1.0 c:0.0],
                                                  [self.selNumLabel jx_con_same:NSLayoutAttributeLeft equal:self.selNumBgView m:1.0 c:4.0],
                                                  [self.selNumLabel jx_con_same:NSLayoutAttributeBottom equal:self.selNumBgView m:1.0 c:0.0],
                                                  [self.selNumLabel jx_con_same:NSLayoutAttributeRight equal:self.selNumBgView m:1.0 c:-4.0],
                                                  ]];
        self.selNumLabel.font = [UIFont systemFontOfSize:16.0];
        self.selNumLabel.textAlignment = NSTextAlignmentCenter;
        self.selNumLabel.textColor = [UIColor whiteColor];
        
        // unSelBgView
        self.unSelBgView = [[UIView alloc] init];
        [self.bgView addSubview:self.unSelBgView];
        self.unSelBgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.unSelBgView jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:5.0],
                                                  [self.unSelBgView jx_con_same:NSLayoutAttributeRight equal:self.bgView m:1.0 c:-5.0],
                                                  [self.unSelBgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:22.0],
                                                  [self.unSelBgView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:22.0],
                                                  ]];
        self.unSelBgView.layer.cornerRadius = 22.0 / 2.0;
        self.unSelBgView.layer.borderWidth = 1.2;
        self.unSelBgView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.unSelBgView.clipsToBounds = YES;
        self.unSelBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        
        // unSelHookLabel
        self.unSelHookLabel = [[UILabel alloc] init];
        [self.unSelBgView addSubview:self.unSelHookLabel];
        self.unSelHookLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.unSelHookLabel jx_con_edgeEqual:self.unSelBgView]];
        self.unSelHookLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        self.unSelHookLabel.textAlignment = NSTextAlignmentCenter;
        self.unSelHookLabel.text = @"✓";
        self.unSelHookLabel.textColor = [UIColor whiteColor];

        // coverView
        self.coverView = [[UIView alloc] init];
        [self.bgView addSubview:self.coverView];
        self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.coverView jx_con_edgeEqual:self.bgView]];
        self.coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        
        //
        self.selButton = [[UIButton alloc] init];
        [self.bgView addSubview:self.selButton];
        self.selButton.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.selButton jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:0.0],
                                                  [self.selButton jx_con_same:NSLayoutAttributeRight equal:self.bgView m:1.0 c:0.0],
                                                  [self.selButton jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:44.0],
                                                  [self.selButton jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:44.0],
                                                  ]];
        [self.selButton addTarget:self action:@selector(btnSelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)refreshUI:(JXPhotosGeneralAsset *)asset thumbImageSize:(CGSize)thumbImageSize usage:(JXPhotosGeneralUsage *)usage {
    JXPhotosGeneralAsset *pre_asset = (JXPhotosGeneralAsset *)self.asset;
    pre_asset.sourceImageView = nil;

    [super refreshUI:asset thumbImageSize:thumbImageSize];
    asset.sourceImageView = self.thumbImageView;

    switch (usage.selectionType) {
        case JXPhotosGeneralLayoutSelectionTypeSingle:
        {
            self.selButton.hidden = YES;

            self.coverView.hidden = YES;
            self.selNumBgView.hidden = YES;
            self.unSelBgView.hidden = YES;
        } break;

        case JXPhotosGeneralLayoutSelectionTypeMulti:
        {
            //
            self.selButton.hidden = NO;

            if (asset.selected) {
                self.coverView.hidden = YES;
                self.selNumBgView.hidden = NO;
                self.unSelBgView.hidden = YES;

                self.selNumLabel.text = [NSString stringWithFormat:@"%ld", asset.selectedIndex];
            }
            else {
                if (asset.covered) {
                    self.coverView.hidden = NO;
                }
                else {
                    self.coverView.hidden = YES;
                }
                self.selNumBgView.hidden = YES;
                self.unSelBgView.hidden = NO;
            }
        } break;

        default: break;
    }
}

- (IBAction)btnSelClick:(id)sender {
    JX_BLOCK_EXEC(self.selClick, self.asset);
}

@end
