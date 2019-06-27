//
//  NSString+JXCategory_URLString.m
//  JXEfficient
//
//  Created by augsun on 6/27/19.
//

#import "NSString+JXCategory_URLString.h"

#import "JXInline.h"

@implementation NSString (JXCategory_URLString)

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
    NSString *decodedStr = self;
    for (NSInteger i = 0; i < 10; i ++) {
        if ([decodedStr containsString:@"%"]) {
            NSString *nowStr = [decodedStr jx_URLDecoded];
            if (nowStr) {
                BOOL didRight = [nowStr isEqualToString:decodedStr];
                if (didRight) {
                    break;
                }
                else {
                    decodedStr = nowStr;
                }
            }
            else {
                break;
            }
        }
        else {
            break;
        }
    }
    return decodedStr;
}

+ (NSDictionary *)jx_URLParamsInURLString:(NSString *)URLString {
    NSURLComponents *comps = [NSURLComponents componentsWithString:URLString];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    for (NSURLQueryItem *itemEnum in comps.queryItems) {
        tempDic[itemEnum.name] = itemEnum.value;
    }
    return [tempDic copy];
}

- (NSString *)jx_URLAddParams:(NSDictionary *)params {
    if (!params || params.allKeys.count == 0) {
        return self;
    }
    
    NSURLComponents *comps = [NSURLComponents componentsWithString:self];
    if (!comps) {
        return self;
    }
    
    NSMutableArray <NSURLQueryItem *> *tempItems = [[NSMutableArray alloc] init]; // 存放无需 URLEncoded 的参数
    NSMutableDictionary *tempURLEncodedParams = [[NSMutableDictionary alloc] init]; // 存放需要 URLEncoded 的参数
    
    // self 中已有参数
    for (NSURLQueryItem *itemEnum in comps.queryItems) {
        NSString *name = itemEnum.name;
        NSString *value = itemEnum.value;
        
        // 参数值中满足以下条件<https:// 等参数情况>需要单独 URLEncoded <注: 解析出来已经是 URLDecoded, 下面再次独立进行 URLEncoded 拼接>
        if ([value containsString:@"://"]) {
            tempURLEncodedParams[name] = value;
        }
        else {
            NSURLQueryItem *queryItem  = [[NSURLQueryItem alloc] initWithName:name value:value];
            [tempItems addObject:queryItem];
        }
    }
    
    // 添加的参数
    for (NSString *keyEnum in params.allKeys) {
        NSString *key = jx_strValue(keyEnum);
        NSString *value = jx_strValue(params[keyEnum]);
        
        if (!key || !value) {
            continue;
        }
        
        // 参数值有 Encoded 过的需要先 URLDecoded <注: 下面再次独立进行 URLEncoded 拼接>
        NSString *URLDecoded = [value jx_URLDecoded_loop];
        if (![value isEqualToString:URLDecoded] || [URLDecoded containsString:@"://"]) {
            tempURLEncodedParams[key] = URLDecoded;
        }
        else {
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:value];
            [tempItems addObject:item];
        }
    }
    
    //
    comps.queryItems = [tempItems copy];
    
    // <独立进行 URLEncoded 拼接>
    BOOL needExtraAppend = tempURLEncodedParams.allKeys.count > 0;
    if (needExtraAppend) {
        NSMutableString *tempURL = [comps.URL.absoluteString mutableCopy];
        if (!tempURL) {
            return nil;
        }
        for (NSDictionary *keyEnum in tempURLEncodedParams) {
            NSString *key = jx_strValue(keyEnum);
            NSString *value = jx_strValue(tempURLEncodedParams[keyEnum]);
            value = [value jx_URLEncoded];
            if (key && value) {
                NSString *param = [NSString stringWithFormat:@"&%@=%@", key, value];
                [tempURL appendString:param];
            }
        }
        return tempURL;
    }
    else {
        return comps.URL.absoluteString;
    }
}

@end
