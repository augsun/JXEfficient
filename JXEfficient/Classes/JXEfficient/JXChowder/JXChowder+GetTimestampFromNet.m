//
//  JXChowder+GetTimestampFromNet.m
//  JXEfficient
//
//  Created by augsun on 4/28/19.
//

#import "JXChowder+GetTimestampFromNet.h"

#import "JXInline.h"
#import "JXMacro.h"

@interface JXChowderGetTimestampFromNetModel : NSObject

@property (nonatomic, assign) long long timestamp;

@property (nonatomic, readonly) BOOL success;
@property (nonatomic, readonly) CGFloat diff;

@end

@interface JXChowderGetTimestampFromNetModel ()

@property (nonatomic, assign) NSTimeInterval begin;
@property (nonatomic, assign) NSTimeInterval end;

@end

@implementation JXChowderGetTimestampFromNetModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.begin = CACurrentMediaTime();
    }
    return self;
}

- (void)setTimestamp:(long long)timestamp {
    _timestamp = timestamp;
    
    self.end = CACurrentMediaTime();
    
    _success = YES;
    _diff = self.end - self.begin;
}

@end

@implementation JXChowder (GetTimestampFromNet)

+ (void)jx_getTimestampFromNet:(JXChowderGetTimestampFromNetCompletion)completion {
    JXChowderGetTimestampFromNetModel *model = [[JXChowderGetTimestampFromNetModel alloc] init];
    
    void (^callback)(void) = ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            JX_BLOCK_EXEC(completion, model.success, model.timestamp, model.diff);
        });
    };
    
    [self taobao_get:^(BOOL success, long long timestamp) {
        if (success) {
            model.timestamp = timestamp;
            callback();
        }
        else {
            [self suning_get:^(BOOL success, long long timestamp) {
                if (success) {
                    model.timestamp = timestamp;
                    callback();
                }
                else {
                    callback();
                }
            }];
        }
    }];
}

+ (void)taobao_get:(void (^)(BOOL success, long long timestamp))completion {
    NSURL *URL = [NSURL URLWithString:@"https://api.m.taobao.com/rest/api3.do?api=mtop.common.getTimestamp"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
#if 0
        {
            "api": "mtop.common.getTimestamp",
            "v": "*",
            "ret": [
                    "SUCCESS::接口调用成功"
                    ],
            "data": {
                "t": "1556463806417"
            }
        }
#endif
        long long timestamp = 0;
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = jx_dicValue(json[@"data"]);
                if (data) {
                    long t = jx_longlongValue(data[@"t"]);
                    if (t > 0) {
                        timestamp = t;
                    }
                }
            }
        }
        
        if (timestamp > 0) {
            JX_BLOCK_EXEC(completion, YES, timestamp);
        }
        else {
            JX_BLOCK_EXEC(completion, NO, 0);
        }
    }];
    [task resume];
}

+ (void)suning_get:(void (^)(BOOL success, long long timestamp))completion {
    NSURL *URL = [NSURL URLWithString:@"https://quan.suning.com/getSysTime.do"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
#if 0
        {
            "sysTime2": "2019-04-29 00:01:05",
            "sysTime1": "20190429000105"
        }
#endif
        long long timestamp = 0;
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSString *sysTime2 = jx_strValue(json[@"sysTime2"]);
                if (sysTime2) {
                    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                    fmt.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    NSDate *date = [fmt dateFromString:sysTime2];
                    NSTimeInterval timeInterval = date.timeIntervalSince1970 * 1000;
                    
                    timestamp = timeInterval;
                }
            }
        }
        
        if (timestamp > 0) {
            JX_BLOCK_EXEC(completion, YES, timestamp);
        }
        else {
            JX_BLOCK_EXEC(completion, NO, 0);
        }
    }];
    [task resume];
}

@end

