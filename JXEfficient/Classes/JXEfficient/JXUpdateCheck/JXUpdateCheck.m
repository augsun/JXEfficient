//
//  SBUpdate.m
//  JXEfficient
//
//  Created by augsun on 9/9/15.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXUpdateCheck.h"
#import <UIKit/UIKit.h>
#import "JXInline.h"

static NSString *const kAppStoreLookup = @"https://itunes.apple.com/lookup?id=";
static NSString *const kAppStoreLink = @"https://itunes.apple.com/app/id";
static NSString *const kAppStoreReview = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&onlyLatestVersion=false&sortOrdering=2&type=Purple+Software&mt=8";

@implementation JXUpdateCheck

+ (void)checkAppID:(NSString *)appID result:(void (^)(BOOL, NSDictionary * _Nullable))result {
    if (![self validAppID:appID]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAppStoreLookup, appID]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    cfg.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            return ;
        }
        
        id dicLookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (![dicLookup isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        
        if (![dicLookup[@"results"] isKindOfClass:[NSArray class]]) {
            return ;
        }
        
        if ([dicLookup[@"results"] count] == 0) {
            return ;
        }
        
        // 商店版本
        NSString *appStoreVersion = [NSString stringWithFormat:@"%@", [dicLookup[@"results"] firstObject][@"version"]];
        // 当前版本
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        // 更新文案
        NSDictionary *resultsDic = [dicLookup[@"results"] firstObject];

        //
        BOOL haveNew = [self haveNewVerWithAppStoreVersion:appStoreVersion currentVersion:currentVersion];

        // 有新版本
        dispatch_async(dispatch_get_main_queue(), ^{
            !result ? : result(haveNew, resultsDic);
        });
    }];
    [task resume];
}

+ (void)checkAndShowAlertIfNewVersionWithAppId:(NSString *)appID {
    if (![self validAppID:appID]) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkAppID:appID result:^(BOOL haveNew, NSDictionary *result) {
            if (haveNew) {
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"发现新版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionNextTime = [UIAlertAction actionWithTitle:@"下次提醒我" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *actionUpdate = [UIAlertAction actionWithTitle:@"去 AppStore 更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self openAppStoreToUpdateWithAppID:appID];
                }];
                [alertCtl addAction:actionNextTime];
                [alertCtl addAction:actionUpdate];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtl animated:YES completion:nil];
            }
        }];
    });
}

+ (BOOL)openAppStoreToUpdateWithAppID:(NSString *)appID {
    return [self openUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAppStoreLink, appID]]];
}

+ (BOOL)openAppStoreToWriteReviewWithAppID:(NSString *)appID {
    return [self openUrl:[NSURL URLWithString:[NSString stringWithFormat:kAppStoreReview, appID]]];
}

+ (BOOL)openUrl:(NSURL *)url {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)validAppID:(NSString *)appID {
    return [appID isKindOfClass:[NSString class]] && appID.length > 0;
}

+ (BOOL)haveNewVerWithAppStoreVersion:(NSString *)appStoreVersion currentVersion:(NSString *)currentVersion {
    NSArray <NSString *> *arr_appStoreVersion = [appStoreVersion componentsSeparatedByString:@"."];
    NSArray <NSString *> *arr_currentVersion = [currentVersion componentsSeparatedByString:@"."];
    
    NSInteger appStore_count = arr_appStoreVersion.count;
    NSInteger current_count = arr_currentVersion.count;
    NSInteger max_count = MAX(arr_appStoreVersion.count, arr_currentVersion.count);
    
    BOOL haveNew = NO;
    for (NSInteger i = 0; i < max_count; i ++) {
        //
        if (i < appStore_count && i < current_count) {                  // 长度相等部分
            NSInteger appStore_sub_v = jx_intValue(arr_appStoreVersion[i]);
            NSInteger current_sub_v = jx_intValue(arr_currentVersion[i]);
            
            if (appStore_sub_v > current_sub_v) {                       // 分割后版本号 (大于当前版本 有新版本 )
                haveNew = YES;
                break;
            }
            else if (appStore_sub_v < current_sub_v) {                  // 分割后版本号 (小于当前版本 无新版本 )
                haveNew = NO;
                break;
            }
        }
        else if (i >= appStore_count && i < current_count) {            // 长度不等部分 current 版本号更长 <不存在>
            
        }
        else if (i < appStore_count && i >= current_count) {            // 长度不等部分 appStore 版本号更长
            haveNew = YES;
        }
    }
    return haveNew;
}

@end



















