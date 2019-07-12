//
//  JXBaseDocker.m
//  JXEfficient
//
//  Created by augsun on 5/17/19.
//

#import "JXBaseDocker.h"

@implementation JXBaseDocker

+ (instancetype)sharedDocker {
    BOOL isBaseClass = [self isMemberOfClass:[JXBaseDocker class]];
    NSAssert(!isBaseClass, @"子类必须实现 +sharedDocker 方法.");
    return nil;
}

+ (NSBundle *)bundle {
    BOOL isBaseClass = [self isMemberOfClass:[JXBaseDocker class]];
    NSAssert(!isBaseClass, @"子类必须实现 +bundle 方法.");
    return nil;
}

+ (UIImage *)PDFImageWithNamed:(NSString *)name {
    BOOL isBaseClass = [self isMemberOfClass:[JXBaseDocker class]];
    NSAssert(!isBaseClass, @"子类必须实现 +PDFImageWithNamed: 方法.");
    return nil;
}

+ (UIImage *)imageWithNamed:(NSString *)name {
    BOOL isBaseClass = [self isMemberOfClass:[JXBaseDocker class]];
    NSAssert(!isBaseClass, @"子类必须实现 +imageWithNamed: 方法.");
    return nil;
}

@end
