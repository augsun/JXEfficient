//
//  JXPhotosGeneralLayoutVC.h
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralBaseVC.h"
#import "JXPhotosGeneralAlbumAssetCollection.h"

#import "JXPhotosGeneralUsage.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosGeneralLayoutVC : JXPhotosGeneralBaseVC

@property (nonatomic, assign) JXPhotosGeneralUsage *usage;

@property (nonatomic, copy) void (^cancelClick)(void); ///< 取消点击

@property (nonatomic, strong) JXPhotosGeneralAlbumAssetCollection *assetCollection; ///< 从相册列表进入时传入

@property (nonatomic, copy) void (^fetchCaneralRollImageAssetForFirstPageToCaneralRollType)(void (^completion)(NSArray <JXPhotosGeneralAsset *> *assets)); ///< 当 usage 的 firstPageTo 为 PhotosFirstPageToCaneralRoll 时, 相册列表不会先加载数据, 而是立即<用户无感知>进入 PhotosLayoutVC 列表再回调相册列表请求需要的数据.

@end

NS_ASSUME_NONNULL_END
