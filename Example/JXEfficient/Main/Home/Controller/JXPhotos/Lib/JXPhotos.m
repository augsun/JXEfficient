//
//  JXPhotos.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotos.h"
#import <JXEfficient/JXEfficient.h>

@implementation JXPhotos

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

+ (NSArray<JXAsset *> *)fetchImageAssetsWithFetchOptions:(PHFetchOptions *)fetchOptions
                                     imageRequestOptions:(PHImageRequestOptions *)imageRequestOptions
                                              assetClass:(Class)assetClass
{
    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    if (result.count == 0) {
        return nil;
    }
    
    NSMutableArray <JXAsset *> *tempArr = [[NSMutableArray alloc] init];
    
    for (PHAsset *assetEnum in result) {
        JXAsset *jxAsset = [[assetClass alloc] init];
        jxAsset.phAsset = assetEnum;
        jxAsset.imageRequestOptions = imageRequestOptions;
        [tempArr addObject:jxAsset];
    }
    
    return tempArr;
}

@end
