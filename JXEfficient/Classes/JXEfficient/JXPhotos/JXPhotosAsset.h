//
//  JXPhotosAsset.h
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/**
 代表一个 PHAsset
 */
@interface JXPhotosAsset : NSObject

@property (nonatomic, strong) PHAsset *phAsset; ///< 获取的系统  PHAsset
@property (nonatomic, strong, nullable) PHImageRequestOptions *imageRequestOptions; ///< 用于获取图片配置

@property (nonatomic, strong, nullable) UIImage *image; ///< 获取图片后返回的图片, 上层使用
@property (nonatomic, strong, nullable) NSDictionary *info; ///< 获取图片后返回的 info, 上层使用

@property (nonatomic, assign) BOOL selected; ///< 只用于子类自定义标记 是否选中
@property (nonatomic, assign) NSInteger selectedIndex; ///< 只用于子类自定义标记 所有选中的 index

@end

NS_ASSUME_NONNULL_END
