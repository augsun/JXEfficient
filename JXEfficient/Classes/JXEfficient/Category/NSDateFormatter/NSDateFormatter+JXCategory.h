//
//  NSDateFormatter+JXCategory.h
//  AFNetworking
//
//  Created by crlandsun on 2019/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (JXCategory)

/// china 日期格式 <locale: zh, timeZone: Asia/Shanghai, calendar: NSCalendarIdentifierGregorian>
+ (instancetype)jx_chinaFormatter;

@end

NS_ASSUME_NONNULL_END
