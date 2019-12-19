//
//  JXPhotosGeneralPreviewViewCell.h
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPhotosGeneralAsset.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat JXPhotosGeneralPreviewImageViewAnimationDuration;

@interface JXPhotosGeneralPreviewViewCell : UICollectionViewCell

@property (nonatomic, strong) JXPhotosGeneralAsset *asset;

@property (nonatomic, copy) void (^dragChanged)(CGFloat percent, BOOL needAnimation); ///< percent 为偏移百分比
@property (nonatomic, copy) void (^dragBegan)(void);
@property (nonatomic, copy) void (^dragEnded)(BOOL forHidden);
@property (nonatomic, copy) void (^singleTapAction)(void);
@property (nonatomic, copy) void (^didZoomOutAction)(void);

@end

NS_ASSUME_NONNULL_END
