//
//  JXFlowViewLayout.h
//  JXEfficient
//
//  Created by augsun on 9/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 整个布局类似一个 UICollectionView 的 section 布局, 其 item 的高度固定 宽度不定
 */
@interface JXFlowViewLayout : NSObject

@property (nonatomic, assign) CGFloat kEdgeT; ///< 整个布局范围的 上边距 <类似 UICollectionView 的 layout 的 sectionInset>
@property (nonatomic, assign) CGFloat kEdgeL; ///< 整个布局范围的 左边距 <类似 UICollectionView 的 layout 的 sectionInset>
@property (nonatomic, assign) CGFloat kEdgeB; ///< 整个布局范围的 下边距 <类似 UICollectionView 的 layout 的 sectionInset>
@property (nonatomic, assign) CGFloat kEdgeR; ///< 整个布局范围的 右边距 <类似 UICollectionView 的 layout 的 sectionInset>

@property (nonatomic, assign) CGFloat kLineGap; ///< 行间距 (上下间距)
@property (nonatomic, assign) CGFloat kInterGap; ///< 竖间距 (左右间距)

@property (nonatomic, assign) CGFloat kTitleToL; ///< 每个 item 标题距 item 左边距
@property (nonatomic, assign) CGFloat kTitleToR; ///< 每个 item 标题距 item 右边距

@property (nonatomic, assign) UIFont *titleFont; ///< 每个 item 标题 字体

@property (nonatomic, assign) CGFloat itemHeight; ///< 每个 item 高
@property (nonatomic, assign) CGFloat inWidth; ///< 在多宽范围内布局

@property (nonatomic, assign) CGFloat itemMaxWidth; ///< item 的最大宽度

@end

NS_ASSUME_NONNULL_END
