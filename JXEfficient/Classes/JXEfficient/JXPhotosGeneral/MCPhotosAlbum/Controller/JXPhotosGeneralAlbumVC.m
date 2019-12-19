//
//  JXPhotosGeneralAlbumVC.m
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralAlbumVC.h"

#import "JXMacro.h"
#import "JXPhotos.h"
#import "JXChowder.h"
#import "JXPopupGeneralView.h"
#import "NSLayoutConstraint+JXCategory.h"

#import "JXPhotosGeneralAlbumView.h"
#import "JXPhotosGeneralLayoutVC.h"

@interface JXPhotosGeneralAlbumVC ()

@property (nonatomic, strong) JXPhotosGeneralUsage *usage;

@property (nonatomic, strong) JXPhotosGeneralAlbumView *bgView;
@property (nonatomic, copy) NSArray <JXPhotosGeneralAlbumAssetCollection *> *assetCollections;

@end

@implementation JXPhotosGeneralAlbumVC

- (instancetype)initWithUsage:(JXPhotosGeneralUsage *)usage {
    self = [super init];
    if (self) {
        NSAssert(usage, @"JXPhotosGeneralAlbumVC 构造函数 -[JXPhotosGeneralAlbumVC initWithUsage:] 参数 usage 不能为空");
        self.usage = usage;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSAssert(self.usage, @"JXPhotosGeneralAlbumVC 请使用指定构造函数 -[JXPhotosGeneralAlbumVC initWithUsage:] 实例化.");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // statusAuthorized
    void (^statusAuthorized)(BOOL) = ^ (BOOL fromNotDetermined) {
        switch (self.usage.firstPageTo) {
                // 相机胶卷
            case JXPhotosGeneralFirstPageToCaneralRoll:
            {
                [self pushPhotosLayoutVCWithAssets:nil animated:NO];
            } break;
                
                // 相册列表
            case JXPhotosGeneralFirstPageToAlbum:
            {
                if (!fromNotDetermined) {
                    [self setupBgView];
                }
                [self fetchAssetCollections];
            } break;
                
            default: break;
        }
    };
    
    // statusRestrictedOrDenied
    void (^statusRestrictedOrDenied)(BOOL) = ^ (BOOL fromNotDetermined) {
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
        tipPopView.button0Click = ^{
            [self cancelClick];
        };
        tipPopView.button1Label.text = @"去开启";
        tipPopView.button1Label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        tipPopView.button1Click = ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        };
        tipPopView.hideJustByClicking = YES;
        [tipPopView show];
    };
    
    //
    PHAuthorizationStatus authorizationStatus = [JXPhotos authorizationStatus];
    switch (authorizationStatus) {
        case PHAuthorizationStatusNotDetermined:
        {
            [self setupBgView];
            [JXPhotos requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                    {
                        statusAuthorized(YES);
                    } break;
                        
                    case PHAuthorizationStatusRestricted:
                    case PHAuthorizationStatusDenied:
                    {
                        statusRestrictedOrDenied(YES);
                    } break;
                        
                    default: break;
                }
            }];
        } break;
            
        case PHAuthorizationStatusAuthorized:
        {
            statusAuthorized(NO);
        } break;
            
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            [self setupBgView];
            statusRestrictedOrDenied(NO);
        } break;

        default: break;
    }
}

- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushPhotosLayoutVCWithAssets:(JXPhotosGeneralAlbumAssetCollection *)assetCollection animated:(BOOL)animated {
    JXPhotosGeneralLayoutVC *vc = [[JXPhotosGeneralLayoutVC alloc] init];
    vc.usage = self.usage;
    if (assetCollection) {
        vc.assetCollection = assetCollection;
    }
    else {
        vc.fetchCaneralRollImageAssetForFirstPageToCaneralRollType = ^(void (^ _Nonnull completion)(NSArray<JXPhotosGeneralAsset *> * _Nonnull)) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
                fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
                fetchOptions.sortDescriptors = @[
                                                 [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],
                                                 ];
                PHFetchResult <PHAsset *> *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
                NSMutableArray <JXPhotosGeneralAsset *> *tempArr = nil;
                if (result.count > 0) {
                    tempArr = [[NSMutableArray alloc] init];
                }
                
                for (PHAsset *assetEnum in result) {
                    JXPhotosGeneralAsset *asset = [[JXPhotosGeneralAsset alloc] init];
                    asset.phAsset = assetEnum;
                    
                    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
                    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;

                    asset.imageRequestOptions = imageRequestOptions;
                    [tempArr addObject:asset];
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    JX_BLOCK_EXEC(completion, tempArr);
                });
                
                [self fetchAssetCollections];
            });
        };
    }
    vc.cancelClick = ^{
        [self cancelClick];
    };
    [self.navigationController pushViewController:vc animated:animated];
}

/**
 不在 viewDidLoad 中直接初始化 bgView, 在这单独设置 setupBgView 及 bgView 的懒加载 及 viewDidLoad 中的授权条件判断, 目的是当进入当前页面时 usage 的 firstPageTo 为 FirstPageToCaneralRoll 的情况, 则立即进入 PhotosLayoutVC, 此时 bgView不需要立即初始化, 以达到 PhotosLayoutVC 的最快速加载.
 */
- (void)setupBgView {
    JX_WEAK_SELF;
    if (!_bgView) {
        _bgView = [[JXPhotosGeneralAlbumView alloc] init];
        [self.view addSubview:_bgView];
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [_bgView jx_con_same:NSLayoutAttributeTop equal:self.view m:1.0 c:0.0],
                                                  [_bgView jx_con_same:NSLayoutAttributeLeft equal:self.view m:1.0 c:0.0],
                                                  [_bgView jx_con_same:NSLayoutAttributeRight equal:self.view m:1.0 c:0.0],
                                                  [_bgView jx_con_same:NSLayoutAttributeBottom equal:self.view m:1.0 c:-JX_UNUSE_AREA_OF_BOTTOM],
                                                  ]];
        _bgView.naviBar.rightItem.click = ^{
            JX_STRONG_SELF;
            [self cancelClick];
        };
        _bgView.didSelectAssetCollection = ^(JXPhotosGeneralAlbumAssetCollection * _Nonnull assetCollection) {
            JX_STRONG_SELF;
            [self pushPhotosLayoutVCWithAssets:assetCollection animated:YES];
        };
    }
}

- (JXPhotosGeneralAlbumView *)bgView {
    if (!_bgView) {
        [self setupBgView];
    }
    return _bgView;
}

- (void)fetchAssetCollections {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],
                                         ];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
        
        PHFetchResult <PHAssetCollection *> *result_smartAlbum =
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                 subtype:PHAssetCollectionSubtypeAny
                                                 options:nil];
        
        PHFetchResult <PHAssetCollection *> *result_album =
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                 subtype:PHAssetCollectionSubtypeAlbumRegular
                                                 options:nil];
        
        //
        JXPhotosGeneralAlbumAssetCollection * _Nullable (^jxPhotosAlbumAssetCollection)(PHAssetCollection *) = ^(PHAssetCollection *phAssetCollection)
        {
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            fetchOptions.sortDescriptors = @[
                                             [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],
                                             ];
            PHFetchResult <PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:phAssetCollection options:fetchOptions];
            
            // assets
            JXPhotosGeneralAlbumAssetCollection *assetCollection = nil;
            NSMutableArray <JXPhotosGeneralAsset *> *tempArr_assets = nil;
            
            if (assets.count > 0) {
                tempArr_assets = [[NSMutableArray alloc] init];
                for (PHAsset *assetEnum in assets) {
                    JXPhotosGeneralAsset *asset = [[JXPhotosGeneralAsset alloc] init];
                    asset.phAsset = assetEnum;
                    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
                    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
                    
                    asset.imageRequestOptions = imageRequestOptions;
                    
                    [tempArr_assets addObject:asset];
                }
            }
            
            if (tempArr_assets.count > 0) {
                assetCollection = [[JXPhotosGeneralAlbumAssetCollection alloc] init];
                assetCollection.phAssetCollection = phAssetCollection;
                assetCollection.assets = tempArr_assets;
                
                PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
                imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
                
                assetCollection.thumbImageRequestOptions = imageRequestOptions;
                assetCollection.thumbImageAsset = tempArr_assets.lastObject;
            }
            
            return assetCollection;
        };
        
        //
        NSMutableArray <JXPhotosGeneralAlbumAssetCollection *> *tempArr_collections = [[NSMutableArray alloc] init];
        
        // collections
        for (PHAssetCollection *collectionEnum in result_smartAlbum) {
            JXPhotosGeneralAlbumAssetCollection *assetCollection = jxPhotosAlbumAssetCollection(collectionEnum);
            if (assetCollection) {
                [tempArr_collections addObject:assetCollection];
            }
        }
        for (PHAssetCollection *collectionEnum in result_album) {
            JXPhotosGeneralAlbumAssetCollection *assetCollection = jxPhotosAlbumAssetCollection(collectionEnum);
            if (assetCollection) {
                [tempArr_collections addObject:assetCollection];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bgView.assetCollections = tempArr_collections.count == 0 ? nil : tempArr_collections;
        });
    });
}

@end
