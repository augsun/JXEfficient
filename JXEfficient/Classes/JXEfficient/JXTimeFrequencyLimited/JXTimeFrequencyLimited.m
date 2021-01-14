//
//  JXTimeFrequencyLimited.m
//  JXEfficient
//
//  Created by yangjianxing on 2020/8/11.
//  Copyright © 2020 CoderSun. All rights reserved.
//

#import "JXTimeFrequencyLimited.h"

@interface JXTimeFrequencyLimited ()

@property (nonatomic, assign) CFTimeInterval lastTime; ///< 最后回调时间
@property (nonatomic, assign) CGFloat lastValue; ///< 最后进入的值
@property (nonatomic, assign) CGFloat inWait; ///< 是否在等待中

@end

@implementation JXTimeFrequencyLimited

- (void)limitValue:(CGFloat)value callback:(void (^)(CGFloat))callback {
    CFTimeInterval nowTime = CACurrentMediaTime();
    CFTimeInterval diff = (nowTime - self.lastTime) * 1000;
        
    if (diff > self.frequency && self.inWait == NO) {
        self.lastTime = nowTime;
        
        //
        !callback ? : callback(self.lastValue);
    }
    else {
        // 保留最后值
        self.lastValue = value;

        // 在等待状态, 返回
        if (self.inWait == YES) {
            return;
        }

        // 进入等待状态
        self.inWait = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((self.frequency - diff) / 1000.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 是否还在等待
            if (self.inWait) {
                self.inWait = NO;
                self.lastTime = CACurrentMediaTime();

                //
                !callback ? : callback(self.lastValue);
            }
        });
    }
}

@end
