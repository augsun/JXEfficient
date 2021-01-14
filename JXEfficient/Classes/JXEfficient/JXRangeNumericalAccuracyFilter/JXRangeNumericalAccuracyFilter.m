//
//  JXRangeNumericalAccuracyFilter.m
//  JXEfficient
//
//  Created by augsun on 2019/3/21.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXRangeNumericalAccuracyFilter.h"

@interface JXRangeNumericalAccuracyFilter ()

@property (nonatomic, assign) BOOL canFilter;
@property (nonatomic, assign) CGFloat lastFilterValue;

@end

@implementation JXRangeNumericalAccuracyFilter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lastFilterValue = -CGFLOAT_MIN; // 保证初次回调时, same 为 NO. 即第一次过滤, 业务层拿到的是过滤后的值.
    }
    return self;
}

- (void)setMinValue:(CGFloat)minValue {
    _minValue = minValue;
    [self p_checkCanFilter];
}

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
    [self p_checkCanFilter];
}

- (void)setAccuracy:(CGFloat)accuracy {
    _accuracy = accuracy;
    [self p_checkCanFilter];
}

- (void)p_checkCanFilter {
    // 是否能过滤
    if (self.accuracy <= 0.0) {
        self.canFilter = NO;
    }
    else {
        CGFloat fullLength = self.maxValue - self.minValue;
        // 现在支持 min < max 情况, 将来支持 min > max 情况, 故使用 fabs
        if (self.accuracy < fabs(fullLength)) {
            self.canFilter = YES;
        }
        else {
            self.canFilter = NO;
        }
    }
}

- (void)filter:(CGFloat)realValue result:(void (^)(BOOL, CGFloat, CGFloat))result {
    NSAssert(self.canFilter, @"检查各属性配置, 确保可以被过滤.");
    
    CGFloat newValue = 0.0;

    //
    NSInteger maxLoc = self.maxValue / self.accuracy + (self.maxValue < 0.0 ? -1 : 0);
    CGFloat maxLocValue = maxLoc * self.accuracy;
    
    // 右边界
    if (realValue > maxLocValue) {
        if (fabs(realValue - maxLocValue) < fabs(realValue - self.maxValue)) {
            newValue = maxLocValue;
        }
        else {
            newValue = self.maxValue;
        }
    }
    else {
        NSInteger minLoc = self.minValue / self.accuracy + (self.minValue < 0.0 ? 0 : 1);
        CGFloat minLocValue = minLoc * self.accuracy;
        
        // 左边界
        if (realValue < minLocValue) {
            if (fabs(realValue - minLocValue) < fabs(realValue - self.minValue)) {
                newValue = minLocValue;
            }
            else {
                newValue = self.minValue;
            }
        }
        else {
            // 常规值
            NSInteger nowLoc = (realValue + (realValue < 0.0 ? -1.0 : 1.0) * self.accuracy / 2.0) / self.accuracy;
            newValue = nowLoc * self.accuracy;
        }
    }

    //
    if (newValue != self.lastFilterValue) {
        self.lastFilterValue = newValue;
        !result ? : result(NO, newValue, realValue);
    }
    else {
        !result ? : result(YES, self.lastFilterValue, realValue);
    }
}

@end

