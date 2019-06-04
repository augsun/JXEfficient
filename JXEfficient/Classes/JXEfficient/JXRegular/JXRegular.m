//
//  JXRegular.h
//  JXEfficient
//
//  Created by augsun on 9/9/15.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXRegular.h"

@implementation JXRegular

+ (BOOL)regularPwdLength_6to20_with_aAtozZ_or_0to9:(NSString *)pwd {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Za-z0-9]{6,20}$"] evaluateWithObject:pwd];
}

+ (BOOL)regularEmail:(NSString *)email {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:email];
}

+ (BOOL)regularURL:(NSString *)URL {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?"] evaluateWithObject:URL];
}

+ (BOOL)regularPositiveNumber:(NSString *)number {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]+$"] evaluateWithObject:number];
}

+ (BOOL)regularUnNegativeFloat:(NSString *)unNegativeFloat {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d+(\\.\\d+)?$"] evaluateWithObject:unNegativeFloat];
}

+ (BOOL)regularUserNameLength_3to20_with_aAtozZ_or_0to9:(NSString *)userName {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Za-z0-9]{6,20}$"] evaluateWithObject:userName];
}

+ (BOOL)regularMobile:(NSString *)mobile {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\\d{8}$"] evaluateWithObject:mobile];
}

+ (BOOL)regularAuthCode6Digit:(NSString *)authCode6Digit {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"\\d{6}"] evaluateWithObject:authCode6Digit];
}

+ (BOOL)regularNickName:(NSString *)nickName {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[a-zA-Z0-9\u4e00-\u9fa5]+$"] evaluateWithObject:nickName];
}

+ (BOOL)regularChinese:(NSString *)chinese {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[\u4e00-\u9fa5]+$"] evaluateWithObject:chinese];
}

+ (BOOL)regularHaveSpace:(NSString *)string {
    return ![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(?m)^[\\S]*$"] evaluateWithObject:string];
}

+ (BOOL)regularIsAscii:(NSString *)ascii {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[\x00-\x7F]"] evaluateWithObject:ascii];
}

+ (BOOL)regularNumericAndLetter:(NSString *)string {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Za-z0-9]+$"] evaluateWithObject:string];
}

+ (BOOL)regularLetter:(NSString *)string {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z]+$"] evaluateWithObject:string];
}

+ (NSInteger)regularLengthOfNickName:(NSString *)nickName {
    NSInteger len = nickName.length;
    NSInteger lenActual = 0;
    for (NSInteger i = 0; i < len; i ++) {
        NSString *strChar = [nickName substringWithRange:NSMakeRange(i, 1)];
        if (![self regularIsAscii:strChar]) lenActual += 2;
        else lenActual ++;
    }
    return lenActual;
}

+ (BOOL)regularIDCard:(NSString *)idCard {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\\d]{15}|[\\d]{17}[\\dxX]{1}$"] evaluateWithObject:idCard];
}

@end









