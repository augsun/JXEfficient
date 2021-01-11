//
//  JXPhotosGeneral.h
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JXPhotosGeneralUsage.h>

NS_ASSUME_NONNULL_BEGIN

/**
 相册功能入口
 
 @discussion 暂不支持 gif 图的动效展示. 在收到内存警告时内部会释放大图.
 
 @warning 使用该功能时 必须在 Info.plist 中添加 NSPhotoLibraryUsageDescription.
 */
@interface JXPhotosGeneral : NSObject

/**
 展示手机相册并选取图片. 根据参数 usage 可配置不同场景图片选择模式.
 
 @param usage 使用配置
 @param inVC 基于所在控制器
 @warning 在调用该方法前, 最好让 APP 的相册的授权状态为 PHAuthorizationStatusAuthorized, 示例代码如下: 否则使用内部默认授权状态弹窗.
 @code
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
                [self uploadImages:tempArr];
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
 @endcode
 */
+ (void)photosWithUsage:(JXPhotosGeneralUsage *)usage inVC:(UIViewController *)inVC;

@end

NS_ASSUME_NONNULL_END
