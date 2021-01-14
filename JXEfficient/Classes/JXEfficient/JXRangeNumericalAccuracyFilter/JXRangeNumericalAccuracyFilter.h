//
//  JXRangeNumericalAccuracyFilter.h
//  JXEfficient
//
//  Created by augsun on 2019/3/21.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 过滤算法:
 对于 [min, max] 对应的 [-3.0, 5.0] 的一组数据, accuracy 为 0.2, 那么
 假设当前值为 2.376000, 如下:
     2.20                         2.30                         2.40                         2.50
 --------|--------(2.25)--------|--------(2.35)--------|--------(2.45)--------|--------
 先将真实值向前漂移精度的一半取份数, 那么向前漂移后为 2.376000 + 0.2 / 2.0 = 2.476, 取出份数为 (int)(2.476 / 0.2) = 12, 那么真实值 2.376000 过滤后为 12 * 0.2 = 2.4.
 同样:
 假设当前值为 -2.472000, 如下:
    -2.60                          -2.50                         -2.40                         -2.30
 --------|--------(-2.55)--------|--------(-2.45)--------|--------(-2.35)--------|--------
 先将真实值向后漂移精度的一半取份数, 那么向后漂移后为 -2.472000 - 0.2 / 2.0 = -2.572, 取出份数为 (int)(-2.572 / 0.2) = -12, 那么真实值 -2.472000 过滤后为 -12 * 0.2 = -2.4.
 同理, 对于其他精度数值同样适用.
 */

/// 对被 Range 确定范围内的数值进行精度过滤
/// @discussion e.g.对于 [0, 100] 这样的数值, 可以取整后回调给业务, 那么 accuracy 设置 1.0 即可, 过滤后只会返回 0.0, 8.0, 22.0, 99.0 ... 等这样的整数, 达到过滤效果.  对于 [0.0, 1.0] 这样的数据也可以过滤在 0.1.
@interface JXRangeNumericalAccuracyFilter : NSObject

/// 最大值
@property (nonatomic, assign) CGFloat minValue;
/// 最小值
@property (nonatomic, assign) CGFloat maxValue;
/// 过滤精度. 必须满足 > 0.0.
@property (nonatomic, assign) CGFloat accuracy;

/// 最后过滤时传入的真实值
@property (nonatomic, readonly) CGFloat realValue;

/// 进行过滤
/// @discussion
/// same: 与上次过滤值是否一致
/// filteredValue: 过滤后的值
/// realValue: 实时返回真实值
/// @param realValue 待过滤的真实值
/// @param result 过滤回调(一定有回调)
- (void)filter:(CGFloat)realValue result:(void (^)(BOOL same, CGFloat filteredValue, CGFloat realValue))result;

@end

NS_ASSUME_NONNULL_END
