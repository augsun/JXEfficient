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
@property (nonatomic, strong, nullable) PHImageRequestOptions *imageRequestOptions; ///< 用于获取图片配置 <用于上层业务或子类定义>

@property (nonatomic, strong, nullable) UIImage *thumbImage; ///< 获取图片后返回的图片 <如果子类, 则调用 -[JXPhotosViewCell refreshUI:thumbImageSize:] 后将有值>
@property (nonatomic, strong, nullable) NSDictionary *thumbImageInfo; ///< 获取图片后返回的 info <如果子类, 则调用 -[JXPhotosViewCell refreshUI:thumbImageSize:] 后将有值>

@property (nonatomic, strong, nullable) UIImage *largeImage; ///< 大图 <用于上层业务或子类定义>
@property (nonatomic, strong, nullable) NSDictionary *largeImageInfo; ///< 大图信息 <用于上层业务或子类定义>
@property (nonatomic, assign) BOOL selected; ///< 是否选中 <用于上层业务或子类定义>
@property (nonatomic, assign) NSInteger selectedIndex; ///< 所有选中的 index <用于上层业务或子类定义>

@property (nonatomic, strong, nullable) UIImageView *sourceImageView; ///< 刷新过程中标记所在 UIImageView <如果子类调用 -[JXPhotosViewCell refreshUI:thumbImageSize:], 当前显示中的 cell 对应的 JXPhotosAsset 的该属性将有值>

@end

NS_ASSUME_NONNULL_END
