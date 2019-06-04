//
//  JXHomeTagsViewItemCell.h
//  JXEfficient_Example
//
//  Created by augsun on 2/27/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXHomeTagsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXHomeTagsViewItemCell : UICollectionViewCell

+ (void)customForModel:(JXHomeTagsModel *)model inHeight:(CGFloat)inHeight;

@property (nonatomic, strong) JXHomeTagsModel *model;

@end

NS_ASSUME_NONNULL_END
