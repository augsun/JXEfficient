//
//  JXPhotosLayoutView.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosLayoutView.h"

#import "UICollectionView+JXCategory.h"
#import "UIView+JXCategory.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

#import "JXPhotosFlowLayout.h"

static const CGFloat k_lineSpacing_default = 2.0;
static const CGFloat k_interitemSpacing_default = 2.0;
static const UIEdgeInsets k_sectionInset_default = {0.0, 0.0, 0.0, 0.0};
static const CGSize k_expectItemSize_default = {60.0, 60.0};

static NSString *const kCellID = @"kCellID";

@interface JXPhotosLayoutView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) JXPhotosFlowLayout *layout;

@property (nonatomic, assign) BOOL didSetAssets;

@property (nonatomic, assign) CGSize showingItemSize;

@property (nonatomic, assign) NSInteger countPerRow;

@end

@implementation JXPhotosLayoutView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self JXPhotosView_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self JXPhotosView_moreInit];
    }
    return self;
}

- (void)JXPhotosView_moreInit {
    //
    self.lineSpacing = k_lineSpacing_default;
    self.interitemSpacing = k_interitemSpacing_default;
    self.sectionInset = k_sectionInset_default;
    self.expectItemSize = k_expectItemSize_default;
    self.rollToBottomForFirstTime = YES;
    
    //
    self.layout = [[JXPhotosFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[self.collectionView jx_con_edgeEqual:self]];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing >= 0.0) {
        _lineSpacing = lineSpacing;
        [self setNeedsLayout];
    }
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    if (interitemSpacing >= 0.0) {
        _interitemSpacing = interitemSpacing;
        [self setNeedsLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    _sectionInset = sectionInset;
    [self setNeedsLayout];
}

- (void)setExpectItemSize:(CGSize)expectItemSize {
    _expectItemSize = expectItemSize;
    self.showingItemSize = expectItemSize;
    [self setNeedsLayout];
}

- (void)setRollToBottomForFirstTime:(BOOL)rollToBottomForFirstTime {
    if (_rollToBottomForFirstTime != rollToBottomForFirstTime) {
        _rollToBottomForFirstTime = rollToBottomForFirstTime;
    }
}

- (void)setShowingItemSize:(CGSize)showingItemSize {
    _showingItemSize = showingItemSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.jx_width == 0.0 || self.jx_height == 0.0) {
        return;
    }
    
    [self JXPhotosView_resize];
    [self.layout invalidateLayout];
}

- (void)JXPhotosView_resize {
    CGFloat leftW =
    self.jx_width -
    self.collectionView.contentInset.left -
    self.collectionView.contentInset.right -
    self.sectionInset.left -
    self.sectionInset.right;
    
    NSInteger count_less = (leftW + self.interitemSpacing) / (self.interitemSpacing + self.expectItemSize.width);
    NSInteger count_more = count_less + 1;
    
    CGFloat w_less = (leftW - (count_less - 1) * self.interitemSpacing) / count_less;
    CGFloat w_more = (leftW - (count_more - 1) * self.interitemSpacing) / count_more;
    
    CGFloat fabs_less = fabs(w_less - self.expectItemSize.width);
    CGFloat fabs_more = fabs(w_more - self.expectItemSize.width);
    
    NSInteger countPerRow = 0;
    CGSize showingItemSize = CGSizeZero;
    if (fabs_less < fabs_more) {
        showingItemSize = CGSizeMake(w_less, w_less);
        countPerRow = count_less;
    }
    else {
        showingItemSize = CGSizeMake(w_more, w_more);
        countPerRow = count_more;
    }
    
    // 保证当前位置不偏移
    if (self.collectionView.contentOffset.y > 0 && self.collectionView.contentSize.height > self.collectionView.jx_height) {
        NSInteger row_previous = self.assets.count / self.countPerRow + (self.assets.count % self.countPerRow == 0 ? 0 : 1);
        CGFloat contentSize_height_previous = row_previous * (self.showingItemSize.height + self.lineSpacing) - self.lineSpacing;
        CGFloat per = self.collectionView.contentOffset.y / contentSize_height_previous;
        
        NSInteger row_now = self.assets.count / countPerRow + (self.assets.count % countPerRow == 0 ? 0 : 1);
        CGFloat contentSize_height_now = row_now * (showingItemSize.height + self.lineSpacing) - self.lineSpacing;
        
        CGFloat offsetY = per * contentSize_height_now;
        [self.collectionView setContentOffset:CGPointMake(0.0, offsetY)];
    }
    
    self.countPerRow = countPerRow;
    self.showingItemSize = showingItemSize;
}

- (void)setCellClass:(Class)cellClass {
    if ([cellClass isSubclassOfClass:[JXPhotosViewCell class]] && self.nibCellClass == nil) {
        _cellClass = cellClass;
    }
}

- (void)setNibCellClass:(Class)nibCellClass {
    if ([nibCellClass isSubclassOfClass:[JXPhotosViewCell class]] && self.cellClass == nil) {
        _nibCellClass = nibCellClass;
    }
}

- (void)setAssets:(NSArray<__kindof JXPhotosAsset *> *)assets {
    //
    [self layoutIfNeeded];
    
    _assets = [assets copy];
    
    //
    if (!self.didSetAssets) {
        if (self.cellClass) {
            [self.collectionView registerClass:self.cellClass forCellWithReuseIdentifier:kCellID];
        }
        else if (self.nibCellClass) {
            [self.collectionView jx_regCellNib:self.nibCellClass identifier:kCellID];
        }
        else {
            [self.collectionView registerClass:[JXPhotosViewCell class] forCellWithReuseIdentifier:kCellID];
        }
    }
    
    CGFloat rows = self.assets.count / self.countPerRow + (self.assets.count % self.countPerRow == 0 ? 0 : 1);
    CGFloat items_h = rows * (self.showingItemSize.height + self.lineSpacing) - self.lineSpacing;
    
    CGFloat contentOffset_y
    = items_h
    + self.collectionView.contentInset.top
    + self.collectionView.contentInset.bottom
    + self.sectionInset.top
    + self.sectionInset.bottom
    - self.collectionView.contentInset.top // collectionView 的 contentInset.top 值已经作为 负 contentOffset.y 的形式存在 再扣除<或直接不考虑>.
    - self.jx_height;

    if (contentOffset_y > 0.0) {
        CGFloat contentSize_h
        = items_h
        + self.sectionInset.top
        + self.sectionInset.bottom;
        
        [self.collectionView setContentSize:CGSizeMake(self.jx_width, contentSize_h)];
        [self.collectionView setContentOffset:CGPointMake(0.0, contentOffset_y) animated:NO];
        
#if DEBUG
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"DEBUG: contentSize_h = %lf, contentOffset_y = %lf", contentSize_h, contentOffset_y);
            NSLog(@"DEBUG: real contentSize = %@", NSStringFromCGSize(self.collectionView.contentSize));
        });
#endif
    }
    
    [self.collectionView reloadData];

    //
    self.didSetAssets = YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXPhotosAsset *asset = self.assets[indexPath.item];
    JXPhotosViewCell *cell = COLLECTIONVIEW_DEQUEUE(kCellID);
    JX_BLOCK_EXEC(self.refreshCellUsingBlock, cell, asset);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JXPhotosAsset *asset = self.assets[indexPath.item];
    JX_BLOCK_EXEC(self.didSelectItemAtIndex, indexPath.item, asset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.showingItemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.interitemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.sectionInset;
}

@end
