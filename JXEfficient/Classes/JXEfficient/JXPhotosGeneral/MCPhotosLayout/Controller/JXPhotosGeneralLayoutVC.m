//
//  JXPhotosGeneralLayoutVC.m
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralLayoutVC.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"
#import "UIViewController+JXCategory.h"
#import "JXSystemAlert.h"
#import "UIView+JXToastAndProgressHUD.h"
#import "UIView+JXCategory.h"

#import "JXPhotosGeneralLayoutView.h"
#import "JXPhotosGeneralPreviewVC.h"

@interface JXPhotosGeneralLayoutVC ()

@property (nonatomic, strong) JXPhotosGeneralLayoutView *bgView;

@property (nonatomic, strong) NSMutableArray <JXPhotosGeneralAsset *> *assets;
@property (nonatomic, strong) NSMutableArray <JXPhotosGeneralAsset *> *selectedAssets;

@property (nonatomic, strong) NSLayoutConstraint *toL;
@property (nonatomic, strong) NSLayoutConstraint *toR;

@end

@implementation JXPhotosGeneralLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    JX_WEAK_SELF;
    
    self.bgView = [[JXPhotosGeneralLayoutView alloc] initWithUsage:self.usage];
    [self.view addSubview:self.bgView];
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.toL = [self.bgView jx_con_same:NSLayoutAttributeLeft equal:self.view m:1.0 c:0.0];
    self.toR = [self.bgView jx_con_same:NSLayoutAttributeRight equal:self.view m:1.0 c:0.0];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.bgView jx_con_same:NSLayoutAttributeTop equal:self.view m:1.0 c:0.0],
                                              self.toL,
                                              self.toR,
                                              [self.bgView jx_con_same:NSLayoutAttributeBottom equal:self.view m:1.0 c:0.0],
                                              ]];
    NSString *title = self.assetCollection ? self.assetCollection.phAssetCollection.localizedTitle : @"相机胶卷";
    [self.bgView.naviBar.titleItem setTitle:title color:JX_COLOR_HEX(0x333333) font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium]];
    self.bgView.naviBar.backItem.click = ^{                                                                                             // 返回
        JX_STRONG_SELF;
        [self jx_popVC];
    };
    self.bgView.naviBar.rightItem.click = ^{                                                                                            // 取消
        JX_STRONG_SELF;
        JX_BLOCK_EXEC(self.cancelClick);
    };
    self.bgView.layoutView.didSelectItemAtIndex = ^(NSInteger index, __kindof JXPhotosGeneralAsset * _Nonnull asset) {                         // 非右上角选中 预览
        JX_STRONG_SELF;
        [self didSelectItemAtIndex:index asset:asset];
    };
    
    switch (self.usage.selectionType) {
        case JXPhotosGeneralLayoutSelectionTypeMulti:
        {
            self.bgView.bottomBarView.leftButtonEnable = NO;
            self.bgView.bottomBarView.rightButtonEnable = NO;
            NSString *rightTitle = nil;
            if (self.usage.maximumNumberOfChoices > 1) {
                rightTitle = [NSString stringWithFormat:@"发送(0/%ld)", self.usage.maximumNumberOfChoices];
            }
            else {
                rightTitle = @"发送";
            }
            self.bgView.bottomBarView.rightTitle = rightTitle;
        } break;
            
        case JXPhotosGeneralLayoutSelectionTypeSingle:
        {
            
        } break;
            
        default: break;
    }
    self.bgView.selectClick = ^(JXPhotosGeneralAsset * _Nonnull asset) {                                                                       // 右上角选中
        JX_STRONG_SELF;
        [self selClick:asset inVC:self];
    };
    self.bgView.bottomBarView.leftClick = ^{                                                                                            // 底部 预览
        JX_STRONG_SELF;
        [self previewInSselectedAssets:self.selectedAssets];
    };
    self.bgView.bottomBarView.rightClick = ^{                                                                                           // 底部 发送
        JX_STRONG_SELF;
        self.view.userInteractionEnabled = NO;
        [self sendAndShowingProgressInView:self.bgView didSent:nil];
    };
    if (self.assetCollection) {
        self.assets = [self.assetCollection.assets mutableCopy];
        [self.bgView refreshUIWithAssets:self.assets];
    }
    else {
        if (self.fetchCaneralRollImageAssetForFirstPageToCaneralRollType) {
            self.fetchCaneralRollImageAssetForFirstPageToCaneralRollType(^(NSArray<JXPhotosGeneralAsset *> * _Nonnull assets) {
                self.assets = [assets mutableCopy];
                [self.bgView refreshUIWithAssets:self.assets];
            });
        }
    }
}

- (BOOL)selClick:(JXPhotosGeneralAsset *)asset inVC:(UIViewController *)inVC {
    switch (self.usage.selectionType) {
        case JXPhotosGeneralLayoutSelectionTypeSingle:
        {
            self.selectedAssets.firstObject.selected = NO;
            asset.selected = YES;
            [self.selectedAssets removeAllObjects];
            [self.selectedAssets addObject:asset];
        } break;
            
        case JXPhotosGeneralLayoutSelectionTypeMulti:
        {
            if (asset.covered) {
                [JXSystemAlert alertFromVC:inVC
                                     title:[NSString stringWithFormat:@"您最多只能选择 %ld 张图片", self.usage.maximumNumberOfChoices]
                                   message:nil
                               cancelTitle:@"我知道了"
                             cancelHandler:nil];
                return YES;
            }
            if ([self.selectedAssets containsObject:asset]) {
                asset.selected = NO;
                [self.selectedAssets removeObject:asset];
            }
            else {
                asset.selected = YES;
                [self.selectedAssets addObject:asset];
            }
            
            for (NSInteger i = 0; i < self.selectedAssets.count; i ++) {
                JXPhotosGeneralAsset *assetEnum = self.selectedAssets[i];
                assetEnum.selectedIndex = i + 1;
            }
            
            BOOL toMax = NO;
            if (self.usage.maximumNumberOfChoices > 0) {
                if (self.selectedAssets.count >= self.usage.maximumNumberOfChoices) {
                    toMax = YES;
                }
                
                for (JXPhotosGeneralAsset *assetEnum in self.assets) {
                    if (!assetEnum.selected) {
                        if (toMax) {
                            assetEnum.covered = YES;
                        }
                        else {
                            assetEnum.covered = NO;
                        }
                    }
                }
            }
        } break;
            
        default: break;
    }
    
    //
    switch (self.usage.selectionType) {
        case JXPhotosGeneralLayoutSelectionTypeMulti:
        {
            if (self.selectedAssets.count == 0) {
                self.bgView.bottomBarView.leftButtonEnable = NO;
                self.bgView.bottomBarView.rightButtonEnable = NO;
                self.bgView.bottomBarView.rightTitle = [NSString stringWithFormat:@"发送(%ld/%ld)", self.selectedAssets.count, self.usage.maximumNumberOfChoices];
            }
            else {
                self.bgView.bottomBarView.leftButtonEnable = YES;
                self.bgView.bottomBarView.rightButtonEnable = YES;
                if (self.usage.maximumNumberOfChoices > 1) {
                    self.bgView.bottomBarView.rightTitle = [NSString stringWithFormat:@"发送(%ld/%ld)", self.selectedAssets.count, self.usage.maximumNumberOfChoices];
                }
                else {
                    self.bgView.bottomBarView.rightTitle = [NSString stringWithFormat:@"发送(%ld)", self.selectedAssets.count];
                }
            }
        } break;
            
        case JXPhotosGeneralLayoutSelectionTypeSingle:
        {
            
        } break;
            
        default: break;
    }
    
    //
    [self.bgView.layoutView.collectionView reloadData];
    
    return NO;
}

- (void)didSelectItemAtIndex:(NSInteger)index asset:(JXPhotosGeneralAsset *)asset {
    if (asset.covered) {
        return;
    }
    [self previewInAlbumAssets:self.assets selectedAssets:self.selectedAssets clickAsset:asset];
}

- (void)previewInAlbumAssets:(NSMutableArray <JXPhotosGeneralAsset *> *)albumAssets
              selectedAssets:(NSMutableArray <JXPhotosGeneralAsset *> *)sselectedAssets
                  clickAsset:(JXPhotosGeneralAsset *)clickAsset
{
    JXPhotosGeneralPreviewVC *vc = [self previewVC];
    [vc previewInAlbumAssets:albumAssets selectedAssets:sselectedAssets clickAsset:clickAsset usage:self.usage];
}

- (void)previewInSselectedAssets:(NSMutableArray <JXPhotosGeneralAsset *> *)selectedAssets {
    JXPhotosGeneralPreviewVC *vc = [self previewVC];
    [vc previewInSelectedAssets:selectedAssets usage:self.usage];
}

- (JXPhotosGeneralPreviewVC *)previewVC {
    JXPhotosGeneralPreviewVC *vc = [[JXPhotosGeneralPreviewVC alloc] init];
    vc.pageOpenAnimationBegin = ^JXPhotosGeneralPreviewVCPageOpenAnimationEnd _Nonnull(CGFloat duration, UIViewAnimationOptions options) {
        [self toLeft:YES animated:YES duration:duration options:options];
        JXPhotosGeneralPreviewVCPageOpenAnimationEnd pageOpenAnimationEnd = ^ {
            [self toLeft:NO animated:NO duration:duration options:options];
        };
        return pageOpenAnimationEnd;
    };
    vc.pageWillBackAnimationBegin = ^(CGFloat duration, UIViewAnimationOptions options) {
        [self toLeft:YES animated:NO duration:duration options:options];
        [self toLeft:NO animated:YES duration:duration options:options];
    };
    jx_weakify(vc)
    vc.assetClick = ^(JXPhotosGeneralAsset * _Nonnull asset, void (^ _Nonnull returnNewSelectedAssets)(BOOL, NSArray<JXPhotosGeneralAsset *> * _Nonnull)) {
        jx_strongify(vc)
        BOOL toMaximumNumberOfChoices = [self selClick:asset inVC:vc];
        JX_BLOCK_EXEC(returnNewSelectedAssets, toMaximumNumberOfChoices, self.selectedAssets);
    };
    vc.sendClick = ^(UIView * _Nonnull progressShowingView, void (^ _Nonnull didSent)(void)) {
        [self sendAndShowingProgressInView:progressShowingView didSent:^{
            JX_BLOCK_EXEC(didSent);
        }];
    };
    return vc;
}

- (void)sendAndShowingProgressInView:(UIView *)inView didSent:(void (^)(void))didSent {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    CGSize targetSize = PHImageManagerMaximumSize;
    PHImageContentMode contentMode = PHImageContentModeAspectFit;
    if (self.usage.largeImageMaximumSize.width > 0.0 && self.usage.largeImageMaximumSize.height > 0.0) {
        targetSize = self.usage.largeImageMaximumSize;
        contentMode = PHImageContentModeAspectFit;
    }
    else if (self.usage.largeImageMinimumSize.width > 0.0 && self.usage.largeImageMinimumSize.height > 0.0) {
        targetSize = self.usage.largeImageMinimumSize;
        contentMode = PHImageContentModeAspectFill;
    }
    
    [inView jx_showProgressHUD:@"处理中，请稍候..."];
    
    void (^done)(void) = ^ {
        JX_BLOCK_EXEC(self.usage.selectedPhotos, self.selectedAssets);
        JX_BLOCK_EXEC(self.cancelClick);
        JX_BLOCK_EXEC(didSent);
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (JXPhotosGeneralAsset *assetEnum in self.selectedAssets) {
            [[PHImageManager defaultManager] requestImageForAsset:assetEnum.phAsset
                                                       targetSize:targetSize
                                                      contentMode:contentMode
                                                          options:imageRequestOptions
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
             {
                 assetEnum.largeImage = result;
                 assetEnum.largeImageInfo = info;
             }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            done();
        });
    });
}

- (void)toLeft:(BOOL)toLeft animated:(BOOL)animated duration:(CGFloat)duration options:(UIViewAnimationOptions)options {
    if (toLeft) {
        self.toL.constant = -self.view.jx_width / 2.0;
        self.toR.constant = -self.view.jx_width / 2.0;
    }
    else {
        self.toL.constant = 0.0;
        self.toR.constant = 0.0;
    }
    if (animated) {
        [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    else {
        [self.view layoutIfNeeded];
    }
}

- (NSMutableArray<JXPhotosGeneralAsset *> *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    return _selectedAssets;
}

@end
