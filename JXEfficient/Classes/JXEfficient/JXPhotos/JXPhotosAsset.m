//
//  JXPhotosAsset.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosAsset.h"
#import <JXEfficient/JXEfficient.h>

@interface JXPhotosAsset ()

@property (nonatomic, strong) NSMutableDictionary <NSString *,  void (^)(void)> *callbacks;

@end

@implementation JXPhotosAsset

- (NSMutableDictionary<NSString *, void (^)(void)> *)callbacks {
    if (!_callbacks) {
        _callbacks = [[NSMutableDictionary alloc] init];
    }
    return _callbacks;
}

- (void)setThumbImage:(UIImage *)thumbImage {
    _thumbImage = thumbImage;
    [self.callbacks enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, void (^ _Nonnull obj)(void), BOOL * _Nonnull stop) {
        obj();
    }];
}

- (void)addThumbImageSettedTrigger:(void (^)(void))settedTrigger cellHashKey:(NSString *)cellHashKey {
    [self.callbacks setObject:settedTrigger forKey:cellHashKey];
}

@end
