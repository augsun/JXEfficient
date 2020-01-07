//
//  JXPhotosGeneralPreviewVC.m
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralPreviewVC.h"

#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "UIView+JXCategory.h"

#import "JXPhotosGeneralPreviewView.h"
#import "JXPhotosGeneralPreviewViewCell.h"

static const CGFloat k_pageAnimationDuration = 0.3;
static const UIViewAnimationOptions k_pageAnimationOptions = UIViewAnimationOptionCurveEaseOut;

typedef NS_ENUM(NSUInteger, JXPhotosGeneralPreviewIn) {
    JXPhotosGeneralPreviewInAlbumAssets,
    JXPhotosGeneralPreviewInSelectedAssets,
};

@interface JXPhotosGeneralPreviewVC () <UIScrollViewDelegate>

@property (nonatomic, assign) JXPhotosGeneralPreviewIn previewIn;

@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) JXPhotosGeneralPreviewVC *bgVC;
@property (nonatomic, strong) JXPhotosGeneralPreviewView *bgView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) JXPhotosGeneralUsage *usage;

@property (nonatomic, copy) NSArray <JXPhotosGeneralAsset *> *albumAssets;
@property (nonatomic, copy) NSArray <JXPhotosGeneralAsset *> *selectedAssets;
@property (nonatomic, strong) JXPhotosGeneralAsset *clickAsset;

@property (nonatomic, copy) NSArray <JXPhotosGeneralAsset *> *showingAssets;
@property (nonatomic, strong) NSMutableArray <JXPhotosGeneralPreviewBottomTagModel *> *tagModels;

@property (nonatomic, strong) NSLayoutConstraint *toL;
@property (nonatomic, strong) NSLayoutConstraint *toR;

@end

@implementation JXPhotosGeneralPreviewVC

- (void)previewInAlbumAssets:(NSArray<JXPhotosGeneralAsset *> *)albumAssets
              selectedAssets:(NSArray<JXPhotosGeneralAsset *> *)selectedAssets
                  clickAsset:(JXPhotosGeneralAsset *)clickAsset
                       usage:(JXPhotosGeneralUsage *)usage
{
    self.previewIn = JXPhotosGeneralPreviewInAlbumAssets;
    self.selectedAssets = selectedAssets;
    self.showingAssets = albumAssets;
    self.clickAsset = clickAsset;
    self.usage = usage;
    
    //
    [self setupWindow];
}

- (void)previewInSelectedAssets:(NSArray<JXPhotosGeneralAsset *> *)selectedAssets
                          usage:(JXPhotosGeneralUsage *)usage
{
    self.previewIn = JXPhotosGeneralPreviewInSelectedAssets;
    self.selectedAssets = selectedAssets;
    self.showingAssets = selectedAssets;
    self.usage = usage;
    
    //
    [self setupWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    //
    [self setupBgView];
    
    //
    [self startPreview];
}

- (void)setupWindow {
    self.bgWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgWindow.windowLevel = UIWindowLevelStatusBar;
    self.bgWindow.backgroundColor = [UIColor clearColor];
    self.bgWindow.rootViewController = self;
    self.bgWindow.hidden = NO;
}

- (void)setupBgView {
    JX_WEAK_SELF;
    self.bgView = [[JXPhotosGeneralPreviewView alloc] initWithUsage:self.usage];
    [self.view addSubview:self.bgView];
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.toL = [self.bgView jx_con_same:NSLayoutAttributeLeft equal:self.view m:1.0 c:self.view.jx_width];
    self.toR = [self.bgView jx_con_same:NSLayoutAttributeRight equal:self.view m:1.0 c:self.view.jx_width];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.bgView jx_con_same:NSLayoutAttributeTop equal:self.view m:1.0 c:0.0],
                                              self.toL,
                                              self.toR,
                                              [self.bgView jx_con_same:NSLayoutAttributeBottom equal:self.view m:1.0 c:0.0],
//                                              [self.bgView jx_con_same:NSLayoutAttributeBottom equal:self.view m:1.0 c:-JX_UNUSE_AREA_OF_BOTTOM],
                                              ]];
    self.bgView.backgroundColor = [UIColor blackColor];
    
#pragma mark 返回
    self.bgView.naviView.backClick = ^{
        JX_STRONG_SELF;
        JX_BLOCK_EXEC(self.pageWillBackAnimationBegin, k_pageAnimationDuration, k_pageAnimationOptions);
        [UIView animateWithDuration:k_pageAnimationDuration delay:0.0 options:k_pageAnimationOptions animations:^{
            self.toL.constant = self.view.jx_width;
            self.toR.constant = self.view.jx_width;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
            self.bgWindow = nil;
        }];
    };
    
#pragma mark 拖动中
    self.bgView.dragChanged = ^(CGFloat percent, BOOL needAnimation) {
        JX_STRONG_SELF;
        if (percent < 0.0) { percent = 0.0; }
        else if (percent > 1.0) { percent = 1.0; }
        
        if (needAnimation) {
            [UIView animateWithDuration:.25f animations:^{
                self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0 - percent];
            }];
        }
        else {
            self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0 - percent];
        }
    };
    
#pragma mark 拖动开始
    self.bgView.dragBegan = ^{
        JX_STRONG_SELF;
        [self.bgView setFullShow:YES animated:YES];
    };
    
#pragma mark 拖动结束
    self.bgView.dragEnded = ^(BOOL forHidden) {
        JX_STRONG_SELF;
        if (forHidden) {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.bgView.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                [self.bgView removeFromSuperview];
                self.bgWindow = nil;
            }];
        }
        else {
            [self.bgView setFullShow:NO animated:YES];
        }
    };
    
#pragma mark 单击
    self.bgView.singleTapAction = ^{
        JX_STRONG_SELF;
        [self jxImageViewSingleTap];
    };
    
#pragma mark 快速拖动隐藏后回调
    self.bgView.didZoomOutAction = ^{

    };
    
#pragma mark 左右滑动的 页数改变
    self.bgView.currentIndexChanged = ^(NSInteger currentIndex) {
        JX_STRONG_SELF;
        switch (self.usage.selectionType) {
            case JXPhotosGeneralLayoutSelectionTypeMulti:
            {
                if (currentIndex >= 0 && currentIndex < self.showingAssets.count) {
                    
                    BOOL preHave = NO;
                    {
                        JXPhotosGeneralAsset *asset = self.showingAssets[self.currentIndex];
                        for (JXPhotosGeneralPreviewBottomTagModel *modelEnum in self.tagModels) {
                            if (modelEnum.asset == asset) {
                                preHave = YES;
                                break;
                            }
                        }
                    }
                    
                    self.currentIndex = currentIndex;
                    
                    BOOL nowHave = NO;
                    NSInteger nowIndex = 0;
                    {
                        JXPhotosGeneralAsset *asset = self.showingAssets[self.currentIndex];
                        for (JXPhotosGeneralPreviewBottomTagModel *modelEnum in self.tagModels) {
                            if (modelEnum.asset == asset) {
                                modelEnum.isCurrentShowing = YES;
                                nowHave = YES;
                            }
                            else {
                                modelEnum.isCurrentShowing = NO;
                            }
                            
                            if (!nowHave) {
                                nowIndex ++;
                            }
                        }
                    }
                    
                    if (preHave && nowHave) {
                        [self refreshData_naviView];
                        [self refreshData_bottomTagsView];
                        [self.bgView.bottomView.tagsView scrollTagIndexToCenter:nowIndex animated:YES];
                    }
                    else if (preHave && !nowHave) {
                        [self refreshData_naviView];
                        [self refreshData_bottomTagsView];
                        //                [self.bgView.bottomView.tagsView scrollTagIndexToCenter:nowIndex animated:YES]; // 不必刷新 可能越界
                    }
                    else if (!preHave && nowHave) {
                        [self refreshData_naviView];
                        [self refreshData_bottomTagsView];
                        [self.bgView.bottomView.tagsView scrollTagIndexToCenter:nowIndex animated:YES];
                    }
                    else {
                        
                    }
                }
            } break;
                
            case JXPhotosGeneralLayoutSelectionTypeSingle:
            {
                self.currentIndex = currentIndex;
            } break;
                
            default: break;
        }
    };
    
#pragma mark 右上角 (选中 / 非选中) | (完成)
    self.bgView.naviView.rightItem.click = ^{
        JX_STRONG_SELF;
        JXPhotosGeneralAsset *asset = self.showingAssets[self.currentIndex];
        switch (self.usage.selectionType) {
            case JXPhotosGeneralLayoutSelectionTypeMulti:
            {
                // 回调上级修改数据
                if (!self.assetClick) {
                    return ;
                }
                
                // 回调上级
                self.assetClick(asset, ^(BOOL toMaximumNumberOfChoices, NSArray<JXPhotosGeneralAsset *> * _Nonnull newSelectedAssets) {
                    if (toMaximumNumberOfChoices) {
                        return ;
                    }
                    
                    if (self.previewIn == JXPhotosGeneralPreviewInAlbumAssets) {
                        self.selectedAssets = newSelectedAssets;
                    }
                    
                    // 是否在 tagsView 所显示范围里
                    BOOL didHave = NO;
                    JXPhotosGeneralPreviewBottomTagModel *theModelHave = nil;
                    for (JXPhotosGeneralPreviewBottomTagModel *modelEnum in self.tagModels) {
                        if (modelEnum.asset == asset) {
                            theModelHave = modelEnum;
                            didHave = YES;
                            break;
                        }
                    }
                    
                    NSInteger toIndex = 0;
                    if (self.previewIn == JXPhotosGeneralPreviewInAlbumAssets) {
                        if (didHave) {
                            NSInteger index = [self.tagModels indexOfObject:theModelHave];
                            toIndex = index - 1;
                            toIndex = index < 0 ? 0 : toIndex;
                            [self.tagModels removeObject:theModelHave];
                        }
                        else {
                            for (JXPhotosGeneralPreviewBottomTagModel *modelEnum in self.tagModels) {
                                modelEnum.isCurrentShowing = NO;
                            }
                            
                            JXPhotosGeneralPreviewBottomTagModel *model = [[JXPhotosGeneralPreviewBottomTagModel alloc] init];
                            model.asset = asset;
                            model.isCurrentShowing = YES;
                            [self.tagModels addObject:model];
                            
                            toIndex = self.tagModels.count - 1;
                        }
                    }
                    else if (self.previewIn == JXPhotosGeneralPreviewInSelectedAssets && theModelHave) { // 该情况下不会增删 sel 只需要刷新
                        toIndex = [self.tagModels indexOfObject:theModelHave];
                    }
                    
                    [self refreshData_naviView];
                    [self refreshData_bottomTagsView];
                    [self refreshData_bottomBarView];
                    
                    [self.bgView.bottomView.tagsView scrollTagIndexToCenter:toIndex animated:YES];
                    [self refreshUI_bottomTagsView_showAndHidden];
                });
                
            } break;
                
            case JXPhotosGeneralLayoutSelectionTypeSingle:
            {
                self.assetClick(asset, ^(BOOL toMaximumNumberOfChoices, NSArray<JXPhotosGeneralAsset *> * _Nonnull newSelectedAssets) {
                    if (self.sendClick) {
                        self.sendClick(self.bgView, ^{
                            [UIView animateWithDuration:0.25 animations:^{
                                self.view.jx_y = JX_SCREEN_H;
                            } completion:^(BOOL finished) {
                                [self.bgView removeFromSuperview];
                                self.bgWindow = nil;
                            }];
                        });
                    }
                });
            } break;
                
            default: break;
        }
    };
    
#pragma mark tagsView 点击的 页数改变
    self.bgView.bottomView.tagsView.didSelectTagAtIndex = ^(NSInteger tagIndex, JXPhotosGeneralPreviewBottomTagModel * _Nonnull tagModel) {
        JX_STRONG_SELF;
        NSInteger toIndex = [self.showingAssets indexOfObject:self.selectedAssets[tagIndex]];
        self.currentIndex = toIndex;
        
        for (JXPhotosGeneralPreviewBottomTagModel *modelEnum in self.tagModels) {
            modelEnum.isCurrentShowing = NO;
        }
        self.tagModels[tagIndex].isCurrentShowing = YES;
        
        //
        [self refreshData_naviView];
        [self refreshData_bottomTagsView];
        
        //
        [self.bgView.bottomView.tagsView scrollTagIndexToCenter:tagIndex animated:YES];
        [self.bgView setCurrentIndex:toIndex animated:NO];
    };
    
#pragma mark 底部 barView 发送
    self.bgView.bottomView.bottomBarView.rightClick = ^{
        JX_STRONG_SELF;
        if (self.sendClick) {
            self.view.userInteractionEnabled = NO;
            self.sendClick(self.bgView, ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.view.jx_y = JX_SCREEN_H;
                } completion:^(BOOL finished) {
                    [self.bgView removeFromSuperview];
                    self.bgWindow = nil;
                }];
            });
        }
    };
}

- (void)startPreview {
    // 计算当前页
    NSInteger fromIndex = 0;
    if ([self.showingAssets containsObject:self.clickAsset]) {
        fromIndex = [self.showingAssets indexOfObject:self.clickAsset];
    }
    self.currentIndex = fromIndex;
    
    // 页面打开转场动画 并 回调上级页面配合转场
    [self.view layoutIfNeeded];
    self.toL.constant = 0.0;
    self.toR.constant = 0.0;
    JXPhotosGeneralPreviewVCPageOpenAnimationEnd pageOpenAnimationEnd = nil;
    if (self.pageOpenAnimationBegin) {
        pageOpenAnimationEnd = self.pageOpenAnimationBegin(k_pageAnimationDuration, k_pageAnimationOptions);
    }
    [UIView animateWithDuration:k_pageAnimationDuration delay:0.0 options:k_pageAnimationOptions animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        JX_BLOCK_EXEC(pageOpenAnimationEnd);
    }];

    // 初次 tagsView 定位
    switch (self.usage.selectionType) {
        case JXPhotosGeneralLayoutSelectionTypeMulti:
        {
            // 计算 tagModels
            self.tagModels = [[NSMutableArray alloc] init];
            for (JXPhotosGeneralAsset *assetEnum in self.selectedAssets) {
                JXPhotosGeneralPreviewBottomTagModel *model = [[JXPhotosGeneralPreviewBottomTagModel alloc] init];
                model.asset = assetEnum;
                [self.tagModels addObject:model];
            }
            
            //
            NSInteger tagIndex = 0;
            if (self.tagModels.count > 0) {
                if (self.previewIn == JXPhotosGeneralPreviewInAlbumAssets) {
                    tagIndex = [self.selectedAssets indexOfObject:self.clickAsset];
                    if (tagIndex == NSNotFound) {
                        tagIndex = 0;
                    }
                    else {
                        self.tagModels[tagIndex].isCurrentShowing = YES;
                    }
                }
                else {
                    // 此种情况绝对是 NSNotFound
                    tagIndex = 0;
                    self.tagModels[0].isCurrentShowing = YES;
                }
            }
            else {
                
            }
            
            // 刷新数据
            [self refreshData_naviView];
            [self refreshData_scrollView];
            [self refreshData_bottomBarView];
            if (self.tagModels.count > 0) {
                [self refreshData_bottomTagsView];
                [self.bgView.bottomView.tagsView scrollTagIndexToCenter:tagIndex animated:NO];
            }
            
            // 刷新 动画或位置
            [self.bgView setCurrentIndex:self.currentIndex animated:NO];
            [self refreshUI_bottomTagsView_showAndHidden];
        } break;
            
        case JXPhotosGeneralLayoutSelectionTypeSingle:
        {
            // 刷新数据
            [self refreshData_naviView];
            [self refreshData_scrollView];
            
            // 刷新 动画或位置
            [self.bgView setCurrentIndex:self.currentIndex animated:NO];
        } break;
            
        default: break;
    }
}

- (void)refreshData_naviView {
    self.bgView.naviView.asset = self.showingAssets[self.currentIndex];
}

- (void)refreshData_scrollView {
    self.bgView.showingAssets = self.showingAssets;
}

- (void)refreshData_bottomTagsView {
    self.bgView.bottomView.tagsView.tagModels = self.tagModels;
}

- (void)refreshData_bottomBarView {
    NSInteger sel_count = 0;
    for (JXPhotosGeneralAsset *assetEnum in self.showingAssets) {
        if (assetEnum.selected) {
            sel_count ++;
        }
    }
    
    if (self.usage.selectionType == JXPhotosGeneralLayoutSelectionTypeSingle) {
        
    }
    else {
        if (sel_count == 0) {
            self.bgView.bottomView.bottomBarView.rightButtonEnable = NO;
        }
        else {
            self.bgView.bottomView.bottomBarView.rightButtonEnable = YES;
        }
        
        NSString *rightTitle = nil;
        switch (self.previewIn) {
            case JXPhotosGeneralPreviewInAlbumAssets:
            {
                rightTitle = [NSString stringWithFormat:@"发送(%ld/%ld)", sel_count, self.usage.maximumNumberOfChoices];
            } break;
                
            case JXPhotosGeneralPreviewInSelectedAssets:
            default:
            {
                rightTitle = [NSString stringWithFormat:@"发送(%ld)", sel_count];
            } break;
        }
        self.bgView.bottomView.bottomBarView.rightTitle = rightTitle;
    }
}

- (void)refreshUI_bottomTagsView_showAndHidden {
    if (self.tagModels.count > 0) {
        [self.bgView setTagsViewShow:YES animated:YES];
    }
    else {
        [self.bgView setTagsViewShow:NO animated:NO];
    }
}

- (void)jxImageViewSingleTap {
    [self.bgView setFullShow:!self.bgView.fullShow animated:NO];
}

@end
