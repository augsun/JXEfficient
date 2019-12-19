//
//  JXTest_JXPhotosGeneral_VC.m
//  JXEfficient
//
//  Created by crlandsun on 2019/12/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXPhotosGeneral_VC.h"

#import <JXEfficient/JXEfficient.h>

@interface JXTest_JXPhotosGeneral_VC ()

@end

@implementation JXTest_JXPhotosGeneral_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightButton_enable = YES;

}

- (void)rightButton_click {
    BOOL fromNotDetermined = NO; // 是否初次状态为 NotDetermined
    if ([JXPhotos authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        fromNotDetermined = YES;
    }

    [JXPhotos requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
            {
                JXPhotosGeneralUsage *usage = [[JXPhotosGeneralUsage alloc] init];
                usage.maximumNumberOfChoices = 9;
                usage.largeImageMinimumSize = CGSizeMake(1200, 1200);
                usage.firstPageTo = JXPhotosGeneralFirstPageToCaneralRoll;
                usage.selectionType = JXPhotosGeneralLayoutSelectionTypeMulti;
                usage.selectedPhotos = ^(NSArray<JXPhotosGeneralAsset *> * _Nonnull assets) {
                    NSMutableArray <UIImage *> *tempArr = [[NSMutableArray alloc] init];
                    for (JXPhotosGeneralAsset *assetEnum in assets) {
                        [tempArr addObject:assetEnum.largeImage];
                    }
//                    [self uploadImages:tempArr];
                };
                
                [JXPhotosGeneral photosWithUsage:usage inVC:self];
            } break;
                
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                NSMutableString *tip = [[NSMutableString alloc] init];
                if (fromNotDetermined) {
                    [tip appendString:@"您拒绝了相册访问权限，"];
                }
                NSString *appName = [JXChowder appName];
                if (appName) {
                    [tip appendString:[NSString stringWithFormat:@"请在 iPhone 的 \"设置-隐私-照片\" 选项中，允许 %@ 访问您的手机相册。", appName]];
                }
                else {
                    [tip appendString:@"请在 iPhone 的 \"设置-隐私-照片\" 选项中，允许访问您的手机相册。"];
                }
                JXPopupGeneralView *tipPopView = [[JXPopupGeneralView alloc] init];
                tipPopView.titleLabel.text = tip;
                tipPopView.popupBgViewToLR = 50.0;
                tipPopView.titleViewEdgeInsets = UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0);
                tipPopView.button0Label.text = @"取消";
                tipPopView.button1Label.text = @"去开启";
                tipPopView.button1Label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
                tipPopView.button1Click = ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                };
                tipPopView.hideJustByClicking = YES;
                [tipPopView show];
            } break;
                
            default: break;
        }
    }];

}

@end
