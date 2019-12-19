//
//  JXPhotosGeneralBaseVC.m
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralBaseVC.h"
#import "JXMacro.h"

@interface JXPhotosGeneralBaseVC () <UIGestureRecognizerDelegate>

@end

@implementation JXPhotosGeneralBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JX_COLOR_HEX(0xf5f5f5);

    if (@available(iOS 11.0, *)) {
        [UIScrollView appearanceWhenContainedInInstancesOfClasses:@[[JXPhotosGeneralBaseVC class]]].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BOOL topVC = self.navigationController.viewControllers.count == 1;
    self.navigationController.interactivePopGestureRecognizer.delegate = topVC ? nil : self;
    self.navigationController.interactivePopGestureRecognizer.enabled = topVC ? NO : YES;
}

#pragma mark 返回手势捕捉
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        if (self.navigationController.topViewController == self ||
            self.navigationController.topViewController == self.parentViewController) { // 带子控制器的标签页面情况
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return YES;
    }
}

#pragma mark - 手势返回 <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        return NO;
    }
    else {
        return YES;
    }
}

@end
