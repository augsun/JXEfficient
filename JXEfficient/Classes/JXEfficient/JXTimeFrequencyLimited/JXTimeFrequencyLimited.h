//
//  JXTimeFrequencyLimited.h
//  JXEfficient
//
//  Created by yangjianxing on 2020/8/11.
//  Copyright © 2020 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXTimeFrequencyLimited : NSObject

/// 回调频率, ms
@property (nonatomic, assign) CGFloat frequency;

/// 限制回调
/// @param value 每次调用的值
/// @param callback 回调
- (void)limitValue:(CGFloat)value callback:(void (^)(CGFloat frequencyValue))callback;

@end

NS_ASSUME_NONNULL_END
