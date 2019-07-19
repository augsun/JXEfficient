//
//  JXPhotos.h
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#import "JXAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotos : NSObject

/**
 相册授权获取

 @param handler 回调<主线程>
 */
+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;

/**
 获取图片

 @param fetchOptions 获取配置
 @param imageRequestOptions 请求图片配置
 @param assetClass JXAsset 类 或其子类
 @return 获取的 JXAsset 实例
 */
+ (NSArray <__kindof JXAsset *> *)fetchImageAssetsWithFetchOptions:(nullable PHFetchOptions *)fetchOptions
                                               imageRequestOptions:(nullable PHImageRequestOptions *)imageRequestOptions
                                                        assetClass:(nullable Class)assetClass;

@end

NS_ASSUME_NONNULL_END
