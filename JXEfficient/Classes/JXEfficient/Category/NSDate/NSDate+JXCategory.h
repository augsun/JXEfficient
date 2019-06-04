//
//  NSDate+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 7/29/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const JXDefaultFormat;       // Default is @"yyyy-MM-dd HH:mm:ss".
UIKIT_EXTERN NSString *const JXDotFormat;

@interface NSDate (JXCategory)

// 取得当前时间戳
+ (nullable NSString *)jx_currentTimeStamp;

// 时间戳转日期
+ (nullable NSDate *)jx_dateFromTimeStamp:(NSString *)timeStamp;

// 根据字符串格式 时间转字符串 @"yyyy-MM-dd HH:mm:ss" 或 "yyyyMMdd HH:mm:ss"(默认)
- (NSString *)jx_stringByFormat:(NSString *)dateFormat;

// 根据字符串格式 字符串转时间 @"yyyy-MM-dd HH:mm:ss" 或 "yyyyMMdd HH:mm:ss"(默认)
+ (nullable NSDate *)jx_dateFromString:(NSString *)string format:(NSString *)format;

// 根据格式
+ (nullable NSString *)jx_stringByFormat:(NSString *)format
                               oriString:(NSString *)oriString
                               oriFormat:(NSString *)oriFormat;

// 根据秒数 计算成 <天 时 分 秒>
// seconds > 0 否则返回都为 0
+ (void)jx_seconds:(NSInteger)seconds
         converted:(void (^)(NSInteger days, NSInteger hours, NSInteger minutes, NSInteger seconds))converted;

//
- (nullable NSString *)jx_year;
- (nullable NSString *)jx_month;
- (nullable NSString *)jx_day;
- (nullable NSString *)jx_week;

// 取得具体某年月的那月天数 etc. yearMonth 为 @"2010/02"时 返回为 29
+ (NSInteger)jx_daysInYearMonth:(NSString *)yearMonth;

// 当天直接显示时分，例如10:30；昨天显示“昨天10:30”；往后显示”XX年X月X日 10:30”；
+ (NSString *)jx_dateUnexactMax:(NSUInteger)unexactMax
                 formDateString:(NSString *)formDateString
                 formDateFormat:(NSString *)formDateFormat
                         toDate:(nullable NSDate *)toDate
                    showSeconds:(BOOL)showSeconds;

@end

NS_ASSUME_NONNULL_END









