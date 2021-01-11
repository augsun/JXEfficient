//
//  JXPhotosGeneralPreviewVC.h
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <JXPhotosGeneralBaseVC.h>
#import <JXPhotosGeneralUsage.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JXPhotosGeneralPreviewVCPageOpenAnimationEnd)(void); ///< 页面打开动画结束回调

/**
 图片预览
 */
@interface JXPhotosGeneralPreviewVC : JXPhotosGeneralBaseVC

@property (nonatomic, copy) JXPhotosGeneralPreviewVCPageOpenAnimationEnd (^pageOpenAnimationBegin)(CGFloat duration, UIViewAnimationOptions options); ///< 页面打开动画开始
@property (nonatomic, copy) void (^pageWillBackAnimationBegin)(CGFloat duration, UIViewAnimationOptions options); ///< 返回点击动画将开始

/**
 在 PhotosLayoutVC 中点击具体图片进入的预览

 @param albumAssets PhotosLayoutVC 里所浏览相册的所有图片
 @param selectedAssets 在 PhotosLayoutVC 里已经选择的图片
 @param clickAsset 当前点击的图片
 @param usage 当前 Photos 配置
 */
- (void)previewInAlbumAssets:(NSArray <JXPhotosGeneralAsset *> *)albumAssets
              selectedAssets:(nullable NSArray <JXPhotosGeneralAsset *> *)selectedAssets
                  clickAsset:(JXPhotosGeneralAsset *)clickAsset
                       usage:(JXPhotosGeneralUsage *)usage;

/**
 在 PhotosLayoutVC 中点击左下角 "预览" 进入的预览

 @param selectedAssets 在 PhotosLayoutVC 中选中的图片
 @param usage 当前 Photos 配置
 */
- (void)previewInSelectedAssets:(NSArray <JXPhotosGeneralAsset *> *)selectedAssets
                          usage:(JXPhotosGeneralUsage *)usage;

/**
 PhotosPreviewVC 右上角 选中/非选中 事件回调
 */
@property (nonatomic, copy) void (^assetClick)(JXPhotosGeneralAsset *asset, void (^returnNewSelectedAssets)(BOOL toMaximumNumberOfChoices, NSArray <JXPhotosGeneralAsset *> *newSelectedAssets));

/**
 右上角发送事件
 */
@property (nonatomic, copy) void (^sendClick)(UIView *progressShowingView, void (^didSent)(void));

@end

NS_ASSUME_NONNULL_END
