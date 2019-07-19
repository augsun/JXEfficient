//
//  JXTest_JXPhotos_VC.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXPhotos_VC.h"
#import <JXEfficient/JXEfficient.h>
#import <Masonry/Masonry.h>

#import "JXTest_JXPhotos_View.h"

#import "JXPhotos.h"

@interface JXTest_JXPhotos_VC ()

@property (nonatomic, strong) JXTest_JXPhotos_View *bgView;
@property (nonatomic, copy) NSArray <JXTest_JXPhotos_AlbumImageModel *> *models;

@end

@implementation JXTest_JXPhotos_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightButton_enable = YES;
    
    self.bgView = [[JXTest_JXPhotos_View alloc] init];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).with.offset(-JX_UNUSE_AREA_OF_BOTTOM);
    }];
    
    
}

- (void)rightButton_click {
    [JXPhotos requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
            case PHAuthorizationStatusRestricted:
            {
                
            } break;
                
            case PHAuthorizationStatusDenied:
            {
                
            } break;
                
            case PHAuthorizationStatusAuthorized:
            {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];//请求选项设置
                options.resizeMode = PHImageRequestOptionsResizeModeExact;//自定义图片大小的加载模式
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//                options.synchronous = YES;//是否同步加载

                self.models = [JXPhotos fetchImageAssetsWithFetchOptions:nil imageRequestOptions:options assetClass:[JXTest_JXPhotos_AlbumImageModel class]];
                self.bgView.models = self.models;
            } break;
                
            default: break;
        }
    }];
}

@end
