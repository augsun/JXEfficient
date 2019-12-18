//
//  NSDate+JXCategory.m
//  JXEfficient
//
//  Created by augsun on 7/29/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "NSDate+JXCategory.h"
#import "JXMacro.h"
#import "NSDateFormatter+JXCategory.h"

NSString *const JXDefaultFormat = @"yyyy-MM-dd HH:mm:ss";
NSString *const JXDotFormat = @"yyyy.MM.dd HH:mm:ss";

NSString *const JXDateDefaultFormat = @"yyyy-MM-dd HH:mm:ss";
NSString *const JXDateDotFormat = @"yyyy.MM.dd HH:mm:ss";

@implementation NSDate (JXCategory)

+ (NSString *)jx_currentTimeStamp {
    return [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
}

+ (nullable NSDate *)jx_dateFromTimeStamp:(NSString *)timeStamp {
    if ([timeStamp isKindOfClass:[NSString class]] || [timeStamp isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
    }
    else {
        return nil;
    }
}

- (NSString *)jx_stringByFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [NSDateFormatter jx_chinaFormatter];
    [dateFormatter setDateFormat:dateFormat ? dateFormat : JXDateDefaultFormat];
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)jx_dateFromString:(NSString *)string format:(NSString *)format {
    if (!string) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [NSDateFormatter jx_chinaFormatter];
    [dateFormatter setDateFormat:format ? format : JXDateDefaultFormat];
    return [dateFormatter dateFromString:string];
}

+ (NSString *)jx_stringByFormat:(NSString *)format oriString:(NSString *)oriString oriFormat:(NSString *)oriFormat {
    return [[self jx_dateFromString:oriString format:oriFormat] jx_stringByFormat:format];
}

+ (void)jx_seconds:(NSInteger)seconds converted:(void (^)(NSInteger, NSInteger, NSInteger, NSInteger))converted {
    if (seconds <= 0) {
        !converted ? : converted(0, 0, 0, 0);
        return;
    }
    NSInteger
    secondsOfDay = JX_SECONDS_OF_DAY,
    secondsOfHour = 60 * 60,
    secondsOfMinute = 60,
    left = seconds;

    //
    NSInteger days = left / secondsOfDay;
    left = left % secondsOfDay;
    
    //
    NSInteger hours = left / secondsOfHour;
    left = left % secondsOfHour;
    
    //
    NSInteger minutes = left / secondsOfMinute;
    left = left % secondsOfMinute;

    !converted ? : converted(days, hours, minutes, left);
}

- (NSString *)jx_year {
    NSDateFormatter *dateFormatter = [NSDateFormatter jx_chinaFormatter];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)jx_month {
    NSDateFormatter *dateFormatter = [NSDateFormatter jx_chinaFormatter];
    [dateFormatter setDateFormat:@"MM"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)jx_day {
    NSDateFormatter *dateFormatter = [NSDateFormatter jx_chinaFormatter];
    [dateFormatter setDateFormat:@"dd"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)jx_week {
    NSDateFormatter *dateFormatter = [NSDateFormatter jx_chinaFormatter];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:self];
}

+ (NSInteger)jx_daysInYearMonth:(NSString *)yearMonth {
    NSDateFormatter *dateFormatter = [NSDateFormatter jx_chinaFormatter];
    [dateFormatter setDateFormat:@"yyyy/MM"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[dateFormatter dateFromString:yearMonth]].length;
}

+ (NSString *)jx_dateUnexactMax:(NSUInteger)unexactMax
                 formDateString:(NSString *)formDateString
                 formDateFormat:(NSString *)formDateFormat
                         toDate:(NSDate *)toDate
                    showSeconds:(BOOL)showSeconds {
    
    //
    if (unexactMax == 0 || !formDateFormat || !toDate) {
        return formDateString;
    }
    
    //
    NSDateFormatter *dateFormatter = [NSDateFormatter jx_chinaFormatter];
    dateFormatter.dateFormat = formDateFormat;
    NSDate *fromDate = [dateFormatter dateFromString:formDateString];
    if (!fromDate) {
        return formDateString;
    }

    //
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSInteger dayBefore = [calendar components:NSCalendarUnitDay
                                      fromDate:[dateFormatter dateFromString:[dateFormatter stringFromDate:fromDate]]
                                        toDate:[dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]]
                                       options:0].day;
    
    // 过去
    if (dayBefore > 0) {
        if (dayBefore < unexactMax) {
            if (dayBefore == 1) {
                dateFormatter.dateFormat = showSeconds ? @"昨天 HH:mm:ss" : @"昨天 HH:mm";
                return [dateFormatter stringFromDate:fromDate];
            }
            else if (dayBefore == 2) {
                dateFormatter.dateFormat = showSeconds ? @"前天 HH:mm:ss" : @"前天 HH:mm";
                return [dateFormatter stringFromDate:fromDate];
            }
            else {
                return [NSString stringWithFormat:@"%ld 天前", (long)dayBefore];
            }
        }
        else {
            dateFormatter.dateFormat = @"yyyy";
            NSInteger yearBefore = [calendar components:NSCalendarUnitYear
                                               fromDate:[dateFormatter dateFromString:[dateFormatter stringFromDate:fromDate]]
                                                 toDate:[dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]]
                                                options:0].year;
            if (yearBefore == 0) {
                dateFormatter.dateFormat = showSeconds ? @"MM-dd HH:mm:ss" : @"MM-dd HH:mm";
                return [dateFormatter stringFromDate:fromDate];
            }
            else {
                dateFormatter.dateFormat = showSeconds ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd HH:mm";
                return [dateFormatter stringFromDate:fromDate];
            }
        }
    }
    // 今天
    else if (dayBefore == 0) {
        dateFormatter.dateFormat = @"HH";
        NSString *HH = [dateFormatter stringFromDate:fromDate];
        if (HH.integerValue <= 12) {
            dateFormatter.AMSymbol = @"上午";
            dateFormatter.PMSymbol = @"下午";
            dateFormatter.dateFormat = showSeconds ? @"aaa hh:mm:ss" : @"aaa hh:mm";
            return [dateFormatter stringFromDate:fromDate];
        }
        else {
            dateFormatter.AMSymbol = @"上午";
            dateFormatter.PMSymbol = @"下午";
            dateFormatter.dateFormat = showSeconds ? @"aaa hh:mm:ss" : @"aaa hh:mm";
            return [dateFormatter stringFromDate:fromDate];
        }
    }
    // 将来
    else {
        dateFormatter.dateFormat = showSeconds ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd HH:mm";
        return [dateFormatter stringFromDate:fromDate];
    }
}

@end


















