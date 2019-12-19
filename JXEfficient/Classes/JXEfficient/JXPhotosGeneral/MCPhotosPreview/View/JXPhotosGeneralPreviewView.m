//
//  JXPhotosGeneralPreviewView.m
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralPreviewView.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"
#import "UIView+JXCategory.h"
#import "UICollectionView+JXCategory.h"

#import "JXPhotosGeneralPreviewViewCell.h"

static const CGFloat kInteritemSpace = 15.f;

static NSString *const kCellID = @"kCellID";

@interface JXPhotosGeneralPreviewView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) JXPhotosGeneralAsset *clickAsset;

@property (nonatomic, strong) NSLayoutConstraint *bottomView_h;

@property (nonatomic, assign) BOOL didSet_tagModels;
@property (nonatomic, assign) BOOL tagsView_show;

@property (nonatomic, strong) JXPhotosGeneralUsage *usage;

@end

@implementation JXPhotosGeneralPreviewView

- (instancetype)initWithUsage:(JXPhotosGeneralUsage *)usage {
    self = [super init];
    if (self) {
        self.usage = usage;
        
        // collectionView
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [self addSubview:self.collectionView];
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.collectionView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                                  [self.collectionView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.collectionView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                                  [self.collectionView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:kInteritemSpace],
                                                  ]];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumLineSpacing = kInteritemSpace;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, kInteritemSpace);
        self.collectionView.alwaysBounceHorizontal = NO;
        self.collectionView.alwaysBounceVertical = NO;
        [self.collectionView registerClass:[JXPhotosGeneralPreviewViewCell class] forCellWithReuseIdentifier:kCellID];
        
        // naviView
        _naviView = [[JXPhotosGeneralNaviView alloc] initWithUsage:self.usage];
        [self addSubview:self.naviView];
        self.naviView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.naviView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                                  [self.naviView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.naviView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [self.naviView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_NAVBAR_H],
                                                  ]];
        self.naviView.bgColorStyle = YES;
        self.naviView.backgroundColor = [JX_COLOR_GRAY(40) colorWithAlphaComponent:0.9];

        // bottomView
        switch (self.usage.selectionType) {
            case JXPhotosGeneralLayoutSelectionTypeMulti:
            {
                _bottomView = [[JXPhotosGeneralPreviewBottomView alloc] init];
                [self addSubview:self.bottomView];
                self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
                self.bottomView_h = [self.bottomView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JXPhotosGeneralPreviewBottomViewTagsFixedHeight + JXPhotosGeneralBottomBarViewFixedHeight + JX_UNUSE_AREA_OF_BOTTOM];
                [NSLayoutConstraint activateConstraints:@[
                                                          [self.bottomView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                          [self.bottomView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                                          [self.bottomView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                          self.bottomView_h,
                                                          ]];
                
                //
                _tagsView_show = NO;
                self.bottomView.tagsView.hidden = YES;
                self.bottomView.tagsView.alpha = 0.0;
            } break;
                
            case JXPhotosGeneralLayoutSelectionTypeSingle:
            {
                
            } break;
                
            default: break;
        }
    }
    return self;
}

- (void)setFullShow:(BOOL)fullShow animated:(BOOL)animated {
    _fullShow = fullShow;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.naviView.alpha = fullShow ? 0.0 : 1.0;
            self.bottomView.alpha = fullShow ? 0.0 : 1.0;
        } completion:nil];
    }
    else {
        self.naviView.alpha = fullShow ? 0.0 : 1.0;
        self.bottomView.alpha = fullShow ? 0.0 : 1.0;
    }
}

- (void)setTagsViewShow:(BOOL)show animated:(BOOL)animated {
    _tagsView_show = show;
    if (show) {
        self.bottomView.tagsView.hidden = NO;
        if (animated) {
            self.bottomView_h.constant = JXPhotosGeneralPreviewBottomViewTagsFixedHeight + JXPhotosGeneralBottomBarViewFixedHeight + JX_UNUSE_AREA_OF_BOTTOM;
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomView.tagsView.alpha = 1.0;
            } completion:^(BOOL finished) {
            }];
        }
        else {
            self.bottomView.tagsView.alpha = 1.0;
        }
    }
    else {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomView.tagsView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.bottomView.tagsView.hidden = YES;
                self.bottomView_h.constant = JXPhotosGeneralBottomBarViewFixedHeight + JX_UNUSE_AREA_OF_BOTTOM;
            }];
        }
        else {
            self.bottomView.tagsView.hidden = YES;
            self.bottomView.tagsView.alpha = 0.0;
            self.bottomView_h.constant = JXPhotosGeneralBottomBarViewFixedHeight + JX_UNUSE_AREA_OF_BOTTOM;
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated {
    _currentIndex = currentIndex;
    [self.collectionView setContentSize:CGSizeMake((self.jx_width + kInteritemSpace) * self.showingAssets.count, self.jx_height)];
    [self.collectionView setContentOffset:CGPointMake((self.jx_width + kInteritemSpace) * self.currentIndex, 0.0) animated:animated];
}

- (void)setShowingAssets:(NSArray<JXPhotosGeneralAsset *> *)showingAssets {
    _showingAssets = showingAssets;
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
    NSInteger pageNow = (xOffset + (self.jx_width + kInteritemSpace) * 0.5) / (self.jx_width + kInteritemSpace);
    
    if (pageNow != self.currentIndex && self.showingAssets && scrollView.isDragging) {
        self.currentIndex = pageNow;
        JX_BLOCK_EXEC(self.currentIndexChanged, self.currentIndex);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showingAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXPhotosGeneralAsset *asset = self.showingAssets[indexPath.item];
    JXPhotosGeneralPreviewViewCell *cell = COLLECTIONVIEW_DEQUEUE(kCellID);
    
    cell.dragChanged = self.dragChanged;
    cell.dragBegan = self.dragBegan;
    cell.dragEnded = self.dragEnded;
    cell.singleTapAction = self.singleTapAction;
    cell.didZoomOutAction = self.didZoomOutAction;
    
    cell.asset = asset;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

@end
