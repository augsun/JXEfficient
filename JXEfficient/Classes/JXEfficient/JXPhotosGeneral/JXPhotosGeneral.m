//
//  JXPhotosGeneral.m
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneral.h"

#import "JXPhotosGeneralAlbumVC.h"

@interface JXPhotosGeneralNavigationController : UINavigationController

@end

@implementation JXPhotosGeneralNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end

@implementation JXPhotosGeneral

+ (void)photosWithUsage:(JXPhotosGeneralUsage *)usage inVC:(id)inVC {
    JXPhotosGeneralAlbumVC *vc = [[JXPhotosGeneralAlbumVC alloc] initWithUsage:usage];
    JXPhotosGeneralNavigationController *naviVC = [[JXPhotosGeneralNavigationController alloc] initWithRootViewController:vc];
    naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [inVC presentViewController:naviVC animated:YES completion:nil];
}

@end
