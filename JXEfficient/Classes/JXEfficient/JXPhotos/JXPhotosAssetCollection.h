//
//  JXPhotosAssetCollection.h
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//

#import <Foundation/Foundation.h>
#import "JXPhotosAsset.h"

NS_ASSUME_NONNULL_BEGIN

/**
 代表一个 PHAssetCollection
 */
@interface JXPhotosAssetCollection : NSObject

@property (nonatomic, strong) __kindof JXPhotosAsset *thumbImageAsset;
@property (nonatomic, strong, nullable) PHImageRequestOptions *thumbImageRequestOptions;

@property (nonatomic, strong, nullable) UIImage *thumbImage;
@property (nonatomic, strong, nullable) NSDictionary *thumbImageInfo;

@property (nonatomic, strong) PHAssetCollection *phAssetCollection; ///< 获取的系统  PHAssetCollection
@property (nonatomic, copy) NSArray <__kindof JXPhotosAsset *> *assets; ///< 获取的 JXPhotosAsset

@end

NS_ASSUME_NONNULL_END
