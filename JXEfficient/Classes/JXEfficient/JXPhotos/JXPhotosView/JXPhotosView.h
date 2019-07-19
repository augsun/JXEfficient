//
//  JXPhotosView.h
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPhotosViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosView : UIView

@property (nonatomic, strong) Class cellClass; ///< 必须 JXPhotosViewCell 或其子类, <与 nibCellClass 谁优先设置后, 另一设置无效, 设置 assets 后设置无效>, 默认 JXPhotosViewCell.
@property (nonatomic, strong) Class nibCellClass; ///< 必须 JXPhotosViewCell 或其子类, <与 cellClass 谁优先设置后, 另一设置无效, 设置 assets 后设置无效>, 默认 nil

@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat lineSpacing; ///< 行间距
@property (nonatomic, assign) CGFloat interitemSpacing; ///< 列间距
@property (nonatomic, assign) UIEdgeInsets sectionInset; ///< section 四边距 <由于只有一个 section, 设置 collectionView 的 contentInset 也可以.>
@property (nonatomic, assign) CGSize expectItemSize; ///< 期望 item 的大小. 默认 60.0, 在屏幕旋转及 JXPhotosView 的大小改变的时候会先(保证 lineSpacing, interitemSpacing, sectionInset 不变化的情况下)进行布局微调

@property (nonatomic, assign) BOOL rollToBottomForFirstTime; ///< 初次刷新滚动于底部[最近的图片在于列表底部], 默认 YES. 在设置 assets 后再设置无效, 且其效果只执行一次.
@property (nonatomic, copy) NSArray <__kindof JXPhotosAsset *> *assets; ///< 获取的图片
@property (nonatomic, copy) void (^didSelectItemAtIndex)(NSInteger index, __kindof JXPhotosAsset *asset); ///< 图片点击回调

@property (nonatomic, copy) void (^refreshCellUsingBlock)(__kindof JXPhotosViewCell *cell, __kindof JXPhotosAsset *asset); ///< 上层用于刷新 Cell <自定义 JXPhotosViewCell 子类>

@end

NS_ASSUME_NONNULL_END
