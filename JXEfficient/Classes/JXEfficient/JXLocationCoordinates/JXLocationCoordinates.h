//
//  JXLocationCoordinates.h
//  JXEfficient
//
//  Created by augsun on 10/17/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/** 定位发起后定位状态 */
typedef NS_ENUM(NSUInteger, JXLocationCoordinatesStatus) {
    JXLocationCoordinatesStatusInPositioning,   ///< 定位中
    JXLocationCoordinatesStatusSuccess,         ///< 定位成功
    JXLocationCoordinatesStatusFailure,         ///< 定位失败
};

@interface JXLocationCoordinates : NSObject

@property (nonatomic, readonly) CLAuthorizationStatus authorizationStatus; ///< 定位授权状态
@property (nonatomic, readonly) JXLocationCoordinatesStatus locationStatus; ///< 定位状态
@property (nonatomic, readonly, nullable) NSArray <CLLocation *> *locations; ///< 定位位置

/**
 第一次调用 updateLocation 及 后继状态改变 该回调必然会回调.
 
     如:返回以下三种情况时 再调用 updateLocation
         kCLAuthorizationStatusNotDetermined
         kCLAuthorizationStatusAuthorizedAlways
         kCLAuthorizationStatusAuthorizedWhenInUse
 
     返回以下二种情况时 需要上层业务提示用户去设置里打开, 如果打开成功 该回调依然会调用.
         kCLAuthorizationStatusRestricted
         kCLAuthorizationStatusDenied
*/
@property (nonatomic, copy) void (^authorizationStatusDidChanged)(CLAuthorizationStatus authorizationStatus);

/**
 定位到经纬度信息 内部会自动停止定位
 */
@property (nonatomic, copy) void (^locationDidUpdate)(JXLocationCoordinatesStatus locationStatus, NSArray <CLLocation *> * _Nullable locations);

/**
 指定初始化方法

 @param accuracy 精度
 @return 定位实例
 */
- (instancetype)initWithCLLocationAccuracy:(CLLocationAccuracy)accuracy;

/**
 开始定位 如果可以定位则直接进行定位 返回定位结果, 如果相关状态不能定位 由 ^authorizationStatusDidChanged 返回相关状态
 */
- (void)updateLocation;

/**
 结束定位 (定位成功也会自行结束定位)
 */
- (void)stopUpdating;

@end

NS_ASSUME_NONNULL_END












