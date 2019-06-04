//
//  MCCache.m
//  JXEfficient
//
//  Created by augsun on 9/6/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXJSONCache.h"

@implementation JXJSONCache

+ (BOOL)writeJSON:(id)json toPath:(NSString *)path {
    if (![path isKindOfClass:[NSString class]] || path.length == 0) {
        return NO;
    }
    if ([NSJSONSerialization isValidJSONObject:json] && path.length > 0) {
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:NULL];
        return [jsonData writeToFile:path atomically:YES];
    }
    else {
        return NO;
    }
}

+ (id)readJSONAtPath:(NSString *)path {
    if (![path isKindOfClass:[NSString class]] || path.length == 0) {
        return nil;
    }
    id json = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] && path.length > 0) {
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        if (jsonData) {
            json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        }
    }
    return json;
}

+ (BOOL)deleteJSONCacheAtPath:(NSString *)path {
    if (![path isKindOfClass:[NSString class]] || path.length == 0) {
        return NO;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
















