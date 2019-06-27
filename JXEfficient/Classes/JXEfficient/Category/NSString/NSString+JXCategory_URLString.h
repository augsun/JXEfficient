//
//  NSString+JXCategory_URLString.h
//  JXEfficient
//
//  Created by augsun on 6/27/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JXCategory_URLString)

- (nullable NSString *)jx_URLEncoded; ///< URL encoded
- (nullable NSString *)jx_URLDecoded; ///< URL decoded
- (NSString *)jx_URLDecoded_loop; ///< URLDecoded 直到全部被 Decoded, 最多进行 10 次 URLDecode

//
+ (nullable NSDictionary *)jx_URLParamsInURLString:(NSString *)URLString; ///< 取得 URLString 里的参数

/**
 为 URLString 添加参数
 
 @param params 参数
 @return 添加参数后的 new URLString
 @warning URLString 必须符合 RFC 3986[https://www.ietf.org/rfc/rfc3986.txt], 否则 params 不被添加并返回 URLString; params 内部添加时会强制进行 URLDecoded, 再 URLEncoded 后放入 new URLString 中.
 */
- (NSString *)jx_URLAddParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
