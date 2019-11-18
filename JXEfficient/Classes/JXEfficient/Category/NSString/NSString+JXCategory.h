//
//  NSString+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 8/3/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JXCategory)

/**
 对字符串进行 MD5 编码

 @return MD5 编码后的字符串
 */
- (NSString *)jx_md5String;

/**
 版本号比较 支持 x.x.x.x... 样式的版本号 长度不限

 @param version 与某一版本进行比较
 @return 比较结果
 @discusstion [self=3.2 version=1.2]->NSOrderedDescending [self=3.2 version=3.2.0.0]->NSOrderedSame  [self=3.2 version=5.0.8.10]->NSOrderedAscending
 @warning 如果参数 version 为非字符串或字符串长度为 0, 返回 NSOrderedDescending;
 */
- (NSComparisonResult)jx_compareToVersionString:(NSString *)version;

- (CGFloat)jx_widthForFont:(UIFont *)font; ///< 计算字体单行宽度

#pragma mark 浮点数
/**
 12345.432 -> 12,345.432 转三位分节格式 NSNumberFormatterDecimalStyle
 */
+ (NSString *)jx_decimalStyle:(CGFloat)num;

/**
 123456.40 -> 123456.4 自动去除无效小数点位
 */
+ (NSString *)jx_priceString:(CGFloat)num;

/**
 123456.40 -> ￥123456.40 添加人民币符号(强制两位小数)
 */
+ (NSString *)jx_priceTwoFractionDigitsString:(CGFloat)num;

/**
 123456.40 -> ￥123456.4 自动去除无效小数点位 & 添加人民币符号
 */
+ (NSString *)jx_priceStyleString:(CGFloat)num;

/**
 123456.40 -> 123,456.4 自动去除无效小数点位 & NSNumberFormatterDecimalStyle样式
 */
+ (NSString *)jx_priceDecimalString:(CGFloat)num;

/**
 123456.40 -> ￥123,456.4 自动去除无效小数点位 & 添加人民币符号 & NSNumberFormatterDecimalStyle样式
 */
+ (NSString *)jx_priceDecimalStyleString:(CGFloat)num;

#pragma mark 其它
- (NSString *)jx_stringByTrimmingWhitespaceAndNewlineCharacter; ///< 修剪掉 前后 空格和回车

@end

NS_ASSUME_NONNULL_END











