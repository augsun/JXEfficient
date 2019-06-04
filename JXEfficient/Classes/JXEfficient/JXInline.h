//
//  JXInline.h
//  JXEfficient
//
//  Created by augsun on 6/1/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JXMacro.h"

NS_ASSUME_NONNULL_BEGIN

// ====================================================================================================
#pragma mark - 判断实例类型

/**
 判空
 
 @param obj 传入的实例
 @return 是否是 nil 或 NSNull
 */
static JX_ALWAYS_INLINE BOOL jx_isNullOrNil(id _Nullable obj) {
    return !obj || [obj isKindOfClass:[NSNull class]];
}

/**
 是否 NSString

 @param obj 传入的实例
 @return 是否 NSString
 */
static JX_ALWAYS_INLINE BOOL jx_isStrObj(id obj) {
    return [obj isKindOfClass:[NSString class]];
}

/**
 是否 NSNumber

 @param obj 传入的实例
 @return 是否 NSNumber
 */
static JX_ALWAYS_INLINE BOOL jx_isNumObj(id obj) {
    return [obj isKindOfClass:[NSNumber class]];
}

/**
 是否 NSString 或 NSNumber
 
 @param obj 传入的实例
 @return 是否是 NSString 或 NSNumber
 */
static JX_ALWAYS_INLINE BOOL jx_isStrOrNumObj(id obj) {
    return jx_isStrObj(obj) || jx_isNumObj(obj);
}

/**
 是否 NSDictionary

 @param obj 传入的实例
 @return 是否 NSDictionary
 */
static JX_ALWAYS_INLINE BOOL jx_isDicObj(id obj) {
    return [obj isKindOfClass:[NSDictionary class]];
}

/**
 是否 NSArray

 @param obj 传入的实例
 @return 是否 NSArray
 */
static JX_ALWAYS_INLINE BOOL jx_isArrObj(id obj) {
    return [obj isKindOfClass:[NSArray class]];
}

// ====================================================================================================
#pragma mark - 转换

/**
 转 NSString

 @param value 传入的实例
 @return 转 NSString
 */
static JX_ALWAYS_INLINE NSString * _Nullable jx_strValue(id value) {
    return jx_isStrOrNumObj(value) ? [NSString stringWithFormat:@"%@", value] : nil;
}

/**
 2个字符串拼接 (可传入 NSString NSNumber)

 @param value0 参数1 <NSString or NSNumber>
 @param value1 参数2 <NSString or NSNumber>
 @return 返回拼接后的字符串
 */
static JX_ALWAYS_INLINE NSString * _Nullable jx_strCat2(id value0, id value1) {
    NSString *str0 = jx_strValue(value0);
    NSString *str1 = jx_strValue(value1);
    if (!str0 && !str1) {
        return nil;
    }
    else {
        return [NSString stringWithFormat:@"%@%@", str0 ? str0 : @"", str1 ? str1 : @""];
    }
}

/**
 3个字符串拼接 (可传入 NSString NSNumber)

 @param value0 参数1 <NSString or NSNumber>
 @param value1 参数2 <NSString or NSNumber>
 @param value2 参数3 <NSString or NSNumber>
 @return 返回拼接后的字符串
 */
static JX_ALWAYS_INLINE NSString * _Nullable jx_strCat3(id value0, id value1, id value2) {
    return jx_strCat2(jx_strCat2(value0, value1), value2);
}

/**
 转 NSInteger

 @param value 传入参数 <NSString or NSNumber>
 @return 返回 NSInteger
 */
static JX_ALWAYS_INLINE NSInteger jx_intValue(id value) {
    return jx_isStrOrNumObj(value) ? [value integerValue] : 0;
}

/**
 转 NSUInteger, value<0 则返回 0

 @param value 传入参数 <NSString or NSNumber>
 @return 返回 NSUInteger
 */
static JX_ALWAYS_INLINE NSUInteger jx_uIntValue(id value) {
    NSInteger num = jx_intValue(value); return num < 0 ? 0 : num;
}

/**
 转 long long

 @param value 传入参数 <NSString or NSNumber>
 @return 返回 long long
 */
static JX_ALWAYS_INLINE long long jx_longlongValue(id value) {
    return jx_isStrOrNumObj(value) ? [value longLongValue] : 0;
}

/**
 转 CGFloat

 @param value 传入参数 <NSString or NSNumber>
 @return 返回 CGFloat
 */
static JX_ALWAYS_INLINE CGFloat jx_floValue(id value) {
    return jx_isStrOrNumObj(value) ? [value floatValue] : 0;
}

/**
 转 BOOL

 @param value 传入参数 <NSString or NSNumber>
 @return 返回 BOOL
 */
static JX_ALWAYS_INLINE BOOL jx_booValue(id value) {
    return jx_isStrOrNumObj(value) ? [value boolValue] : 0;
}

/**
 转 NSDictionary

 @param value 传入参数
 @return 返回 NSDictionary
 */
static JX_ALWAYS_INLINE NSDictionary * _Nullable jx_dicValue(id value) {
    return jx_isDicObj(value) ? value : nil;
}

/**
 转 NSArray

 @param value 传入参数
 @return 返回 NSArray
 */
static JX_ALWAYS_INLINE NSArray * _Nullable jx_arrValue(id value) {
    return jx_isArrObj(value) ? value : nil;
}

// ====================================================================================================
#pragma mark - 其它

/**
 是否包含中文

 @param string 字符串参数
 @return 返回 是否包含中文
 */
static inline BOOL jx_isHaveChinese(NSString *string) {
    BOOL have = NO;
    if (jx_isStrObj(string)) {
        for(int i = 0; i < string.length; i++){
            int a = [string characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff) {
                have = YES;
                break;
            }
        }
    }
    return have;
}

/**
 转 NSURL <目前以判断 value 中有中文为其进行 PercentEncoding<URLQueryAllowedCharacterSet> 转换>
 需要对 URL 中所有部分进行编码 使用 URLEncodedString()

 @param value 传入参数
 @return 返回 URL
 */
static inline NSURL * _Nullable jx_URLValue(id value) {
    NSURL *tempURL = nil;
    if ([value isKindOfClass:[NSURL class]]) {
        tempURL = (NSURL *)value;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)value;
        if (string.length > 0) {
            BOOL haveChinese = jx_isHaveChinese(string);
            if (haveChinese) {
                NSString *encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                if (encodedString.length > 0) {
                    tempURL = [NSURL URLWithString:encodedString];
                }
            }
            else {
                tempURL = [NSURL URLWithString:string];
            }
        }
    }
    return tempURL;
}

/**
 转 URLString <目前以判断 value 中有中文为其进行 PercentEncoding<URLQueryAllowedCharacterSet> 转换>
 需要对 URL 中所有部分进行编码 使用 URLEncodedString()

 @param value 传入参数
 @return 返回 URLString
 */
static inline NSString * _Nullable jx_URLStringValue(id value) {
    NSString *tempURLString = nil;
    if ([value isKindOfClass:[NSURL class]]) {
        NSURL *URL = (NSURL *)value;
        tempURLString = URL.absoluteString;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)value;
        BOOL haveChinese = jx_isHaveChinese(string);
        if (haveChinese) {
            tempURLString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        else {
            tempURLString = string;
        }
    }
    return tempURLString;
}

static NSString *const jx_kPercentEncodingCharacters = @"!*'();:@&=+$,/?%#[]^\"`<> {}\\|";

/**
 编码 URLEncodedString <强制对 kPercentEncodingCharacters 进行 PercentEncoding 转换>

 @param value 传入参数
 @return 返回编码过的字符串
 */
static inline NSString * _Nullable jx_URLEncodedString(id value) {
    NSString *tempEncoded = nil;
    if ([value isKindOfClass:[NSURL class]]) {
        NSURL *URL = (NSURL *)value;
        tempEncoded = URL.absoluteString;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        tempEncoded = (NSString *)value;
    }
    
    if (tempEncoded) {
        NSString *charactersToEscape = jx_kPercentEncodingCharacters;
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        tempEncoded = [tempEncoded stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    }
    return tempEncoded;
}

/**
 解码 URLDecodedString

 @param value 传入参数
 @return 返回解码过的字符串
 */
static inline NSString * _Nullable jx_URLDecodedString(id value) {
    NSString *tempDecoded = nil;
    if ([value isKindOfClass:[NSURL class]]) {
        NSURL *URL = (NSURL *)value;
        tempDecoded = URL.absoluteString;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        tempDecoded = (NSString *)value;
    }
    
    if (tempDecoded) {
        tempDecoded = [tempDecoded stringByRemovingPercentEncoding];
    }
    return tempDecoded;
}

@interface JXInline : NSObject

@end

NS_ASSUME_NONNULL_END
