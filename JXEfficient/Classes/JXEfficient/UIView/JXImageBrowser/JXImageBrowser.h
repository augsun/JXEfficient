//
//  JXImageViewer.h
//  JXEfficient
//
//  Created by CoderSun on 4/21/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXImageBrowserImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXImageBrowser : UIView

/**
 外部不需要持有该方法创建的实例对象, 只需要对该对象的其它回调属性进行相应的设置即可, 如 loadImage
 */
+ (instancetype)imageBrowser;

@property (nonatomic, assign) BOOL hideDotForSingle; ///< 一张图片的时候隐藏底部的 Indicator 点, 默认 NO

@property (nonatomic, assign) BOOL scanQRCodeWhenLongPress; ///< 长按的时候是否显示二维码识别选项 <如果识别到图片二维码>
@property (nullable, nonatomic, copy) BOOL (^canHandleQRCode)(NSString *QRCodeString); ///< 外部是否能处理该 二维码
@property (nullable, nonatomic, copy) void (^scannedQRCodeClick)(NSString *QRCodeString); ///< 长按弹出的二维码选项点击

/**
 设置图片 上层可以用带缓存的 SDWebImage 进行接入
 
 @param progress 下载进度
 @param completed 下载结束
 */
@property (nonatomic, copy) void (^loadImage)(NSURL *URL, void (^progress)(NSInteger receivedSize, NSInteger expectedSize), void (^completed)(UIImage * _Nullable image, NSError * _Nullable error));

/**
 浏览图片
 
 @param images 将要显示的图片数组
 @param fromIndex 最先显示的索引
 */
- (void)browserImages:(NSArray <JXImageBrowserImage *> *)images fromIndex:(NSInteger)fromIndex;

@end

NS_ASSUME_NONNULL_END





/* ================================================================================================== */
/* ====================================== JXEfficient Example. ====================================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Example.

#if 0

JXImageBrowser *imageBrowser = [JXImageBrowser imageBrowser];

imageBrowser.loadImage = ^(NSURL * _Nonnull URL, void (^ _Nonnull progress)(NSInteger, NSInteger), void (^ _Nullable completed)(UIImage * _Nullable, NSError * _Nullable)) {
    
    [[SDWebImageManager sharedManager] loadImageWithURL:URL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        JX_BLOCK_EXEC(progress, receivedSize, expectedSize);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        JX_BLOCK_EXEC(completed, image, error);
    }];
};

[imageBrowser browserImages:images fromIndex:fromIndex];

#endif















