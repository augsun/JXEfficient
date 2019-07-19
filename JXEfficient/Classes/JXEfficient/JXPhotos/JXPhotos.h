//
//  JXPhotos.h
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPhotosAssetCollection.h"
#import "JXPhotosAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotos : NSObject

/**
 相册授权获取

 @param handler 回调<主线程>
 */
+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;

/**
 获取图片资源集合

 @param fetchOptions 获取配置
 @param imageRequestOptions 请求图片配置
 @param assetCollectionClass JXPhotosAssetCollection 类 或其子类, 默认 JXPhotosAssetCollection
 @param assetClass JXPhotosAsset 类 或其子类, 默认 JXPhotosAsset
 @return 获取的 JXPhotosAssetCollection 实例
 */
+ (NSArray <__kindof JXPhotosAssetCollection *> *)fetchImageAssetCollectionsWithFetchOptions:(nullable PHFetchOptions *)fetchOptions
                                                                         imageRequestOptions:(nullable PHImageRequestOptions *)imageRequestOptions
                                                                        assetCollectionClass:(nullable Class)assetCollectionClass
                                                                                  assetClass:(nullable Class)assetClass;

/**
 获取图片

 @param fetchOptions 获取配置
 @param imageRequestOptions 请求图片配置
 @param assetClass JXPhotosAsset 类 或其子类, 默认 JXPhotosAsset
 @return 获取的 JXPhotosAsset 实例
 */
+ (nullable NSArray <__kindof JXPhotosAsset *> *)fetchImageAssetsWithFetchOptions:(nullable PHFetchOptions *)fetchOptions
                                                              imageRequestOptions:(nullable PHImageRequestOptions *)imageRequestOptions
                                                                       assetClass:(nullable Class)assetClass;

@end

NS_ASSUME_NONNULL_END
