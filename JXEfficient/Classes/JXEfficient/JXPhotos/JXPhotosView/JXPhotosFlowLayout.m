//
//  JXPhotosFlowLayout.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosFlowLayout.h"
#import <JXEfficient/JXEfficient.h>

@implementation JXPhotosFlowLayout

// 用于屏幕旋转
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    [self invalidateLayout];
    return YES;
}

@end
