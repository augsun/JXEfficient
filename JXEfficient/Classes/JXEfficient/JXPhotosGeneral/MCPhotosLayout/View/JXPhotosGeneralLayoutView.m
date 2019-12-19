//
//  JXPhotosGeneralLayoutView.m
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralLayoutView.h"

#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

#import "JXPhotosGeneralLayoutCell.h"

@interface JXPhotosGeneralLayoutView ()

@property (nonatomic, copy) NSArray <JXPhotosGeneralAsset *> *assets;
@property (nonatomic, strong) JXPhotosGeneralUsage *usage;

@end

@implementation JXPhotosGeneralLayoutView

@synthesize bottomBarView = _bottomBarView;

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

- (instancetype)initWithUsage:(JXPhotosGeneralUsage *)usage {
    self = [super init];
    if (self) {
        self.usage = usage;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    JX_WEAK_SELF;
    
    // naviBar
    _naviBar = [[JXNavigationBar alloc] init];
    [self addSubview:self.naviBar];
    self.naviBar.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.naviBar jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                              [self.naviBar jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                              [self.naviBar jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                              [self.naviBar jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_NAVBAR_H],
                                              ]];
    [self.naviBar.backItem setImageForNormal:[JXPhotosGeneralLayoutView jx_drawRightAngleArrow:JX_COLOR_HEX(JXNavigationBarItemNormalTitleColorDefault)]
                                 highlighted:[JXPhotosGeneralLayoutView jx_drawRightAngleArrow:JX_COLOR_HEX(JXNavigationBarItemHighlightedColorDefault)]
                                    disabled:[JXPhotosGeneralLayoutView jx_drawRightAngleArrow:JX_COLOR_HEX(JXNavigationBarItemDisabledColorDefault)]];
    UIEdgeInsets insets = self.naviBar.backItem.contentEdgeInsets;
    self.naviBar.backItem.contentEdgeInsets = UIEdgeInsetsMake(insets.top, 11.0, insets.bottom, 24.0);
    [self.naviBar.rightItem setTitle:@"取消" color:nil font:[UIFont systemFontOfSize:16.0]];
    self.naviBar.rightSpacing = 8.0;
    self.naviBar.translucent = YES;
    
    // layoutView
    _layoutView = [[JXPhotosLayoutView alloc] init];
    [self addSubview:self.layoutView];
    self.layoutView.translatesAutoresizingMaskIntoConstraints = NO;
    BOOL bottomBarView_show = NO;
    CGFloat contentInsetB = 0.0;
    CGFloat scrollIndicatorInsetB = 0.0;
    switch (self.usage.selectionType) {
        case JXPhotosGeneralLayoutSelectionTypeSingle: {
            bottomBarView_show = NO;
            contentInsetB = JX_UNUSE_AREA_OF_BOTTOM;
            scrollIndicatorInsetB = JX_UNUSE_AREA_OF_BOTTOM;
        } break;
        case JXPhotosGeneralLayoutSelectionTypeMulti: {
            bottomBarView_show = YES;
            contentInsetB = JX_TABBAR_H;
            scrollIndicatorInsetB = JX_TABBAR_H;
        } break;
        default: break;
    }
    [NSLayoutConstraint activateConstraints:@[
                                              [self.layoutView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                              [self.layoutView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                              [self.layoutView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                              [self.layoutView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                              ]];
    self.layoutView.cellClass = [JXPhotosGeneralLayoutCell class];
    self.layoutView.interitemSpacing = 4.0;
    self.layoutView.lineSpacing = 4.0;
    self.layoutView.sectionInset = UIEdgeInsetsMake(4.0, 0.0, 4.0, 0.0);
    self.layoutView.collectionView.contentInset = UIEdgeInsetsMake(JX_NAVBAR_H, 0.0, contentInsetB, 0.0);
    self.layoutView.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(JX_NAVBAR_H, 0.0, scrollIndicatorInsetB, 0.0);
    [self bringSubviewToFront:self.naviBar];

    CGFloat leftW =
    JX_SCREEN_W -
    self.layoutView.collectionView.contentInset.left -
    self.layoutView.collectionView.contentInset.right -
    self.layoutView.sectionInset.left -
    self.layoutView.sectionInset.right;
    
    NSInteger countPerRow = 4;
    CGFloat itemW = (leftW - (countPerRow - 1) * self.layoutView.interitemSpacing) / countPerRow;
    CGFloat itemH = itemW;
    CGSize expectItemSize = CGSizeMake(itemW, itemH);
    self.layoutView.expectItemSize = expectItemSize;
    
    CGSize thumbImageSize = CGSizeMake(expectItemSize.width * JX_SCREEN_SCALE, expectItemSize.height * JX_SCREEN_SCALE);
    self.layoutView.refreshCellUsingBlock = ^(__kindof JXPhotosGeneralLayoutCell * _Nonnull cell, __kindof JXPhotosGeneralAsset * _Nonnull asset) {
        JX_STRONG_SELF;
        cell.selClick = self.selectClick;
        [cell refreshUI:asset thumbImageSize:thumbImageSize usage:self.usage];
    };
    
    // bottomBarView
    if (bottomBarView_show) {
        _bottomBarView = [[JXPhotosGeneralBottomBarView alloc] init];
        [self addSubview:self.bottomBarView];
        self.bottomBarView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.bottomBarView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.bottomBarView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                                  [self.bottomBarView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [self.bottomBarView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_TABBAR_H],
                                                  ]];
        self.bottomBarView.leftTitle = @"预览";
        self.bottomBarView.rightTitle = @"发送";
        self.bottomBarView.rightButtonEnable = NO;
    }
    
}

- (JXPhotosGeneralBottomBarView *)bottomBarView {
    if (!_bottomBarView) {
        _bottomBarView = [[JXPhotosGeneralBottomBarView alloc] init];
    }
    return _bottomBarView;
}

- (void)refreshUIWithAssets:(NSArray<JXPhotosGeneralAsset *> *)assets {
    _assets = [assets copy];;
    
    self.layoutView.assets = assets;
}

@end




