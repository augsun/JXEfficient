//
//  JXImageViewer.m
//  JXEfficient
//
//  Created by CoderSun on 4/21/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXImageBrowser.h"
#import <Photos/Photos.h>

#import "JXMacro.h"
#import "UIImage+JXCategory.h"
#import "NSLayoutConstraint+JXCategory.h"

#import "JXImageBrowserImageView.h"
#import "JXImageBrowserPageControlView.h"

static const CGFloat kInteritemSpace = 15.f;

// ====================================================================================================
#pragma mark - JXWindow
@interface JXWindow : UIWindow

@end

@implementation JXWindow

@end

// ====================================================================================================
#pragma mark - JXImageBrowserVC
@interface JXImageBrowserVC : UIViewController

@end

@implementation JXImageBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearanceWhenContainedInInstancesOfClasses:@[[self class]]].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

@end

// ====================================================================================================
#pragma mark - JXImageBrowser
@interface JXImageBrowser () <UIScrollViewDelegate>

@property (nonatomic, strong) JXWindow *bgWindow;
@property (nonatomic, strong) JXImageBrowserVC *bgVC;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) NSArray <JXImageBrowserImage *> *images;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <JXImageBrowserImageView *> *imgViews;
@property (nonatomic, strong) UIPageControl *pageCtl_sys;
@property (nonatomic, strong) JXImageBrowserPageControlView *pageCtl_jx;
@property (nonatomic, assign) CGFloat wSelf;
@property (nonatomic, assign) CGFloat hSelf;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) CGFloat xOffsetPre;

@end

static JXImageBrowser *imageBrowser_;

@implementation JXImageBrowser

+ (instancetype)imageBrowser {
    imageBrowser_ = [[JXImageBrowser alloc] init];
    return imageBrowser_;
}

- (void)browserImages:(NSArray<JXImageBrowserImage *> *)images fromIndex:(NSInteger)fromIndex {
    if (fromIndex < 0 || fromIndex >= images.count) {
        return;
    }
    
    // bgWindow -> bgVC -> bgView
    self.bgWindow = [[JXWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgWindow.windowLevel = UIWindowLevelStatusBar;
    
    self.bgVC = [[JXImageBrowserVC alloc] init];
    self.bgWindow.rootViewController = self.bgVC;
    self.bgWindow.hidden = NO;
    
    self.images = images;
    self.currentIndex = fromIndex;
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.bgWindow.rootViewController.view addSubview:self.bgView];

    // 在 bgView 创建 scrollView -> imgViews
    [self jx_createComponents];
    
    //
    [UIView animateWithDuration:JXImageBrowserImageViewAnimationDuration animations:^{
        self.bgView.backgroundColor = [UIColor blackColor];
    }];
}

- (void)jx_createComponents {
    self.wSelf = self.bgView.bounds.size.width;
    self.hSelf = self.bgView.bounds.size.height;
    self.imgViews = [[NSMutableArray alloc] init];
    
    //
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _wSelf + kInteritemSpace, _hSelf)];
    [self.bgView addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.images.count * (self.wSelf + kInteritemSpace), self.hSelf);
    self.scrollView.contentOffset = CGPointMake(self.currentIndex * (self.wSelf + kInteritemSpace), 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    
    // imgViews
    JX_WEAK_SELF;
    for (NSInteger i = 0; i < self.images.count; i ++) {
        CGRect rect = CGRectMake((_wSelf + kInteritemSpace) * i, 0, _wSelf, _hSelf);
        JXImageBrowserImageView *jxImageView = [[JXImageBrowserImageView alloc] initWithFrame:rect];
        [self.scrollView addSubview:jxImageView];
        jxImageView.loadImage = self.loadImage;
        jxImageView.firstGrace = i == self.currentIndex;
        jxImageView.didDrag = ^(CGFloat percent, BOOL needAnimation) {
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
        jxImageView.singleTapAction = ^(JXImageBrowserImageView * _Nonnull imageBrowserImageView) {
            JX_STRONG_SELF;
            [self jxImageViewSingleTap:imageBrowserImageView];
        };
        jxImageView.didZoomOutAction = ^(JXImageBrowserImageView * _Nonnull imageBrowserImageView) {
            JX_STRONG_SELF;
            [self jxImageViewDidZoomOut:imageBrowserImageView];
        };
        jxImageView.longPressAction = ^(JXImageBrowserImageView * _Nonnull imageBrowserImageView) {
            JX_STRONG_SELF;
            [self jxImageViewLongPress:imageBrowserImageView];
        };
        [self.imgViews addObject:jxImageView];
    }
    
    // pageCtl
    if (self.hideDotForSingle && self.images.count <= 1) {
        
    }
    else {
        CGFloat pageCtlToB = 10.0 + JX_UNUSE_AREA_OF_BOTTOM / 2.0;
        
        self.pageCtl_sys = [[UIPageControl alloc] init];
        CGSize size = [self.pageCtl_sys sizeForNumberOfPages:self.images.count];
        CGFloat leftW = JX_SCREEN_W - 2 * 10.0;
        
        if (size.width <= leftW) {
            [self.bgView addSubview:self.pageCtl_sys];
            self.pageCtl_sys.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.pageCtl_sys jx_con_same:NSLayoutAttributeLeft equal:self.bgView m:1.0 c:0.0],
                                                      [self.pageCtl_sys jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:-pageCtlToB],
                                                      [self.pageCtl_sys jx_con_same:NSLayoutAttributeRight equal:self.bgView m:1.0 c:0.0],
                                                      [self.pageCtl_sys jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:10.0],
                                                      ]];

            self.pageCtl_sys.numberOfPages = self.images.count;
            self.pageCtl_sys.currentPage = self.currentIndex;
            self.pageCtl_sys.userInteractionEnabled = NO;
        }
        else {
            self.pageCtl_sys = nil;
            
            self.pageCtl_jx = [[JXImageBrowserPageControlView alloc] init];
            [self.bgView addSubview:self.pageCtl_jx];
            self.pageCtl_jx.translatesAutoresizingMaskIntoConstraints = NO;
            
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.pageCtl_jx jx_con_same:NSLayoutAttributeLeft equal:self.bgView m:1.0 c:0.0],
                                                      [self.pageCtl_jx jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:-pageCtlToB],
                                                      [self.pageCtl_jx jx_con_same:NSLayoutAttributeRight equal:self.bgView m:1.0 c:0.0],
                                                      [self.pageCtl_jx jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:30.0],
                                                      ]];

            self.pageCtl_jx.numberOfPages = self.images.count;
            self.pageCtl_jx.currentPage = self.currentIndex;
        }
    }
    
    //
    [self jx_refreshImageViewsBetweenIndex:self.currentIndex];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
    NSInteger pageNow = (xOffset + (self.wSelf + kInteritemSpace) * .5f) / (self.wSelf + kInteritemSpace);

    if (pageNow != self.currentIndex) {
        [self jx_refreshImageViewsBetweenIndex:pageNow];
        
        self.pageCtl_sys.currentPage = pageNow;
        self.pageCtl_jx.currentPage = pageNow;
        
        self.currentIndex = pageNow;
    }
}

- (void)jx_refreshImageViewsBetweenIndex:(NSInteger)index {
    NSInteger count_imgViews = self.imgViews.count;
    NSInteger count_images = self.images.count;
    
    if (index < count_imgViews && index < count_images) {
        self.imgViews[index].jxImage = self.images[index];
    }
    
    NSInteger index_pre = index - 1;
    if (index_pre >= 0 && index_pre < count_imgViews && index_pre < count_images) {
        self.imgViews[index_pre].jxImage = self.images[index_pre];
    }
    
    NSInteger index_next = index + 1;
    if (index_next >= 0 && index_next < count_imgViews && index_next < count_images) {
        self.imgViews[index_next].jxImage = self.images[index_next];
    }
}

- (void)jxImageViewSingleTap:(JXImageBrowserImageView *)imageBrowserImageView {
    [UIView animateWithDuration:JXImageBrowserImageViewAnimationDuration animations:^{
        self.bgView.backgroundColor = [UIColor clearColor];
        self.pageCtl_sys.alpha = .0;
        self.pageCtl_jx.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.bgWindow = nil;
    }];
}

- (void)jxImageViewDidZoomOut:(JXImageBrowserImageView *)imageBrowserImageView {
    [self.bgView removeFromSuperview];
    imageBrowser_ = nil;
}

- (void)jxImageViewLongPress:(JXImageBrowserImageView *)imageBrowserImageView {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusRestricted) { return; }
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 取消
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.scrollView.userInteractionEnabled = YES;
    }];
    
    // 保存到手机
    UIAlertAction *actionSave = [UIAlertAction actionWithTitle:@"保存到手机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (authStatus) {
            case PHAuthorizationStatusNotDetermined:
            case PHAuthorizationStatusAuthorized:
            {
                UIImageWriteToSavedPhotosAlbum(imageBrowserImageView.largeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            } break;
                
            case PHAuthorizationStatusDenied:
            {
                UIAlertController *alertNoAuth = [UIAlertController alertControllerWithTitle:@"无法保存" message:@"请前往\"设置-隐私-照片\"选项中，允许访问您的照片。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *acCalcel = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
                [alertNoAuth addAction:acCalcel];
                [self.bgWindow.rootViewController presentViewController:alertNoAuth animated:YES completion:nil];
            } break;
                
            default: break;
        }
    }];
    
    // 二维码点击
    UIAlertAction *scanQRCode = nil;
    if (self.scanQRCodeWhenLongPress) {
        NSString *QRCodeString = [UIImage jx_QRCodeStringFromImage:imageBrowserImageView.largeImage];
        if (QRCodeString.length > 0) {
            BOOL canHandle = NO;
            if (self.canHandleQRCode) {
                canHandle = self.canHandleQRCode(QRCodeString);
            }
            if (canHandle) {
                scanQRCode = [UIAlertAction actionWithTitle:@"识别图中的二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [imageBrowserImageView hide];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        JX_BLOCK_EXEC(self.scannedQRCodeClick, QRCodeString);
                    });
                }];
            }
        }
    }

    //
    [alertCtl addAction:actionSave];
    if (scanQRCode) {
        [alertCtl addAction:scanQRCode];
    }
    [alertCtl addAction:actionCancel];
    [self.bgWindow.rootViewController presentViewController:alertCtl animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    CGFloat sideHUD = 100.f;
    CGFloat hTick = 50.f;
    CGFloat hText = 30.f;
    UIView *viewHUD = [[UIView alloc] initWithFrame:CGRectMake((self.wSelf - sideHUD)/2, (self.hSelf - sideHUD)/2, sideHUD, sideHUD)];
    [viewHUD setAlpha:.0f];
    [self.bgView addSubview:viewHUD];
    [viewHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.8f]];
    [viewHUD setClipsToBounds:YES];
    [viewHUD.layer setCornerRadius:10.f];
    
    UILabel *lblTick = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, sideHUD, hTick)];
    [viewHUD addSubview:lblTick];
    [lblTick setTextAlignment:NSTextAlignmentCenter];
    [lblTick setTextColor:[UIColor whiteColor]];
    [lblTick setText:error ? @"✕" : @"✓"];
    [lblTick setFont:[UIFont systemFontOfSize:50]];
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(0, sideHUD - hText - 10, sideHUD, hText)];
    [viewHUD addSubview:lblText];
    [lblText setTextAlignment:NSTextAlignmentCenter];
    [lblText setTextColor:[UIColor whiteColor]];
    [lblText setText:error ? @"保存失败" : @"保存成功"];
    [lblText setFont:[UIFont boldSystemFontOfSize:16]];
    
    [UIView animateWithDuration:.25f animations:^{
        viewHUD.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3f delay:1.2f options:0 animations:^{
            viewHUD.alpha = .0f;
        } completion:^(BOOL finished) {
            [viewHUD removeFromSuperview];
            self.scrollView.userInteractionEnabled = YES;
        }];
    }];
}

@end









