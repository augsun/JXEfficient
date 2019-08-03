//
//  JXEfficientDocker.m
//  JXEfficient
//
//  Created by augsun on 5/17/19.
//

#import "JXEfficientDocker.h"
#import "JXEfficient.h"

static const BOOL kIsCocoapods = YES;

@implementation JXEfficientDocker

static JXEfficientDocker *singleton_;
+ (instancetype)sharedDocker {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton_ = [[self alloc] init];
    });
    return singleton_;
}

+ (NSBundle *)bundle {
    NSBundle *bundle = nil;
    if (kIsCocoapods) {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:NSStringFromClass([JXEfficient class]) ofType:@"bundle"]];
    }
    return bundle;
}

@end
