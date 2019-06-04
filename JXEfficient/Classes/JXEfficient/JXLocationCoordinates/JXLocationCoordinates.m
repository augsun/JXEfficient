//
//  JXLocationCoordinates.m
//  JXEfficient
//
//  Created by augsun on 10/17/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import "JXLocationCoordinates.h"

#import "JXMacro.h"

@interface JXLocationCoordinates () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL updating;
@property (nonatomic, strong) NSArray <CLLocation *> *lastUpdatedLocations;
@property (nonatomic, assign) BOOL waitCallBack;
@property (nonatomic, assign) CLLocationAccuracy accuracy;

@property (nonatomic, assign) BOOL firstAuthorizationStatusDidCallback;

@end

@implementation JXLocationCoordinates

- (instancetype)initWithCLLocationAccuracy:(CLLocationAccuracy)accuracy {
    self = [super init];
    if (self) {
        _accuracy = accuracy;
        _authorizationStatus = [CLLocationManager authorizationStatus];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = self.accuracy;
    }
    return self;
}

- (void)updateLocation {
    if (!self.firstAuthorizationStatusDidCallback) {
        self.firstAuthorizationStatusDidCallback = YES;
        JX_BLOCK_EXEC(self.authorizationStatusDidChanged, self.authorizationStatus);
        return ;
    }
    
    if (self.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
        return ;
    }

    if (self.updating) {
        return;
    }
    _updating = YES;
    _locations = nil;
    _lastUpdatedLocations = nil;
    _locationStatus = JXLocationCoordinatesStatusInPositioning;
    JX_BLOCK_EXEC(self.locationDidUpdate, JXLocationCoordinatesStatusInPositioning, nil);
    [self.locationManager startUpdatingLocation];
}

#pragma mark - <CLLocationManagerDelegate>

// 该方法会在极短时间内多次回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 停止定位
    [self.locationManager stopUpdatingLocation];
    
    // 如果没有定位到 CLLocation
    if (!locations || locations.count == 0) {
        [self locationStatusDidChangeCallback:JXLocationCoordinatesStatusFailure locationModel:nil];
        return;
    }
    
    // 保留最后一次回调的 CLLocation
    self.lastUpdatedLocations = locations;
    
    // 非第一次代理回调不再往下执行, 过滤频繁代理回调
    if (self.waitCallBack) {
        return;
    }
    
    // 第一次代理回调执行
    self.waitCallBack = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 没有定位到地理信息
        if (!self.lastUpdatedLocations) {
            [self locationStatusDidChangeCallback:JXLocationCoordinatesStatusFailure locationModel:nil];
            return ;
        }
        
        [self locationStatusDidChangeCallback:JXLocationCoordinatesStatusSuccess locationModel:self.lastUpdatedLocations];
        self.waitCallBack = NO;
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    [self locationStatusDidChangeCallback:JXLocationCoordinatesStatusFailure locationModel:nil];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.authorizationStatus != status) {
        _authorizationStatus = status;
        JX_BLOCK_EXEC(self.authorizationStatusDidChanged, status);
    }
}

- (void)locationStatusDidChangeCallback:(JXLocationCoordinatesStatus)locationStatus locationModel:(NSArray<CLLocation *> *)locations {
    _locationStatus = locationStatus;
    _locations = locations;
    self.updating = NO;
    JX_BLOCK_EXEC(self.locationDidUpdate, locationStatus, locations);
}

- (void)stopUpdating {
    [self.locationManager stopUpdatingLocation];
}

- (void)dealloc {
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

@end

