//
//  JXEncryption+MD5.h
//  JXEfficient
//
//  Created by augsun on 4/30/19.
//

#import "JXEncryption.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXEncryption (MD5)

/**
 MD5 (32byte)
 
 @param string 要进行 MD5 的字符串
 @return MD5 后的值(小写)
 */
+ (nullable NSString *)MD5HexDigest:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
