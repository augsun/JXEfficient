//
//  NSNumber+JXCategory.h
//  AFNetworking
//
//  Created by crlandsun on 2020/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (JXCategory)

/// 解决 NSNumber 放到字典时, 序列化后不规则情形, 如 0.01 (0.0099999997764825821)
+ (NSDecimalNumber *)jx_numberForPrice:(CGFloat)num;

@end

NS_ASSUME_NONNULL_END
