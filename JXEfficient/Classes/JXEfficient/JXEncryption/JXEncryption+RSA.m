//
//  JXEncryption+RSA.m
//  JXEfficient
//
//  Created by augsun on 4/30/19.
//

#import "JXEncryption+RSA.h"

#import "RSA.h"

@implementation JXEncryption (RSA)

+ (NSData *)RSA_encryptWithPublicKey:(NSString *)publicKey data:(NSData *)data {
    return [RSA encryptData:data publicKey:publicKey];
}

+ (NSData *)RSA_decryptWithPublicKey:(NSString *)publicKey data:(NSData *)data {
    return [RSA decryptData:data publicKey:publicKey];
}

+ (NSData *)RSA_encryptWithPrivateKey:(NSString *)privateKey data:(NSData *)data {
    return [RSA encryptData:data privateKey:privateKey];
}

+ (NSData *)RSA_decryptWithPrivateKey:(NSString *)privateKey data:(NSData *)data {
    return [RSA decryptData:data privateKey:privateKey];
}

+ (NSString *)RSA_encryptWithPublicKey:(NSString *)publicKey string:(NSString *)string {
    return [RSA encryptString:string publicKey:publicKey];
}

+ (NSString *)RSA_decryptWithPublicKey:(NSString *)publicKey string:(NSString *)string {
    return [RSA decryptString:string publicKey:publicKey];
}

+ (NSString *)RSA_encryptWithPrivateKey:(NSString *)privateKey string:(NSString *)string {
    return [RSA encryptString:string privateKey:privateKey];
}

+ (NSString *)RSA_decryptWithPrivateKey:(NSString *)privateKey string:(NSString *)string {
    return [RSA decryptString:string privateKey:privateKey];
}

@end
