//
//  UIImage+JXCategory.m
//  JXEfficient
//
//  Created by augsun on 7/28/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "UIImage+JXCategory.h"
#import "JXInline.h"

@implementation UIImage (JXCategory)

+ (UIImage *)jx_imageFromColor:(UIColor *)color {
    BOOL rightColor = color && [color isKindOfClass:[UIColor class]];
    NSAssert(rightColor, JX_ASSERT_MSG(@"color 参数为空或非 UIColor 实例"));
    
    CGSize size = CGSizeMake(3.0, 3.0);
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)jx_imageFromColor:(UIColor *)color radius:(CGFloat)radius {
    BOOL rightColor = color && [color isKindOfClass:[UIColor class]];
    NSAssert(rightColor, JX_ASSERT_MSG(@"color 参数为空或非 UIColor 实例"));
    
    if (radius == 0.0) {
        return [self jx_imageFromColor:color];
    }

    CGFloat side = radius * 2 + 1.0;
    CGSize size = CGSizeMake(side, side);

    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (radius > 0.0) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        CGPathRef pathRef = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
        CGContextAddPath(UIGraphicsGetCurrentContext(), pathRef);
        CGContextClip(UIGraphicsGetCurrentContext());
        [image drawInRect:rect];
        
        UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        image = outputImage;
    }
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)jx_imageFromColor:(UIColor *)color radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    BOOL rightColor = color && [color isKindOfClass:[UIColor class]];
    NSAssert(rightColor, JX_ASSERT_MSG(@"color 参数为空或非 UIColor 实例"));

    if (borderWidth == 0.0) {
        return [self jx_imageFromColor:color radius:radius];
    }
    
    BOOL rightBorderColorColor = borderColor && [borderColor isKindOfClass:[UIColor class]];
    NSAssert(rightBorderColorColor, JX_ASSERT_MSG(@"borderColor 参数为空或非 UIColor 实例"));
    
    CGFloat side = radius * 2 + 1;
    
    //
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = borderColor.CGColor;
    view.backgroundColor = color;
    view.clipsToBounds = YES;
    
    //
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius) resizingMode:UIImageResizingModeTile];
    
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)jx_sideTo:(CGFloat)sideTo forMaxSide:(BOOL)forMaxSide retina:(BOOL)retina force:(BOOL)force {
    CGFloat real_w = self.size.width * self.scale;
    CGFloat real_h = self.size.height * self.scale;
    
    if (real_w == 0.0 || real_h == 0.0) {
        return self;
    }
    
    CGFloat rate = real_w / real_h;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat real_sideTo = sideTo * (retina ? screenScale : 1.0);

    CGFloat newW = 0.0;
    CGFloat newH = 0.0;
    CGFloat scaleTo = retina ? screenScale : 1.0;
    
    BOOL needConvert = NO;
    
    // 强制转换
    if (force) {
        needConvert = YES;
        
        if (forMaxSide == YES) {
            if (real_w > real_h)    { newW = sideTo; newH = newW / rate; }
            else                    { newH = sideTo; newW = newH * rate; }
        }
        else {
            if (real_w < real_h)    { newW = sideTo; newH = newW / rate; }
            else                    { newH = sideTo; newW = newH * rate; }
        }
    }
    // 非强制转换
    else {
        // 倍率与当前屏幕相同
        if (self.scale == scaleTo) {
            if (real_w > real_sideTo || real_h > real_sideTo) {
                if (forMaxSide) {
                    needConvert = YES;
                    
                    if (real_w > real_h)    { newW = sideTo; newH = newW / rate; }
                    else                    { newH = sideTo; newW = newH * rate; }
                }
                else {
                    if (MIN(real_w, real_h) > real_sideTo) {
                        needConvert = YES;
                        
                        if (real_w < real_h)    { newW = sideTo; newH = newW / rate; }
                        else                    { newH = sideTo; newW = newH * rate; }
                    }
                    else {
                        // 小边 小于期望 无需转换
                    }
                }
            }
            else {
                // 两边 都小于期望 无需转换
            }
        }
        // 倍率与当前屏幕不同
        else {
            needConvert = YES;
            
            if (real_w > real_sideTo || real_h > real_sideTo) {
                if (forMaxSide) {
                    if (real_w > real_h)    { newW = sideTo; newH = newW / rate; }
                    else                    { newH = sideTo; newW = newH * rate; }
                }
                else {
                    if (MIN(real_w, real_h) > real_sideTo) {
                        if (real_w < real_h)    { newW = sideTo; newH = newW / rate; }
                        else                    { newH = sideTo; newW = newH * rate; }
                    }
                    else {
                        // 小边 小于期望 需转换
                        newW = real_w / scaleTo;
                        newH = real_h / scaleTo;
                    }
                }
            }
            else {
                // 两边 都小于期望 需转换
                newW = real_w / scaleTo;
                newH = real_h / scaleTo;
            }
        }
    }
    
    //
    if (needConvert) {
        newW = roundf(newW);
        newH = roundf(newH);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newW, newH), NO, scaleTo);
        [self drawInRect:CGRectMake(0, 0, newW + 1.0, newH + 1.0)];
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    else {
        return self;
    }
}

+ (UIImage *)jx_PDFImage:(id)dataOrPath {
    return [self _jx_PDFImage:dataOrPath resize:YES size:CGSizeZero];
}

+ (UIImage *)jx_PDFImageWithNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    if (jx_strValue(name).length == 0) {
        return nil;
    }
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    NSString *imagePath = [bundle pathForResource:name ofType:@"pdf"];
    UIImage *img = [UIImage jx_PDFImage:imagePath];
    return img;
}

+ (UIImage *)jx_PDFImageWithNamed:(NSString *)name inBundle:(NSBundle *)bundle size:(CGSize)size {
    if (jx_strValue(name).length == 0) {
        return nil;
    }
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    NSString *imagePath = [bundle pathForResource:name ofType:@"pdf"];
    return [self _jx_PDFImage:imagePath resize:YES size:size];
}

+ (UIImage *)_jx_PDFImage:(id)dataOrPath resize:(BOOL)resize size:(CGSize)size {
    CGPDFDocumentRef pdf = NULL;
    if ([dataOrPath isKindOfClass:[NSData class]]) {
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)dataOrPath);
        pdf = CGPDFDocumentCreateWithProvider(provider);
        CGDataProviderRelease(provider);
    } else if ([dataOrPath isKindOfClass:[NSString class]]) {
        pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:dataOrPath]);
    }
    if (!pdf) return nil;
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
    if (!page) {
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGRect pdfRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGSize pdfSize = resize ? size : pdfRect.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, pdfSize.width * scale, pdfSize.height * scale, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    if (!ctx) {
        CGColorSpaceRelease(colorSpace);
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGContextScaleCTM(ctx, scale, scale);
    CGContextTranslateCTM(ctx, -pdfRect.origin.x, -pdfRect.origin.y);
    CGContextDrawPDFPage(ctx, page);
    CGPDFDocumentRelease(pdf);
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    UIImage *pdfImage = [[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(image);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    return pdfImage;
}

+ (UIImage *)jx_imageWithNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    UIImage *img = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (NSString *)jx_QRCodeStringFromImageOfBase64String:(NSString *)base64String {
    if (jx_strValue(base64String).length == 0) {
        return nil;
    }
    NSData *QRData = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (QRData.length <= 0) {
        return nil;
    }
    UIImage *image = [UIImage imageWithData:QRData];
    if (image.size.width <= 0 && image.size.height <= 0) {
        return nil;
    }
    NSString *QRCodeString = [self jx_QRCodeStringFromImage:image];
    return QRCodeString;
}

+ (NSString *)jx_QRCodeStringFromImage:(UIImage *)image {
    if (!image || ![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{
                                                        CIDetectorAccuracy: CIDetectorAccuracyHigh
                                                        }];
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    if (!ciImage) {
        return nil;
    }
    NSArray *features = [detector featuresInImage:ciImage];
    if (features.count <= 0) {
        return nil;
    }
    CIQRCodeFeature *feature = features.firstObject;
    NSString *QRCodeString = feature.messageString;
    return QRCodeString;
}

+ (UIImage *)jx_QRCodeImageFromString:(NSString *)string pt_sideLength:(CGFloat)pt_sideLength {
    
    NSAssert(jx_strValue(string).length > 0, JX_ASSERT_MSG(@"参数 string 为空"));
    NSAssert(pt_sideLength > 0.0, JX_ASSERT_MSG(@"参数 pt_sideLength 必须大于 0.0"));

    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat px_sideLength = pt_sideLength * screenScale;
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    //
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *ciImage = [filter outputImage];
    
    //
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(px_sideLength/CGRectGetWidth(extent), px_sideLength/CGRectGetHeight(extent));

    //
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *uiImage = [UIImage imageWithCGImage:scaledImage scale:screenScale orientation:UIImageOrientationUp];
    return uiImage;
}

@end









