//
//  JXRegular.h
//  JXEfficient
//
//  Created by augsun on 9/9/15.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXRegular : NSObject

/**
 验证 Pwd 满足 6-20位 的a-z A-Z 0-9组成

 @param pwd 要验证的 pwd
 @return 验证结果
 */
+ (BOOL)regularPwdLength_6to20_with_aAtozZ_or_0to9:(NSString *)pwd;

/**
 验证 Email

 @param email 要验证的 email
 @return 验证结果
 */
+ (BOOL)regularEmail:(NSString *)email;

/**
 验证 URL

 @param URL 要验证的 URL
 @return 验证结果
 */
+ (BOOL)regularURL:(NSString *)URL;

/**
 验证正数

 @param number 要验证的 number
 @return 验证结果
 */
+ (BOOL)regularPositiveNumber:(NSString *)number;

/**
 非负浮点数

 @param unNegativeFloat 要验证的 unNegativeFloat
 @return 验证结果
 */
+ (BOOL)regularUnNegativeFloat:(NSString *)unNegativeFloat;

/**
 验证用户名 满足 6-20位 的a-z A-Z 0-9组成

 @param userName 要验证的 userName
 @return 验证结果
 */
+ (BOOL)regularUserNameLength_3to20_with_aAtozZ_or_0to9:(NSString *)userName;

/**
 验证手机号

 @param mobile 要验证的 mobile
 @return 验证结果
 */
+ (BOOL)regularMobile:(NSString *)mobile;

/**
 验证 6 位数字验证码

 @param authCode6Digit 要验证的 authCode6Digit
 @return 验证结果
 */
+ (BOOL)regularAuthCode6Digit:(NSString *)authCode6Digit;

/**
 验证昵称 满足中文 大小写字母 数字

 @param nickName 要验证的 nickName
 @return 验证结果
 */
+ (BOOL)regularNickName:(NSString *)nickName;

/**
 验证中文

 @param chinese 要验证的 chinese
 @return 验证结果
 */
+ (BOOL)regularChinese:(NSString *)chinese;

/**
 验证是否有空格

 @param string 要验证的 string
 @return 验证结果
 */
+ (BOOL)regularHaveSpace:(NSString *)string;

/**
 验证单个字符是否是 ASCII 码

 @param ascii 要验证的 ascii
 @return 验证结果
 */
+ (BOOL)regularIsAscii:(NSString *)ascii;

/**
 验证是否 数字 大小写字母

 @param string 要验证的 string
 @return 验证结果
 */
+ (BOOL)regularNumericAndLetter:(NSString *)string;

/**
 验证字母

 @param string 要验证的 string
 @return 验证结果
 */
+ (BOOL)regularLetter:(NSString *)string;

/**
 验证昵称(满足中文 大小写字母 数字)的长度 (中文当两个字符, 数字 字母为一个字符)

 @param nickName 要验证的 nickName
 @return 验证结果
 */
+ (NSInteger)regularLengthOfNickName:(NSString *)nickName;

/**
 验证 18 位身份证

 @param idCard 要验证的 idCard
 @return 验证结果
 */
+ (BOOL)regularIDCard:(NSString *)idCard;

@end

NS_ASSUME_NONNULL_END









