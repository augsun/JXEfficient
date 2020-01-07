//
//  JXPhotosGeneralViewAlbumCell.h
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPhotosGeneralAlbumAssetCollection.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGSize JXPhotosGeneralViewAlbumCellThumbImageViewSize;

@interface JXPhotosGeneralAlbumViewCell : UITableViewCell

@property (nonatomic, strong) JXPhotosGeneralAlbumAssetCollection *assetCollection;

@end

NS_ASSUME_NONNULL_END
