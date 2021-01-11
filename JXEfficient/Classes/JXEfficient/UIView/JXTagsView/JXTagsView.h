//
//  JXTagsView.h
//  JXEfficient
//
//  Created by augsun on 2/25/19.
//

#import <UIKit/UIKit.h>
#import <JXTagsViewTagModel.h>

NS_ASSUME_NONNULL_BEGIN

/**
 当所有 tags 及 contentInset.left 及 contentInset.right 及 interitemSpacing 的宽度加起来小于 tagsView 的宽度的时候, 所决定的布局样式.
 即剩下的宽度会根据该类型的布局样式 向 tags 里增加 或 减少, 直至所有宽度达到 tagsView 宽度.
 */
typedef NS_ENUM(NSUInteger, JXTagsViewForRemainSpacingLayoutType) {
    JXTagsViewForRemainSpacingLayoutTypeDoNothing = 0,          ///< 不作处理: 按实际宽度布局
    JXTagsViewForRemainSpacingLayoutTypeWeightedAverage = 1,    ///< 加权: 每个 tag 根据原有的 tagWidth 权重加
    JXTagsViewForRemainSpacingLayoutTypeAverage,                ///< 不加权: 每个 tag 等量加
    JXTagsViewForRemainSpacingLayoutTypeDivideEqually,          ///< 平分: 每个 tag 宽度一样, 该布局类型可能会导致比原来的 tagWidth 还小
};

/**
 用以加载分 tag 页面的顶部条, 类似于头条类 APP 顶部的 [热点 娱乐 军事 ... 等].
 1,该类可以自动加权计算布局每个 tag 的宽度.
 2,该类可以自动计算回正, 即自动滚动当前选中的 tag 至 tagsView 中间.
 3,该类封装了自定义 tagCell, 上层根据需要自行封装自定义 tagCell.
 4,该类主要封装了内部布局的计算, 只要设置 JXTagsViewTagModel 里的 tagWidth 值即可.
 */
@interface JXTagsView : UIView

/* ============================== 边距 及 间距 ==============================*/
@property (nonatomic, assign) UIEdgeInsets contentInset; ///< 内部 collectionView 的 contentInset, 默认 [0, 0, 0, 0]
@property (nonatomic, assign) CGFloat interitemSpacing; ///< 内部 collectionView 的 layout 的 interitemSpacing, 默认 0pt

/* ============================== 指示器 ============================== */
@property (nonatomic, readonly) UIView *indicatorView;              ///< 指示器, 外部可以设置其(圆角 颜色 等), 默认没有圆角, 颜色 [UIColor redColor]
@property (nonatomic, assign) CGFloat indicatorFixedWidth;          ///< 指示器固定宽度, 不设置则优先读取 JXTagsViewTagModel 的 indicatorWidth 属性值, 默认 20pt
@property (nonatomic, assign) CGFloat indicatorFixedHeight;         ///< 指示器固定高度, 默认 2pt
@property (nonatomic, assign) CGFloat indicatorToBottomSpacing;     ///< 指示器距离底部的距离, 默认 0pt

/* ============================== cell 类型 ============================== */
@property (nonatomic, strong) Class tagCellClass; ///< 代码 tagCell 类型<UICollectionViewCell 子类>, <与 tagNibCellClass 谁优先设置后, 另一设置无效>
@property (nonatomic, strong) Class tagNibCellClass; ///< xib tagCell 类型<UICollectionViewCell 子类>, <与 tagCellClass 谁优先设置后, 另一设置无效>

@property (nonatomic, assign) BOOL tagSwitchAnimation; ///< 切换 tag 是否动画, 默认 YES
@property (nonatomic, readonly) UIView *bottomLineView; ///< 底部线 默认隐藏, 默认颜色 0xDEDEDE, 默认高度为 1px.

/**
 拉伸布局类型, 总宽度小于 tagsView 的情况(即有剩余空间的情况)会进行该类型的布局, 默认 JXTagsViewLayoutTypeWeightedAverage 加权拉伸.
 
 @warning 加权只对各个 tags 的宽度加权, 边距间距不参与加权.
 */
@property (nonatomic, assign) JXTagsViewForRemainSpacingLayoutType forRemainSpacingLayoutType;

/**
 超出 tagsView 的宽度百分比小于 dpercentForForceZoomOut 情况下的强制压缩布局<使用加权压缩布局>, 默认 NO
 
 @discussion 建议在可确定的宽度情况下, 不希望超出一点点而导致左右滚动的情况, 可以进行略微压缩以达到布局宽度正好等于 tagsView 的宽度
 @warning 如果超出 tagsView 的宽度百分比超出 percentForForceZoomOut, 则无法进行强制布局. 加权只对各个 tags 的宽度加权, 边距间距不参与加权.
 */
@property (nonatomic, assign) BOOL forceZoomOutLayoutWhenBeyondSpacingUsingWeightedAverage;
@property (nonatomic, assign) CGFloat percentForForceZoomOutLayout; ///< 强制压缩布局情况下的最大超出范围百分比. 取值 [0.0, 0.5], 超过 0.5 再强制布局, 会严重导致各 tag 宽度压缩, 不符合日常使用. 默认 0.3.

@property (nonatomic, readonly) NSInteger tagIndex; ///< 当前选中的 tagIndex

/**
 选中指定 tag
 
 @param tagIndex 要选中的 tag
 @param animated 是否动画
 */
- (void)selectTagIndex:(NSInteger)tagIndex animated:(BOOL)animated;

/**
 刷新 tagCell 回调
 
 @discusstion 回调的 tagCell 类型为使用者自行设置的 tagCellClass 或 tagNibCellClass 类型, 外部需考虑该 tagCell 为复用.
 */
@property (nonatomic, copy) void (^tagCellForIndex)(__kindof UICollectionViewCell *tagCell, NSInteger tagIndex);

/**
 点击 tag 回调
 
 @discusstion 只有手动点击才会回调. 外部设置 tagModels 不会触发回调.
 */
@property (nonatomic, copy) void (^didSelectTagAtIndex)(NSInteger tagIndex);

@property (nonatomic, copy) NSArray <__kindof JXTagsViewTagModel *> * _Nullable (^tagModelsForReloadData)(void); ///< 获取数据源

- (void)reloadData; /// <刷新数据

- (void)tagIndexDidChanged:(NSInteger)tagIndex NS_REQUIRES_SUPER; ///< tagIndex 改变回调, 包括初次刷新. 子类重写, 不允许直接调用.

- (void)scrollingPage:(CGFloat)scrollingPage; ///< 外部设置, 设置 JXPagingView 等滚动时的动态页<以实现两个 tag 之前的渐变过程>

@end

NS_ASSUME_NONNULL_END
