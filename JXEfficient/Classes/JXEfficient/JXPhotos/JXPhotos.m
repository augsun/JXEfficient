//
//  JXPhotos.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotos.h"
#import "JXMacro.h"

@implementation JXPhotos

+ (PHAuthorizationStatus)authorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler {
    void (^temp_handler)(PHAuthorizationStatus) = ^ (PHAuthorizationStatus status) {
        JX_BLOCK_EXEC(handler, status);
    };

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (NSThread.isMainThread) {
            JX_BLOCK_EXEC(temp_handler, status);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                JX_BLOCK_EXEC(temp_handler, status);
            });
        }
    }];
}

+ (NSArray<JXPhotosAssetCollection *> *)fetchImageAssetCollectionsWithFetchOptions:(PHFetchOptions *)fetchOptions
                                                               imageRequestOptions:(PHImageRequestOptions *)imageRequestOptions
                                                              assetCollectionClass:(Class)assetCollectionClass
                                                                        assetClass:(Class)assetClass
{
    //
    if (assetCollectionClass) {
        NSAssert(
                 [assetCollectionClass isSubclassOfClass:[JXPhotosAssetCollection class]],
                 ([NSString stringWithFormat:@"JXPhotos 方法 %s 的参数 assetCollectionClass 请传入 JXPhotosAssetCollection 或其子类.", __func__])
                 );
    }
    else {
        assetCollectionClass = [JXPhotosAssetCollection class];
    }
    
    //
    if (assetClass) {
        NSAssert(
                 [assetClass isSubclassOfClass:[JXPhotosAsset class]],
                 ([NSString stringWithFormat:@"JXPhotos 方法 %s 的参数 assetClass 请传入 JXPhotosAsset 或其子类.", __func__])
                 );
    }
    else {
        assetClass = [JXPhotosAsset class];
    }

    //
    PHFetchResult <PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                                           subtype:PHAssetCollectionSubtypeAny
                                                                                           options:fetchOptions];
    
    if (result.count == 0) {
        return nil;
    }
    
    NSMutableArray <JXPhotosAssetCollection *> *tempArr_collections = [[NSMutableArray alloc] init];
    for (PHAssetCollection *collectionEnum in result) {
        PHFetchResult <PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collectionEnum options:fetchOptions];
        
        NSMutableArray <JXPhotosAsset *> *tempArr_assets = [[NSMutableArray alloc] init];
        for (PHAsset *assetEnum in assets) {
            if (assetEnum.mediaType == PHAssetMediaTypeImage) {
                JXPhotosAsset *jxAsset = [[assetClass alloc] init];
                jxAsset.phAsset = assetEnum;
                jxAsset.imageRequestOptions = imageRequestOptions;
                [tempArr_assets addObject:jxAsset];
            }
        }
        if (tempArr_assets.count > 0) {
            JXPhotosAssetCollection *jxAssetCollection = [[assetCollectionClass alloc] init];
            jxAssetCollection.phAssetCollection = collectionEnum;
            jxAssetCollection.assets = tempArr_assets;
            [tempArr_collections addObject:jxAssetCollection];
        }
    }
    
    return tempArr_collections;
}

+ (NSArray<JXPhotosAsset *> *)fetchImageAssetsWithFetchOptions:(PHFetchOptions *)fetchOptions
                                     imageRequestOptions:(PHImageRequestOptions *)imageRequestOptions
                                              assetClass:(Class)assetClass
{
    //
    if (assetClass) {
        NSAssert(
                 [assetClass isSubclassOfClass:[JXPhotosAsset class]],
                 ([NSString stringWithFormat:@"JXPhotos 方法 %s 的参数 assetClass 请传入 JXPhotosAsset 或其子类.", __func__])
                 );
    }
    else {
        assetClass = [JXPhotosAsset class];
    }
    
    PHFetchResult <PHAsset *> *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    if (result.count == 0) {
        return nil;
    }
    
    NSMutableArray <JXPhotosAsset *> *tempArr = [[NSMutableArray alloc] init];
    for (PHAsset *assetEnum in result) {
        JXPhotosAsset *jxAsset = [[assetClass alloc] init];
        jxAsset.phAsset = assetEnum;
        jxAsset.imageRequestOptions = imageRequestOptions;
        [tempArr addObject:jxAsset];
    }
    
    return tempArr;
}

@end
