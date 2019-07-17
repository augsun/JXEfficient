//
//  JXNavigationBar.h
//  JXEfficient
//
//  Created by augsun on 3/5/19.
//

#import <UIKit/UIKit.h>
#import "JXNavigationBarItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 JXNavigationBar 的布局如下:
       返回按钮           左边按钮           标题              右边子按钮            右边按钮
 < -- backItem -- | -- leftItem-- | -- titleItem -- | -- subRightItem -- | -- rightItem -- >
 
 @discussion 其内部各 抗压优先级为 [back > right > left > subRight > title], 即优先级高的最后被压缩<理解为硬度最高>.
 */
@interface JXNavigationBar : UIView

@property (nonatomic, readonly) UIImageView *backgroundImageView; ///< 背景图片

@property (nonatomic, readonly) JXNavigationBarItem *backItem; ///< 返回按钮
@property (nonatomic, readonly) JXNavigationBarItem *leftItem; ///< 左边按钮

@property (nonatomic, readonly) JXNavigationBarItem *titleItem; ///< 标题

@property (nonatomic, readonly) JXNavigationBarItem *rightItem; ///< 右边按钮
@property (nonatomic, readonly) JXNavigationBarItem *subRightItem; ///< 右边子按钮, 如果 rightItem 没设置, subRightItem 则向右布局.

@property (nonatomic, assign) CGFloat leftSpacing; ///< 最左边一个 item 距离 JXNavigationBar 的左边距离, >= 0.0. 默认 4pt
@property (nonatomic, assign) CGFloat rightSpacing; ///< 最右边一个 item 距离 JXNavigationBar 的右边距离, >= 0.0. 默认 4pt
@property (nonatomic, assign) CGFloat interitemSpacing; /// < 内部每个 itemView 的间距, >= 0.0. 默认 4pt
@property (nonatomic, readonly) UIView *bottomLineView; ///< 底部线 默认隐藏, 默认颜色 0xDEDEDE, 默认高度为 1px.
@property (nonatomic, assign) BOOL translucent; ///< 模糊效果, 默认 NO, 为 YES 时, 设置 backgroundImageView.image 或 backGroundColor 无效

@end

NS_ASSUME_NONNULL_END
