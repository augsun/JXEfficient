//
//  NSNumber+JXCategory.m
//  AFNetworking
//
//  Created by crlandsun on 2020/4/20.
//

#import "NSNumber+JXCategory.h"

@implementation NSNumber (JXCategory)

+ (NSDecimalNumber *)jx_numberForPrice:(CGFloat)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumIntegerDigits = 1;
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 2;
    NSString *s = [formatter stringFromNumber:@(num)];
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:s];
    return n;
}

@end
