//
//  JXUUIDAndKeyChain.h
//  JXEfficient
//
//  Created by augsun on 3/25/15.
//  Copyright © 2015 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXUUIDAndKeyChain : NSObject

/**
 取得 UUID(唯一) 内部缓存于 keyChain
 */
+ (NSString *)UUID;

/**
 取得 UUID 内部不缓存, 每次都不一样
 */
+ (NSString *)UUIDGeneration;

/**
 保存或更新
 */
+ (void)setObject:(id)object forKey:(NSString *)key;

/**
 取出
 */
+ (nullable id)objectForKey:(NSString *)key;

/**
 删除
 */
+ (void)removeObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END









