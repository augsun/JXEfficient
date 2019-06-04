//
//  JXEncryption+AES.m
//  JXEfficient
//
//  Created by augsun on 4/30/19.
//

#import "JXEncryption+AES.h"

#import <CommonCrypto/CommonCryptor.h>

@implementation JXEncryption (AES)

+ (NSData *)AES128_encryptWithKey:(NSString *)key data:(NSData *)data iv:(NSString *)iv {
    return [self AES128Operation:kCCEncrypt key:key data:data iv:iv];
}

+ (NSData *)AES128_decryptWithKey:(NSString *)key data:(NSData *)data iv:(NSString *)iv {
    return [self AES128Operation:kCCDecrypt key:key data:data iv:iv];
}

+ (NSString *)AES128_encryptWithKey:(NSString *)key string:(NSString *)string iv:(NSString *)iv {
    NSData *data_ori = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data_en = [self AES128_encryptWithKey:key data:data_ori iv:iv];
    NSString *str_en = [data_en base64EncodedStringWithOptions:0];
    return str_en;
}

+ (NSString *)AES128_decryptWithKey:(NSString *)key string:(NSString *)string iv:(NSString *)iv {
    NSData *data_en = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *data_de = [self AES128_decryptWithKey:key data:data_en iv:iv];
    NSString *str_de = [[NSString alloc] initWithData:data_de encoding:NSUTF8StringEncoding];
    return str_de;
}

+ (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key data:(NSData *)data iv:(NSString *)iv {
    if (!key || ![key isKindOfClass:[NSString class]] || key.length == 0 ||
        !data || ![data isKindOfClass:[NSData class]] || data.length == 0) {
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    char ivPtr[kCCBlockSizeAES128 + 1];
    
    memset(ivPtr, 0, sizeof(ivPtr));
    
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    free(buffer);
    return nil;
}

@end
