//
//  JXChowder.m
//  JXEfficient
//
//  Created by augsun on 2/22/19.
//

#import "JXChowder.h"
#import <sys/utsname.h>
#import "JXInline.h"

#import <WebKit/WebKit.h>

@implementation JXChowder

+ (NSString *)msgForNetError:(NSError *)error defaultMsg:(NSString *)defaultMsg {
    NSString *tempMsg = defaultMsg;
    if (error.code == -1009) {
        tempMsg = @"网络似乎已断开，请检查网络！";
    }
    else if (error.code == -1001) {
        tempMsg = @"网络请求超时！";
    }
    else {
        tempMsg = defaultMsg;
    }
    return tempMsg;
}

+ (BOOL)randomBool {
    BOOL ret = arc4random_uniform(2) == 1;
    return ret;
}

+ (NSUInteger)randomUIntegerFrom:(NSUInteger)from to:(NSUInteger)to {
    NSUInteger value = from;
    if (from < to) {
        value = arc4random() % (to - from + 1) + from;
    }
    return value;
}

+ (NSString *)randomStringOfLength:(NSUInteger)length {
    if (length == 0) {
        return nil;
    }
    NSString *str_table = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString * result = [[NSMutableString alloc] initWithCapacity:length];
    for (int i = 0; i < length; i ++) {
        NSInteger index = arc4random() % (str_table.length - 1);
        char c = [str_table characterAtIndex:index];
        NSString *char_str = [NSString stringWithFormat:@"%c", c];
        [result appendString:char_str];
    }
    return result;
}

+ (NSString *)randomHexStringOfLength:(NSUInteger)length {
    if (length == 0) {
        return nil;
    }
    NSString *str_table = @"0123456789abcdef";
    NSMutableString * result = [[NSMutableString alloc] initWithCapacity:length];
    for (int i = 0; i < length; i ++) {
        NSInteger index = arc4random() % (str_table.length - 1);
        char c = [str_table characterAtIndex:index];
        NSString *char_str = [NSString stringWithFormat:@"%c", c];
        [result appendString:char_str];
    }
    return result;
}

+ (NSString *)randomASCII33To126StringOfLength:(NSUInteger)length {
    if (length < 1) {
        return nil;
    }
    
    NSMutableString *temp_m_str = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < length; i ++) {
        int c = (int)[JXChowder randomUIntegerFrom:33 to:126];
        char *c_str = (char *)(&c);
        NSString *ns_str = [NSString stringWithCString:c_str encoding:NSUTF8StringEncoding];
        [temp_m_str appendString:ns_str];
    }
    return temp_m_str;
}

+ (NSString *)deviceModel {
    static NSString *machine = nil;
    if (!machine) {
        struct utsname systemInfo;
        uname(&systemInfo);
        machine = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    }
    return machine;
}

+ (NSString *)appName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = jx_strValue([infoDictionary objectForKey:@"CFBundleDisplayName"]);
    return appName;
}

+ (void)clearWKWebsiteData {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

@end
