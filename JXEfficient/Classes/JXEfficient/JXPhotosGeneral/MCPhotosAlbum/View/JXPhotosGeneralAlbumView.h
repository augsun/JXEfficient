//
//  JXPhotosGeneralAlbumView.h
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXNavigationBar.h"

#import "JXPhotosGeneralAlbumAssetCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosGeneralAlbumView : UIView

@property (nonatomic, readonly) JXNavigationBar *naviBar;
@property (nonatomic, copy) NSArray <JXPhotosGeneralAlbumAssetCollection *> *assetCollections;
@property (nonatomic, copy) void (^didSelectAssetCollection)(JXPhotosGeneralAlbumAssetCollection *assetCollection);

@end

NS_ASSUME_NONNULL_END
