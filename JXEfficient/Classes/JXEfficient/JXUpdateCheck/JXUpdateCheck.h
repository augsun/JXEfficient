//
//  SBUpdate.h
//  JXEfficient
//
//  Created by augsun on 9/9/15.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXUpdateCheck : NSObject

/**
 检查是否有新版本

 @param appID 检查新版本 APP 对应的 appID
 @param result 检查结果
 */
+ (void)checkAppID:(NSString *)appID result:(nullable void(^)(BOOL haveNew, NSDictionary * _Nullable result0))result;

/**
 检查是否有新版本, 如果有新版本 Alert 提示更新
 */
+ (void)checkAndShowAlertIfNewVersionWithAppId:(NSString *)appID;

/**
 打开 appStore 去升级
 */
+ (BOOL)openAppStoreToUpdateWithAppID:(NSString *)appID;

/**
 打开 appStore 去评分
 */
+ (BOOL)openAppStoreToWriteReviewWithAppID:(NSString *)appID;

@end

NS_ASSUME_NONNULL_END
