//
//  JXEncryption+RSA.h
//  JXEfficient
//
//  Created by augsun on 4/30/19.
//

#import <JXEncryption.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXEncryption (RSA)

#pragma mark - NSData

/**
 RSA 公钥加密 (NSData)
 
 @param publicKey 公钥
 @param data 要加密的数据
 @return 加密后数据
 */
+ (nullable NSData *)RSA_encryptWithPublicKey:(NSString *)publicKey data:(NSData *)data;

/**
 RSA 公钥解密 (NSData)
 
 @param publicKey 公钥
 @param data 要加密的数据
 @return 加密后数据
 */
+ (nullable NSData *)RSA_decryptWithPublicKey:(NSString *)publicKey data:(NSData *)data;

/**
 RSA 私钥加密 (NSData)
 
 @param privateKey 私钥
 @param data 要加密的数据
 @return 加密后数据
 */
+ (nullable NSData *)RSA_encryptWithPrivateKey:(NSString *)privateKey data:(NSData *)data;

/**
 RSA 私钥解密 (NSData)
 
 @param privateKey 私钥
 @param data 要加密的数据
 @return 加密后数据
 */
+ (nullable NSData *)RSA_decryptWithPrivateKey:(NSString *)privateKey data:(NSData *)data;

#pragma mark - NSString

/**
 RSA 公钥加密 (NSString)
 
 @param publicKey 公钥
 @param string 要加密的字符串
 @return 加密后字符串(Base64)
 */
+ (nullable NSString *)RSA_encryptWithPublicKey:(NSString *)publicKey string:(NSString *)string;

/**
 RSA 公钥解密 (NSString)
 
 @param publicKey 公钥
 @param string 要加密的字符串
 @return 加密后字符串(Base64)
 */
+ (nullable NSString *)RSA_decryptWithPublicKey:(NSString *)publicKey string:(NSString *)string;

/**
 RSA 私钥加密 (NSString)
 
 @param privateKey 私钥
 @param string 要加密的字符串
 @return 加密后字符串(Base64)
 */
+ (nullable NSString *)RSA_encryptWithPrivateKey:(NSString *)privateKey string:(NSString *)string;

/**
 RSA 私钥解密 (NSString)
 
 @param privateKey 私钥
 @param string 要加密的字符串
 @return 加密后字符串(Base64)
 */
+ (nullable NSString *)RSA_decryptWithPrivateKey:(NSString *)privateKey string:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
