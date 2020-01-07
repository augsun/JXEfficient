//
//  JXTagsView.m
//  JXEfficient
//
//  Created by augsun on 2/25/19.
//

#import "JXTagsView.h"
#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "UICollectionView+JXCategory.h"
#import "UIView+JXCategory.h"

static NSString *const kCellID = @"kCellID";
static NSString *const kNibCellID = @"kNibCellID";

static const CGFloat kIndicatorFixedWidthDefalut = 20.0;
static const CGFloat kIndicatorHeightDefalut = 2.0;

static const CGFloat k_percentForForceZoomOutLayout_min = 0.0;
static const CGFloat k_percentForForceZoomOutLayout_max = 0.5;

@interface JXTagsView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bgView; ///< 无数据时一次性全部隐藏

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, copy) NSString *usingCellIdentifier; ///< 代码 还是 xib 注册情况下指定的 cell 标识

@property (nonatomic, strong) NSLayoutConstraint *indicatorView_w;
@property (nonatomic, strong) NSLayoutConstraint *indicatorView_h;
@property (nonatomic, strong) NSLayoutConstraint *indicatorView_toL;
@property (nonatomic, strong) NSLayoutConstraint *indicatorView_toB;

@property (nonatomic, assign) BOOL indicatorFixedWidth_didSetted; ///< 是否设置过 indicatorFixedWidth

@property (nonatomic, assign) CGFloat self_w_previous; ///< 上一次调用 layoutSubviews 的宽度

@property (nonatomic, assign) BOOL needHandle_jx_refreshUI_func; ///< 是否需要在 layoutSubviews 触发 jx_refreshUI 调用时条件不满足的后续执行
@property (nonatomic, assign) BOOL needHandle_jx_refreshUI_func_animated; ///< 当时需要后续执行的 参数<是否动画>
@property (nonatomic, assign) BOOL needHandle_jx_refreshUI_func_w; ///< 当时需要后续执行的 状态<宽度>

@property (nonatomic, strong) JXTagsViewTagModel *selectedModel;
@property (nonatomic, copy) NSArray <__kindof JXTagsViewTagModel *> *tagModels;

@property (nonatomic, assign) BOOL didRefreshIndicatorView; ///< 初始刷新不动画

@end

@implementation JXTagsView
@synthesize bottomLineView = _bottomLineView;

- (void)setIndicatorView:(UIView * _Nonnull)indicatorView {
    _indicatorView = indicatorView;
}

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

- (void)jx_moreInit {
    self.backgroundColor = [UIColor whiteColor];
    
    // bgView
    self.bgView = [[UIView alloc] init];
    [self addSubview:self.bgView];
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.bgView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                              [self.bgView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                              [self.bgView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                              [self.bgView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                              ]];
    self.bgView.backgroundColor = [UIColor clearColor];
    
    //
    _contentInset = UIEdgeInsetsZero;
    self.forRemainSpacingLayoutType = JXTagsViewForRemainSpacingLayoutTypeWeightedAverage;
    _indicatorFixedWidth = kIndicatorFixedWidthDefalut;
    self.tagSwitchAnimation = YES;
    
    // flowLayout
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 0.0;
    self.flowLayout.minimumInteritemSpacing = 0.0;
    
    // collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    [self.bgView addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.collectionView jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:0.0],
                                              [self.collectionView jx_con_same:NSLayoutAttributeLeft equal:self.bgView m:1.0 c:0.0],
                                              [self.collectionView jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:0.0],
                                              [self.collectionView jx_con_same:NSLayoutAttributeRight equal:self.bgView m:1.0 c:0.0],
                                              ]];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;

    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //
    self.indicatorView = [[UIView alloc] init];
    [self.bgView addSubview:self.indicatorView];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView_toL = [self.indicatorView jx_con_same:NSLayoutAttributeLeft equal:self.bgView m:1.0 c:0.0];
    self.indicatorView_toB = [self.indicatorView jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:0.0];
    self.indicatorView_w = [self.indicatorView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:20.0];
    self.indicatorView_h = [self.indicatorView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:5.0];
    [NSLayoutConstraint activateConstraints:@[self.indicatorView_toL,
                                              self.indicatorView_toB,
                                              self.indicatorView_w,
                                              self.indicatorView_h,
                                              ]];
    self.indicatorView.backgroundColor = [UIColor redColor];

    //
    self.indicatorView_h.constant = kIndicatorHeightDefalut;
    
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    self.collectionView.contentInset = contentInset;
    if (self.tagModels.count > 0) {
        [self reloadData];
    }
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    self.flowLayout.minimumLineSpacing = interitemSpacing;
    self.flowLayout.minimumInteritemSpacing = interitemSpacing;
    if (self.tagModels.count > 0) {
        [self reloadData];
    }
}

- (void)setIndicatorFixedWidth:(CGFloat)indicatorFixedWidth {
    if (indicatorFixedWidth > 0.0) {
        self.indicatorFixedWidth_didSetted = YES;
        _indicatorFixedWidth = indicatorFixedWidth;
    }
}

- (void)setIndicatorFixedHeight:(CGFloat)indicatorFixedHeight {
    if (indicatorFixedHeight > 0.0) {
        _indicatorFixedHeight = indicatorFixedHeight;
        self.indicatorView_h.constant = indicatorFixedHeight;
    }
}

- (void)setIndicatorToBottomSpacing:(CGFloat)indicatorToBottomSpacing {
    _indicatorToBottomSpacing = indicatorToBottomSpacing;
    self.indicatorView_toB.constant = -indicatorToBottomSpacing;
}

- (void)setTagCellClass:(Class)tagCellClass {
    if (tagCellClass == nil) {
        return;
    }
    NSAssert(self.usingCellIdentifier == nil, JX_ASSERT_MSG(@"已经设置 tagNibCellClass, tagCellClass 与 tagNibCellClass 不能同时设置"));
    NSAssert([tagCellClass isSubclassOfClass:[UICollectionViewCell class]], JX_ASSERT_MSG(@"tagCellClass 非 UICollectionViewCell 类型"));
    _tagCellClass = tagCellClass;
    self.usingCellIdentifier = kCellID;
    [self.collectionView registerClass:tagCellClass forCellWithReuseIdentifier:kCellID];
}

- (void)setTagNibCellClass:(Class)tagNibCellClass {
    if (tagNibCellClass == nil) {
        return;
    }
    NSAssert(self.usingCellIdentifier == nil, JX_ASSERT_MSG(@"已经设置 tagCellClass, tagCellClass 与 tagNibCellClass 不能同时设置"));
    NSAssert([tagNibCellClass isSubclassOfClass:[UICollectionViewCell class]], JX_ASSERT_MSG(@"tagNibCellClass 非 UICollectionViewCell 类型"));
    _tagNibCellClass = tagNibCellClass;
    self.usingCellIdentifier = kNibCellID;
    [self.collectionView jx_regCellNib:tagNibCellClass identifier:kNibCellID];
}

- (void)selectTagIndex:(NSInteger)tagIndex animated:(BOOL)animated {
    if (tagIndex >= 0 && tagIndex < self.tagModels.count) {
//        NSInteger tagIndex_previous = self.tagIndex; // m2 使用
        
        self.selectedModel.selected = NO;
        self.tagModels[tagIndex].selected = YES;
        self.selectedModel = self.tagModels[tagIndex];
        _tagIndex = tagIndex;
        
        // 已布局好
        if (self.jx_width > 0.0) {
            self.needHandle_jx_refreshUI_func = NO;
            
            // 以下 m1 m2, 目前先使用 m1
            // m1
            [self.collectionView reloadData];

            // m2
//            NSMutableArray <NSIndexPath *> *tempArr = nil;
//            if (tagIndex_previous >= 0 && tagIndex_previous < self.tagModels.count) {
//                tempArr = [[NSMutableArray alloc] init];
//                [tempArr addObject:[NSIndexPath indexPathForItem:tagIndex_previous inSection:0]];
//            }
//            if (tagIndex >= 0 && tagIndex < self.tagModels.count) {
//                if (!tempArr) {
//                    tempArr = [[NSMutableArray alloc] init];
//                }
//                [tempArr addObject:[NSIndexPath indexPathForItem:tagIndex inSection:0]];
//            }
//            if (tempArr.count > 0) {
//                [self.collectionView reloadItemsAtIndexPaths:tempArr];
//            }
            
            //
            [self jx_refreshUI_collectionView_contentOffset:animated];
            [self jx_refreshUI_indicator_LW:animated];
        }
        // 未布局好 <进行标记, 于 layoutSubviews 中进行处理>
        else {
            self.needHandle_jx_refreshUI_func = YES;
            self.needHandle_jx_refreshUI_func_animated = animated;
            self.needHandle_jx_refreshUI_func_w = self.jx_width;
        }

        //
        [self tagIndexDidChanged:tagIndex];
    }
}

- (void)setPercentForForceZoomOutLayout:(CGFloat)percentForForceZoomOutLayout {
    if (percentForForceZoomOutLayout >= k_percentForForceZoomOutLayout_min && k_percentForForceZoomOutLayout_min <= k_percentForForceZoomOutLayout_max) {
        _percentForForceZoomOutLayout = percentForForceZoomOutLayout;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 当前宽度
    CGFloat now_self_w = self.jx_width;
    
    // 宽度不同需要重新布局
    if (now_self_w > 0 && self.self_w_previous != now_self_w) {
        
        BOOL animated = YES;
        
        // 有未处理的 jx_refreshUI 方法调用
        if (self.needHandle_jx_refreshUI_func) {
            // 未处理时的 宽度 与 当前宽度 是否相同, 不相同则重新计算
            if (self.needHandle_jx_refreshUI_func_w != now_self_w) {
                [self jx_prepareDataForShowing];
            }
            animated = self.needHandle_jx_refreshUI_func_animated;
        }
        else {
            [self jx_prepareDataForShowing];
            animated = YES;
        }
        
        // 刷新数据
        [self.collectionView reloadData];
        
        // 刷新偏移
        [self jx_refreshUI_collectionView_contentOffset:animated];
        
        // 刷新指示器
        [self jx_refreshUI_indicator_LW:animated];
    }
    
    //
    self.self_w_previous = now_self_w;
}

/**
 1,重新计算显示数据
 2,重新选中 tagIndex
 3,刷新 UI
 */
- (void)reloadData {
    NSAssert(self.tagCellClass != nil || self.tagNibCellClass != nil, JX_ASSERT_MSG(@"tagCellClass 或 tagNibCellClass 未指定"));

    if (self.tagModelsForReloadData) {
        self.tagModels = self.tagModelsForReloadData();
    }
    
    if (self.tagModels.count == 0) {
        self.bgView.hidden = YES;
        return;
    }
    else {
        self.bgView.hidden = NO;
    }
    
    __block BOOL allAreRightModels = YES;
    __block NSInteger tagIndex = -1;
    [self.tagModels enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(__kindof JXTagsViewTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(obj.tagWidth > 0.0, JX_ASSERT_MSG(@"tagWidth 必须设置 且不能 <= 0.0"));
        if (obj.selected) {
            tagIndex = idx;
        }
        if (![obj isKindOfClass:[JXTagsViewTagModel class]]) {
            *stop = YES;
            allAreRightModels = NO;
        }
    }];
    NSAssert(allAreRightModels, JX_ASSERT_MSG(@"tagModelsForReloadData 返回数组里有非 JXTagsViewTagModel 类型对象"));

    if (tagIndex == -1) {
        tagIndex = 0;
        self.selectedModel = self.tagModels.firstObject;
        self.tagModels.firstObject.selected = YES;
    }
    
    //
    [self jx_prepareDataForShowing];
    
    //
    [self selectTagIndex:tagIndex animated:NO];
}

/**
 只计算布局, 跟 tagIndex 无关.
 */
- (void)jx_prepareDataForShowing {
    CGFloat selfWidth = self.jx_width;
    if (selfWidth == 0.0) {
        return;
    }
    
    //
    CGFloat coll_edgeL = self.contentInset.left;
    CGFloat coll_edgeR = self.contentInset.right;
    CGFloat interitemSpacing = self.interitemSpacing;
    
    //
    CGFloat item_totalWidth = 0.0;
    CGFloat totalWidth = 0.0;
    
    for (JXTagsViewTagModel *modelEnum in self.tagModels) {
        item_totalWidth += modelEnum.tagWidth;
    }
    CGFloat otherSpacing = coll_edgeL + coll_edgeR + (self.tagModels.count - 1) * interitemSpacing;
    totalWidth = item_totalWidth + otherSpacing;
    
    // 确定 indicatorWidth_showing 的 block
    void (^indicatorWidth_showing)(JXTagsViewTagModel *) = ^(JXTagsViewTagModel *model) {
        if (self.indicatorFixedWidth_didSetted) {
            model.indicatorWidth_showing = self.indicatorFixedWidth;
        }
        else {
            model.indicatorWidth_showing = model.indicatorWidth == 0.0 ? kIndicatorFixedWidthDefalut : model.indicatorWidth;
        }
        model.indicatorWidth_showing = model.indicatorWidth_showing > model.tagWidth_showing ? model.tagWidth_showing : model.indicatorWidth_showing;
    };
    
    //
    CGFloat tag_toL = coll_edgeL;
    
    // 非原始布局 && 不足宽度情况 <使用对应的增量布局样式>
    if (self.forRemainSpacingLayoutType != JXTagsViewForRemainSpacingLayoutTypeDoNothing && totalWidth < selfWidth) {
        CGFloat remainWidth = selfWidth - totalWidth;
        
        CGFloat itemCount = self.tagModels.count;
        
        CGFloat weightedAverage_unit = 1.0 / item_totalWidth * remainWidth;
        CGFloat average_unit = remainWidth / itemCount;
        CGFloat divideEqually_unit = (item_totalWidth + remainWidth) / itemCount;
        
        for (JXTagsViewTagModel *modelEnum in self.tagModels) {
            CGFloat tagWidth = modelEnum.tagWidth;
            switch (self.forRemainSpacingLayoutType) {
                case JXTagsViewForRemainSpacingLayoutTypeWeightedAverage:
                {
                    modelEnum.tagWidth_showing = tagWidth + tagWidth * weightedAverage_unit;
                } break;
                    
                case JXTagsViewForRemainSpacingLayoutTypeAverage:
                {
                    modelEnum.tagWidth_showing = tagWidth + average_unit;
                } break;
                    
                case JXTagsViewForRemainSpacingLayoutTypeDivideEqually:
                {
                    modelEnum.tagWidth_showing = divideEqually_unit;
                } break;
                    
                default: break;
            }
            modelEnum.tag_toL = tag_toL;
            modelEnum.center_x = tag_toL + modelEnum.tagWidth_showing / 2.0;
            tag_toL += modelEnum.tagWidth_showing + interitemSpacing;
            
            //
            indicatorWidth_showing(modelEnum);
        }
    }
    
    // 需要压缩布局 && 大于宽度情况 && 超出需要压缩布局百分比 <使用加权压缩布局>
    else if (self.forceZoomOutLayoutWhenBeyondSpacingUsingWeightedAverage && totalWidth > selfWidth && totalWidth <= (1.0 + self.percentForForceZoomOutLayout) * selfWidth) {
        CGFloat remainWidth = selfWidth - totalWidth;
        CGFloat weightedAverageUnit = 1.0 / item_totalWidth * remainWidth;
        
        for (JXTagsViewTagModel *modelEnum in self.tagModels) {
            CGFloat tagWidth = modelEnum.tagWidth;
            modelEnum.tagWidth_showing = tagWidth + tagWidth * weightedAverageUnit;
            modelEnum.tag_toL = tag_toL;
            modelEnum.center_x = tag_toL + modelEnum.tagWidth_showing / 2.0;
            tag_toL += modelEnum.tagWidth_showing + interitemSpacing;
            
            //
            indicatorWidth_showing(modelEnum);
        }
    }
    // 非以上两种情况按原始布局
    else {
        for (JXTagsViewTagModel *modelEnum in self.tagModels) {
            CGFloat tagWidth = modelEnum.tagWidth;
            modelEnum.tagWidth_showing = tagWidth;
            modelEnum.tag_toL = tag_toL;
            modelEnum.center_x = tag_toL + modelEnum.tagWidth_showing / 2.0;
            tag_toL += modelEnum.tagWidth_showing + interitemSpacing;
            
            //
            indicatorWidth_showing(modelEnum);
        }
    }
}

- (void)jx_refreshUI_collectionView_contentOffset:(BOOL)animated {
    if (self.tagModels.count > 0) {
        JXTagsViewTagModel *tagModel = self.tagModels[self.tagIndex];
        
        //
        CGFloat coll_edgeL = self.contentInset.left;
        CGFloat coll_edgeR = self.contentInset.right;
        
        // 确定是否需要偏移
        CGFloat total_w = self.tagModels.lastObject.tag_toL + self.tagModels.lastObject.tagWidth_showing + coll_edgeR;
        CGFloat self_w = self.jx_width;
        CGFloat half_self_w = self_w / 2.0;
        
        CGFloat center_x = tagModel.center_x;
        CGFloat center_toL = center_x;
        CGFloat center_toR = total_w - center_toL;
        
        CGFloat contentOffset_x = 0.0;
        if (center_toL > half_self_w && center_toR > half_self_w)   { contentOffset_x = center_x - half_self_w; }
        else if (center_toL < half_self_w)                          { contentOffset_x = 0.0; }
        else if (center_toR < half_self_w)                          { contentOffset_x = total_w - self_w; }
        
        if (contentOffset_x >= 0.0) {
            [self.collectionView setContentOffset:CGPointMake(contentOffset_x - coll_edgeL, 0.0) animated:animated];
        }
    }
    else {
        
    }
}

/**
 刷新 indicatorView 的 L W 约束
 */
- (void)jx_refreshUI_indicator_LW:(BOOL)animation {
    if (self.tagModels.count > 0) {
        JXTagsViewTagModel *tagModel = self.tagModels[self.tagIndex];
        
        CGFloat coll_edgeL = self.contentInset.left;
        
        CGFloat indicator_x_in_collectionView = tagModel.center_x - tagModel.indicatorWidth_showing / 2.0;
        CGFloat indicator_x_in_self = indicator_x_in_collectionView - self.collectionView.contentOffset.x - coll_edgeL;
        
        if (animation && self.didRefreshIndicatorView) {
            [self layoutIfNeeded];
            self.indicatorView_toL.constant = indicator_x_in_self;
            self.indicatorView_w.constant = tagModel.indicatorWidth_showing;
            [UIView animateWithDuration:0.25 animations:^{
                [self layoutIfNeeded];
            }];
        }
        else {
            self.indicatorView_toL.constant = indicator_x_in_self;
            self.indicatorView_w.constant = tagModel.indicatorWidth_showing;
        }
        
        //
        self.didRefreshIndicatorView = YES;
    }
    else {
        
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self jx_refreshUI_indicator_LW:NO];
}

#pragma mark - <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = COLLECTIONVIEW_DEQUEUE(self.usingCellIdentifier);
    JX_BLOCK_EXEC(self.tagCellForIndex, cell, indexPath.item);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tagIndex = indexPath.item;
    [self selectTagIndex:tagIndex animated:self.tagSwitchAnimation];
    JX_BLOCK_EXEC(self.didSelectTagAtIndex, self.tagIndex);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXTagsViewTagModel *model = self.tagModels[indexPath.item];
    CGSize size = CGSizeMake(model.tagWidth_showing, self.jx_height);
    return size;
}

- (void)tagIndexDidChanged:(NSInteger)tagIndex {
    
}

- (void)scrollingPage:(CGFloat)scrollingPage {
    if (self.tagModels.count > 0) {
        NSInteger page1 = floor(scrollingPage);
        NSInteger page2 = page1 + 1;
        
        CGFloat percent1 = page2 - scrollingPage;
        CGFloat percent2 = 1 - percent1;
        
        JXTagsViewTagModel *model1 = nil;
        JXTagsViewTagModel *model2 = nil;
        
        if (page1 < self.tagModels.count) {
            model1 = self.tagModels[page1];
        }
        if (page2 < self.tagModels.count) {
            model2 = self.tagModels[page2];
        }
        
        // 边界处理
        if (!model1) {
            percent2 = 1.0;
        }
        if (!model2) {
            percent1 = 1.0;
        }
        
        JX_BLOCK_EXEC(model1.zoomPercent, percent1);
        JX_BLOCK_EXEC(model2.zoomPercent, percent2);
    }
}

@end
