//
//  JXPhotosViewCell.h
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPhotosAsset.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosViewCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *thumbImageView; ///< 预览图

@property (nonatomic, readonly) __kindof JXPhotosAsset *asset; ///< 当前显示下载 asset
- (void)refreshUI:(__kindof JXPhotosAsset *)asset thumbImageSize:(CGSize)thumbImageSize; ///< 预览图像素大小, 子类想自定义刷新, 可以不用调用 super.

@end

NS_ASSUME_NONNULL_END
