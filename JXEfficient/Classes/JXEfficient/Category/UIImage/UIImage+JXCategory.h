//
//  UIImage+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 7/28/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JXCategory)

/**
 纯色直角图片 且 UIImageResizingModeStretch 且 边长 3pt, scale 为屏幕的 scale
 @param color 生成图片的颜色
 @discussion 边长 3pt, scale 为屏幕的 scale, 图片为 UIImageResizingModeStretch 模式
 */
+ (UIImage *)jx_imageFromColor:(nullable UIColor *)color;

/**
 纯色圆角图片
 @param color 生成图片的颜色
 @param radius 圆角
 @discussion 边长 (radius * 2 + 1), scale 为屏幕的 scale, 图片为 UIImageResizingModeStretch 模式
 */
+ (UIImage *)jx_imageFromColor:(nullable UIColor *)color radius:(CGFloat)radius;

/**
 纯色带描边图片
 @param color 生成图片的颜色
 @param radius 圆角
 @param borderWidth 描边宽度
 @param borderColor 描边颜色
 @discussion 边长 (radius * 2 + 1), scale 为屏幕的 scale, 图片为 UIImageResizingModeStretch 模式
 @warning borderWidth 要小等于 radius
 */
+ (UIImage *)jx_imageFromColor:(nullable UIColor *)color radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 按比例重置图片尺寸 图片的 scale 与 size
 @param sideTo 期望修改 到的边长大小
 @param forMaxSide 是否对图片的长边进行 期望修改, 否则对短边进行 期望修改
 @param retina 生成的图片是否与主屏幕的 scale 相同, 如图片上传一般为像素 此时一般传 NO, sideTo 则传入真实期望的像素大小, 如果是下载下来的头像图片, 头像 imageView 的大小为 50pt, 那么该值可以传入 YES 同时 sideTo 传入 50pt, forMaxSide 可以根据情况 是否要大边停留在 50pt, 还是小边停留在 50pt
 @param force 强制转换, 为 NO 时, 如果当前图片的 scale 与当前屏幕的 scale相同 且 真实期望边(sideTo * (retina ? screen.scale : 1.0)) > 图片真实大小(size * screen.scale) 则不会转换. 为 YES 时, 则无论如何 都根据 sideTo forMaxSide retina 三个参数进行强制转换
 */
- (UIImage *)jx_sideTo:(CGFloat)sideTo forMaxSide:(BOOL)forMaxSide retina:(BOOL)retina force:(BOOL)force;

+ (nullable UIImage *)jx_PDFImage:(id)dataOrPath; ///< 获取 PDF 图片
+ (nullable UIImage *)jx_PDFImageWithNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle; ///< 指定 Bundle 里获取 PDF 图片.
+ (nullable UIImage *)jx_PDFImageWithNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle size:(CGSize)size; ///< 指定 Bundle 里获取指定大小的 PDF 图片.
+ (nullable UIImage *)jx_imageWithNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle; ///< 指定 Bundle 里获取图片.

// QRCode
+ (nullable NSString *)jx_QRCodeStringFromImageOfBase64String:(NSString *)base64String; ///< 根据 base64 编码后的二维码 返回二维码字符串
+ (nullable NSString *)jx_QRCodeStringFromImage:(UIImage *)image; ///< 根据图片 返回二维码字符串

/**
 指定边长返回二维码图片
 @param string 要生成二维码图片的字符串
 @param pt_sideLength 要生成二维码图片的大小 其 scale 与屏幕相同
 @warning pt_sideLength 必须 > 0.0
 */
+ (UIImage *)jx_QRCodeImageFromString:(NSString *)string pt_sideLength:(CGFloat)pt_sideLength;

@end

NS_ASSUME_NONNULL_END
