//
//  MCCache.h
//  JXEfficient
//
//  Created by augsun on 9/6/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//
// 用于页面原始服务器返回数据的缓存

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXJSONCache : NSObject

/**
 写缓存
 */
+ (BOOL)writeJSON:(id)json toPath:(NSString *)path;

/**
 读缓存
 */
+ (nullable id)readJSONAtPath:(NSString *)path;

/**
 删除缓存
 */
+ (BOOL)deleteJSONCacheAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
