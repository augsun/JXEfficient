//
//  JXPhotosGeneralUsage.h
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPhotosGeneralAsset.h"

NS_ASSUME_NONNULL_BEGIN

/** 初次显示的位置 */
typedef NS_ENUM(NSUInteger, JXPhotosGeneralFirstPageTo) {
    JXPhotosGeneralFirstPageToCaneralRoll, ///< 相机胶卷
    JXPhotosGeneralFirstPageToAlbum, ///< 相册列表
};

/** 选择类型 */
typedef NS_ENUM(NSUInteger, JXPhotosGeneralLayoutSelectionType) {
    JXPhotosGeneralLayoutSelectionTypeSingle, ///< 单选 <从相册选择图片扫码情况>
    JXPhotosGeneralLayoutSelectionTypeMulti, ///< 多选 <从相册选择多图上传等>
};

/**
 Photos 的使用配置
 */
@interface JXPhotosGeneralUsage : NSObject

@property (nonatomic, assign) JXPhotosGeneralFirstPageTo firstPageTo; ///< 默认 JXPhotosFirstPageToCaneralRoll
@property (nonatomic, assign) JXPhotosGeneralLayoutSelectionType selectionType; ///< 默认 JXPhotosLayoutSelectionTypeSingle

/**
 最大可选择数量, <= 1 为不限制. 默认不限制 0.
 @warning 不建议设置过大, 将可能内存占用过多崩溃, 7Plus 上测试选中 20 张 (3024, 4032)px 原图大小的图片, 低概率崩溃.
 */
@property (nonatomic, assign) NSInteger maximumNumberOfChoices;

/**
 最大边 默认原图(CGSizeZero)
 @warning <与 largeImageMinimumSize 同时设置时, largeImageMaximumSize 优先, 都不设置, 默认原图>, 建议根据具体业务指定大小, 否则同时获取多张大原图, 导致内存资源消耗过大.
 */
@property (nonatomic, assign) CGSize largeImageMaximumSize;

/**
 最小边 默认原图(CGSizeZero).
 @warning <与 largeImageMaximumSize 同时设置时, largeImageMaximumSize 优先, 都不设置, 默认原图>, 建议根据具体业务指定大小, 否则同时获取多张大原图, 导致内存资源消耗过大.
 */
@property (nonatomic, assign) CGSize largeImageMinimumSize;

@property (nonatomic, copy) void (^selectedPhotos)(NSArray <JXPhotosGeneralAsset *> *assets); ///< 选中图片后回调

@end

NS_ASSUME_NONNULL_END
