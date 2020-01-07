//
//  JXPhotosGeneralNaviView.m
//  JXEfficient
//
//  Created by augsun on 7/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralNaviView.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

static const CGFloat k_rightNunBgView_h = 26.0;

@interface JXPhotosGeneralNaviView ()

@property (nonatomic, strong) UIView *rightBgView;

@property (nonatomic, strong) UIView *rightNunBgView; ///< sel
@property (nonatomic, strong) UILabel *rightNumLabel;

@property (nonatomic, strong) UIView *unSelBorderBgView; ///< unSel

@property (nonatomic, strong) JXPhotosGeneralUsage *usage;

@end

@implementation JXPhotosGeneralNaviView

- (instancetype)initWithUsage:(JXPhotosGeneralUsage *)usage {
    self = [super init];
    if (self) {
        self.usage = usage;
        
        //
        self.rightBgView = [[UIView alloc] init];
        self.rightItem.customContentView = self.rightBgView;
        self.rightItem.customContentViewWidth = 60.0;
        self.rightBgView.userInteractionEnabled = NO;
        
        // unSelBorderBgView
        switch (self.usage.selectionType) {
            case JXPhotosGeneralLayoutSelectionTypeMulti:
            {
                // rightNunBgView
                self.rightNunBgView = [[UIView alloc] init];
                [self.rightBgView addSubview:self.rightNunBgView];
                self.rightNunBgView.translatesAutoresizingMaskIntoConstraints = NO;
                [NSLayoutConstraint activateConstraints:@[
                                                          [self.rightNunBgView jx_con_same:NSLayoutAttributeCenterY equal:self.rightBgView m:1.0 c:0.0],
                                                          [self.rightNunBgView jx_con_same:NSLayoutAttributeWidth greaterEqual:nil m:1.0 c:k_rightNunBgView_h],
                                                          [self.rightNunBgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:k_rightNunBgView_h],
                                                          [self.rightNunBgView jx_con_same:NSLayoutAttributeRight equal:self.rightBgView m:1.0 c:-(15.0 - self.rightSpacing - self.rightItem.contentEdgeInsets.right)],
                                                          [self.rightNunBgView jx_con_same:NSLayoutAttributeLeft greaterEqual:self.rightBgView m:1.0 c:0.0],
                                                          ]];
                self.rightNunBgView.backgroundColor = JX_COLOR_RGB(254, 105, 75);
                self.rightNunBgView.clipsToBounds = YES;
                self.rightNunBgView.layer.cornerRadius = k_rightNunBgView_h / 2.0;
                
                // rightNumLabel
                self.rightNumLabel = [[UILabel alloc] init];
                [self.rightNunBgView addSubview:self.rightNumLabel];
                self.rightNumLabel.translatesAutoresizingMaskIntoConstraints = NO;
                [NSLayoutConstraint activateConstraints:@[
                                                          [self.rightNumLabel jx_con_same:NSLayoutAttributeTop equal:self.rightNunBgView m:1.0 c:0.0],
                                                          [self.rightNumLabel jx_con_same:NSLayoutAttributeLeft equal:self.rightNunBgView m:1.0 c:4.0],
                                                          [self.rightNumLabel jx_con_same:NSLayoutAttributeBottom equal:self.rightNunBgView m:1.0 c:0.0],
                                                          [self.rightNumLabel jx_con_same:NSLayoutAttributeRight equal:self.rightNunBgView m:1.0 c:-4.0],
                                                          ]];
                self.rightNumLabel.textAlignment = NSTextAlignmentCenter;
                self.rightNumLabel.font = [UIFont systemFontOfSize:16.0];
                self.rightNumLabel.textColor = [UIColor whiteColor];
                
                // unSelBorderBgView
                self.unSelBorderBgView = [[UIView alloc] init];
                [self.rightBgView addSubview:self.unSelBorderBgView];
                self.unSelBorderBgView.translatesAutoresizingMaskIntoConstraints = NO;
                [NSLayoutConstraint activateConstraints:@[
                                                          [self.unSelBorderBgView jx_con_same:NSLayoutAttributeCenterY equal:self.rightBgView m:1.0 c:0.0],
                                                          [self.unSelBorderBgView jx_con_same:NSLayoutAttributeWidth greaterEqual:nil m:1.0 c:k_rightNunBgView_h],
                                                          [self.unSelBorderBgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:k_rightNunBgView_h],
                                                          [self.unSelBorderBgView jx_con_same:NSLayoutAttributeRight equal:self.rightBgView m:1.0 c:-(15.0 - self.rightSpacing - self.rightItem.contentEdgeInsets.right)],
                                                          ]];
                self.unSelBorderBgView.backgroundColor = [UIColor clearColor];
                self.unSelBorderBgView.clipsToBounds = YES;
                self.unSelBorderBgView.layer.cornerRadius = k_rightNunBgView_h / 2.0;
                self.unSelBorderBgView.layer.borderWidth = 1.2;
                self.unSelBorderBgView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
                
                {
                    UILabel *lbl = [[UILabel alloc] init];
                    [self.unSelBorderBgView addSubview:lbl];
                    lbl.translatesAutoresizingMaskIntoConstraints = NO;
                    [NSLayoutConstraint activateConstraints:[lbl jx_con_edgeEqual:self.unSelBorderBgView]];
                    lbl.textAlignment = NSTextAlignmentCenter;
                    lbl.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
                    lbl.text = @"✓";
                    lbl.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
                }
            } break;
                
            case JXPhotosGeneralLayoutSelectionTypeSingle:
            {
                UILabel *lbl = [[UILabel alloc] init];
                [self.rightBgView addSubview:lbl];
                lbl.translatesAutoresizingMaskIntoConstraints = NO;
                [NSLayoutConstraint activateConstraints:[lbl jx_con_edgeEqual:self.rightBgView]];
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.font = [UIFont systemFontOfSize:17.0];
                lbl.text = @"完成";
                lbl.textColor = JX_COLOR_RGB(254, 105, 75);
            } break;
                
            default: break;
        }
    }
    return self;
}

- (void)setAsset:(JXPhotosGeneralAsset *)asset {
    _asset = asset;
    [self refreshSelected:asset.selected index:asset.selectedIndex];
}

- (void)refreshSelected:(BOOL)selected index:(NSInteger)index {
    if (selected) {
        self.rightNunBgView.hidden = NO;
        self.unSelBorderBgView.hidden = YES;
        self.rightNumLabel.text = [NSString stringWithFormat:@"%ld", index];
    }
    else {
        self.rightNunBgView.hidden = YES;
        self.unSelBorderBgView.hidden = NO;
    }
}

@end
