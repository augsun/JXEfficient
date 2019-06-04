//
//  NSString+JXCategory.m
//  JXEfficient
//
//  Created by augsun on 8/3/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "NSString+JXCategory.h"
#import <CommonCrypto/CommonDigest.h>
#import "JXInline.h"

@implementation NSString (JXCategory)

- (NSString *)jx_md5String {
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [mutableString appendFormat:@"%02x", bytes[i]];
    }
    return [NSString stringWithString:mutableString];

}

- (NSComparisonResult)jx_compareToVersionString:(NSString *)version {
    version = jx_strValue(version);
    
    if (version.length == 0) {
        return NSOrderedDescending;
    }
    
    NSMutableArray *leftFields = [[NSMutableArray alloc] initWithArray:[self componentsSeparatedByString:@"."]];
    NSMutableArray *rightFields = [[NSMutableArray alloc] initWithArray:[version componentsSeparatedByString:@"."]];
    
    if (leftFields.count < rightFields.count) {
        while (leftFields.count != rightFields.count) {
            [leftFields addObject:@"0"];
        }
    } else if (leftFields.count > rightFields.count) {
        while (leftFields.count != rightFields.count) {
            [rightFields addObject:@"0"];
        }
    }
    
    NSComparisonResult result = NSOrderedSame;
    for (NSUInteger i = 0; i < leftFields.count; i++) {
        result = [leftFields[i] compare:rightFields[i] options:NSNumericSearch];
        if (result != NSOrderedSame) {
            break;
        }
    }
    
    return result;
}

- (NSString *)jx_URLEncoded {
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]^\"`<> {}\\|";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;

    // deprecated in iOS 9.0
//    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                 (CFStringRef)self,
//                                                                                 NULL,
//                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                                 kCFStringEncodingUTF8));
}

- (NSString *)jx_URLDecoded {
    NSString *decoded = [self stringByRemovingPercentEncoding];
    return decoded;
    
    // deprecated in iOS 9.0
//    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
//                                                                                                 (__bridge CFStringRef)self,
//                                                                                                 CFSTR(""),
//                                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

- (NSString *)jx_URLDecoded_loop {
    BOOL didRight = NO;
    NSString *preStr = self;
    for (NSInteger i = 0; i < 10; i ++) {
        NSString *nowStr = [preStr jx_URLDecoded];
        didRight = [nowStr isEqualToString:preStr];
        if (didRight) {
            break;
        }
        else {
            preStr = nowStr;
        }
    }
    return preStr;
}

+ (NSDictionary *)jx_paramsForURLString:(NSString *)URLString {
    NSURLComponents *comps = [NSURLComponents componentsWithString:URLString];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    for (NSURLQueryItem *itemEnum in comps.queryItems) {
        tempDic[itemEnum.name] = itemEnum.value;
    }
    return [tempDic copy];
}

- (CGFloat)jx_widthForFont:(UIFont *)font {
    if (!font || ![font isKindOfClass:[UIFont class]]) {
        return 0.0;
    }
    
    CGSize size = CGSizeMake(HUGE, HUGE);
    NSMutableDictionary *tempMDic = [[NSMutableDictionary alloc] init];
    tempMDic[NSFontAttributeName] = font;
    CGFloat width = [self boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:tempMDic
                                       context:nil].size.width;
    return width;
}

+ (NSString *)jx_decimalStyle:(CGFloat)num {
    return [NSNumberFormatter localizedStringFromNumber:@(num) numberStyle:NSNumberFormatterDecimalStyle];
}

+ (NSString *)jx_priceString:(CGFloat)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumIntegerDigits = 1;
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 0;
    return [formatter stringFromNumber:@(num)];
}

+ (NSString *)jx_priceStyleString:(CGFloat)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumIntegerDigits = 1;
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 0;
    formatter.positivePrefix = @"¥";
    formatter.negativePrefix = @"¥";
    return [formatter stringFromNumber:@(num)];
}

+ (NSString *)jx_priceDecimalString:(CGFloat)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumIntegerDigits = 1;
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 0;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:@(num)];
}

+ (NSString *)jx_priceDecimalStyleString:(CGFloat)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumIntegerDigits = 1;
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 0;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.positivePrefix = @"¥";
    formatter.negativePrefix = @"¥";
    formatter.negativeFormat = @"¥-";
    return [formatter stringFromNumber:@(num)];
}

- (NSString *)jx_stringByTrimmingWhitespaceAndNewlineCharacter {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newText = [self stringByTrimmingCharactersInSet:set];
    return newText;
}

@end










