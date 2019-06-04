//
//  JXChowder+GetTimestampFromNet.h
//  JXEfficient
//
//  Created by augsun on 4/28/19.
//

#import "JXChowder.h"

NS_ASSUME_NONNULL_BEGIN

/**
 从网络获取时间戳结果回调

 @param success 获取结果是否成功
 @param timestamp 获取到的时间戳(ms)
 @param diff 从发起获取到响应的时间间隔
 */
typedef void (^JXChowderGetTimestampFromNetCompletion)(BOOL success, long long timestamp, CGFloat diff);

@interface JXChowder (GetTimestampFromNet)

/**
 从网络获取时间戳

 @param completion 获取结果
 @warning 从 https://api.m.taobao.com/rest/api3.do?api=mtop.common.getTimestamp, https://quan.suning.com/getSysTime.do 获取时间戳, 不保证将来停维情况.
 */
+ (void)jx_getTimestampFromNet:(JXChowderGetTimestampFromNetCompletion)completion;

@end

NS_ASSUME_NONNULL_END
