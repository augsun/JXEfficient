//
//  JXPhotosGeneralPreviewBottomTagsView.m
//  JXEfficient
//
//  Created by augsun on 7/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralPreviewBottomTagsView.h"

#import "UICollectionView+JXCategory.h"
#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

#import "JXPhotosGeneralPreviewBottomTagCell.h"

static const CGFloat k_minimumLineSpacing_default = 15.0;
static const CGSize k_itemSize_default = {60.0, 60.0};
static const UIEdgeInsets k_contentInset_default = {10.0, 15.0, 10.0, 15.0};

static NSString *const kCellID = @"kCellID";

@interface JXPhotosGeneralPreviewBottomTagsView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation JXPhotosGeneralPreviewBottomTagsView

- (instancetype)init {
    self = [super init];
    if (self) {
        // flowLayout
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout.minimumLineSpacing = k_minimumLineSpacing_default;
        self.flowLayout.itemSize = k_itemSize_default;
        
        // collectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [self addSubview:self.collectionView];
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.collectionView jx_con_edgeEqual:self]];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.scrollsToTop = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.contentInset = k_contentInset_default;
        [self.collectionView registerClass:[JXPhotosGeneralPreviewBottomTagCell class] forCellWithReuseIdentifier:kCellID];
        
        // bottomLineView
        self.bottomLineView = [[UIView alloc] init];
        [self addSubview:self.bottomLineView];
        self.bottomLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.bottomLineView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.bottomLineView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                                  [self.bottomLineView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [self.bottomLineView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_SCREEN_ONE_PIX],
                                                  ]];
        self.bottomLineView.backgroundColor = [JX_COLOR_GRAY(100) colorWithAlphaComponent:0.5];
    }
    return self;
}

- (void)setTagModels:(NSArray<JXPhotosGeneralPreviewBottomTagModel *> *)tagModels {
    _tagModels = tagModels;
    
    [self.collectionView reloadData];
}

- (void)scrollTagIndexToCenter:(NSInteger)tagIndex animated:(BOOL)animated  {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:tagIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:animated];
}

#pragma mark - <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXPhotosGeneralPreviewBottomTagCell *cell = COLLECTIONVIEW_DEQUEUE(kCellID);
    cell.model = self.tagModels[indexPath.item];
    cell.backgroundColor = JX_COLOR_RANDOM;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JX_BLOCK_EXEC(self.didSelectTagAtIndex, indexPath.item, self.tagModels[indexPath.item]);
}

@end
