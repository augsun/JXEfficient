//
//  JXPhotosViewFlowLayout.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosViewFlowLayout.h"
#import <JXEfficient/JXEfficient.h>

@implementation JXPhotosViewFlowLayout

// 用于屏幕旋转
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    [self invalidateLayout];
    return YES;
}

@end
