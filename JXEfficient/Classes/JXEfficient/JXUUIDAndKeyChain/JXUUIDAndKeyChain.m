//
//  JXUUIDAndKeyChain.m
//  JXEfficient
//
//  Created by augsun on 3/25/15.
//  Copyright © 2015 CoderSun. All rights reserved.
//

#import "JXUUIDAndKeyChain.h"
#import <Security/Security.h>

static NSString *const JXUUIDStringKey = @"JXUUIDStringKey";

@implementation JXUUIDAndKeyChain

+ (NSString *)UUID {
    NSString *uuid = (NSString *)[self objectForKey:JXUUIDStringKey];
    if (uuid.length == 0) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault, uuidRef));
        CFRelease(uuidRef);
        [self setObject:uuid forKey:JXUUIDStringKey];
    }
    return uuid;
}

+ (NSString *)UUIDGeneration {
    NSString *uuid = nil;
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault, uuidRef));
    CFRelease(uuidRef);
    return uuid;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,           (id)kSecClass,
            key,                                    (id)kSecAttrService,
            key,                                    (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock, (id)kSecAttrAccessible,
            nil];
}

+ (void)setObject:(id)object forKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)objectForKey:(NSString *)key {
    id object = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try { object = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData]; }
        @catch (NSException *e) { NSLog(@"Unarchive of %@ failed: %@", key, e); }
        @finally { }
    }
    if (keyData) { CFRelease(keyData); }
    return object;
}

+ (void)removeObjectForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end









