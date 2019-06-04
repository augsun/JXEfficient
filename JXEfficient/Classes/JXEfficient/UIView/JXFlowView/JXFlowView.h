//
//  JXFlowView.h
//  JXEfficient
//
//  Created by augsun on 9/10/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXFlowViewLayout.h"
#import "JXFlowViewItemModel.h"
#import "JXFlowViewItemView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 主要用在对一组字符串数组进行不等宽的行列布局, 其 itemView 可以自定义<继承自 JXFlowViewItemView>, 其数据源模型<继承自 JXFlowViewItemModel>.
 对于数据源改变的情况<即数组个数变化或字符串长度变化带来的布局变化, 请重新生成行列存放的数据源>, 或可以用 JXTagFlowLayout<基于 UICollectionView> 进行布局.
 该类的优点是根据数据源能预先知道布局后的高度, 以方便上层父视图的布局, 而 JXTagFlowLayout 可以随时变化数据源随时刷新, 但不支持预先知道布局后的高度.
 */
@interface JXFlowView : UIView

+ (instancetype)flowView; ///< 指定初始化器

/**
 在布局样式 layout 下行列化获取数据源

 @param strings 要计算的字符串数组
 @param layout 要布局的 layout 样式
 @return 返回行列化后存放的 二维数组, 返回的 JXFlowViewItemModel 实例, 不能再修改 itemWidth 属性, 否则会导致字符串显示不全.
 */
+ (nullable NSArray <NSArray <JXFlowViewItemModel *> *> *)itemModelsFromStrings:(NSArray <NSString *> *)strings withLayout:(JXFlowViewLayout *)layout;

/**
 在布局样式 layout 计算行列后的总高度

 @param itemModels 要计算的数据源
 @param layout 要布局的 layout 样式
 @return 返回将来在 layout 布局样式下的总高度
 */
+ (CGFloat)heightForItemModels:(NSArray <NSArray <JXFlowViewItemModel *> *> *)itemModels withLayout:(JXFlowViewLayout *)layout;

@property (nonatomic, strong) Class itemNibClass; ///< 必须继承自 JXFlowViewItemView, 且必须是 xib
@property (nonatomic, strong) JXFlowViewLayout *layout; ///< 样式布局, 指定后无法再赋值修改

@property (nonatomic, copy) NSArray <NSArray <JXFlowViewItemModel *> *> *itemModels; ///< 生成好的展示数据源, 可进行 reloadData 功能.

@property (nonatomic, copy) void (^itemViewForIndex)(__kindof JXFlowViewItemView *itemView, NSInteger index); ///< 回调进行赋值刷新

@property (nonatomic, copy) void (^didTapItemAtIndex)(NSInteger index); ///< 点击事件

@end

NS_ASSUME_NONNULL_END

















