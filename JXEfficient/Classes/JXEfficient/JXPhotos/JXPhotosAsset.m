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

@end

@implementation JXPhotosAsset

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidReceiveMemoryWarningNotification)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)applicationDidReceiveMemoryWarningNotification {
    self.largeImage = nil;
    self.largeImageInfo = nil;
}

@end
