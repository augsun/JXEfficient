//
//  JXPhotosViewCell.h
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosViewCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *thumbImageView; ///< 预览图

- (void)refreshUI:(__kindof JXAsset *)asset; ///< 子类想自定义刷新, 可以不用调用 [super refreshUI];

@end

NS_ASSUME_NONNULL_END
