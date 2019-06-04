//
//  JXQRCodeScannerView.h
//  JXEfficient
//
//  Created by augsun on 12/2/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXQRCodeScanView : UIView

/**
 媒体权限
 */
@property (nonatomic, readonly) AVAuthorizationStatus status;

/**
 扫描到的字符串信息, 如果需要结束扫描 外部调用 -stopRunning:
 */
@property (nonatomic, copy) void (^didOutputStringValue)(NSString *stringValue);

/**
 配置

 @param metadataObjectTypes 为 AVMetadataObjectType 数组
 @return 返回是否初始化成功, 失败原因有 status 被限制, metadataObjectTypes 为空或不支持.
 */
- (BOOL)configScannerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes;


/**
 开始扫描
 */
- (void)startRunning;
@property (nonatomic, readonly) BOOL running; ///< 是否正在扫描

/**
 结束扫描
 */
- (void)stopRunning;

@end

NS_ASSUME_NONNULL_END
