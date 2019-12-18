//
//  NSDateFormatter+JXCategory.m
//  AFNetworking
//
//  Created by crlandsun on 2019/12/18.
//

#import "NSDateFormatter+JXCategory.h"

@implementation NSDateFormatter (JXCategory)

+ (instancetype)jx_chinaFormatter {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    df.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return df;
}

@end
