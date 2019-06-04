//
//  UIColor+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 1/21/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JXCategory)

/**
 十六进制字符串转颜色, @"BBDD10" -> UIColor

 @param HEXString 要转换的字符串, 如 @"BBDD10"
 @return UIColor 颜色
 */
+ (nullable UIColor *)jx_colorFromHEXString:(NSString *)HEXString;

@end

NS_ASSUME_NONNULL_END
