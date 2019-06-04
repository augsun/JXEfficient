//
//  JXEncryption+MD5.m
//  JXEfficient
//
//  Created by augsun on 4/30/19.
//

#import "JXEncryption+MD5.h"

#import <CommonCrypto/CommonDigest.h>

@implementation JXEncryption (MD5)

+ (NSString *)MD5HexDigest:(NSString *)string {
    if (!string || ![string isKindOfClass:[NSString class]] || string.length == 0) {
        return nil;
    }
    
    const char *str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

@end
