//
//  JXEncryption+AES.h
//  JXEfficient
//
//  Created by augsun on 4/30/19.
//

#import <JXEncryption.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXEncryption (AES)

/**
 AES128 加密(NSData) [模式: CBC, 数据块: 128bit, 字符集: UTF8]
 
 @param key 密码
 @param data 要加密的数据
 @param iv 初始向量
 @return 加密后数据
 */
+ (nullable NSData *)AES128_encryptWithKey:(NSString *)key data:(NSData *)data iv:(nullable NSString *)iv;

/**
 AES128 解密(NSData) [模式: CBC, 数据块: 128bit, 字符集: UTF8]
 
 @param key 密码
 @param data 要解密的数据
 @param iv 初始向量
 @return 解密后数据
 */
+ (nullable NSData *)AES128_decryptWithKey:(NSString *)key data:(NSData *)data iv:(nullable NSString *)iv;

/**
 AES128 加密(NSString) [模式: CBC, 数据块: 128bit, 字符集: UTF8]
 
 @param key 密码
 @param string 要加密的字符串
 @param iv 初始向量
 @return 加密后字符串(Base64)
 */
+ (nullable NSString *)AES128_encryptWithKey:(NSString *)key string:(NSString *)string iv:(nullable NSString *)iv;

/**
 AES128 解密(NSString) [模式: CBC, 数据块: 128bit, 字符集: UTF8]
 
 @param key 密码
 @param string 要解密的字符串(Base64)
 @param iv 初始向量
 @return 解密后字符串
 */
+ (nullable NSString *)AES128_decryptWithKey:(NSString *)key string:(NSString *)string iv:(nullable NSString *)iv;

@end

NS_ASSUME_NONNULL_END
