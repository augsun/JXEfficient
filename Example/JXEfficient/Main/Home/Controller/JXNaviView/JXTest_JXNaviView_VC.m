//
//  JXTest_JXNaviView_VC.m
//  JXEfficient_Example
//
//  Created by augsun on 7/15/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXNaviView_VC.h"
#import <Masonry/Masonry.h>
#import <JXEfficient/JXEfficient.h>

@interface JXTest_JXNaviView_VC ()

@property (nonatomic, strong) JXNaviView *testNaviView;

@end

@implementation JXTest_JXNaviView_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightSubButton_enable = YES;

    
}

- (void)rightSubButton_click {
    
    if (self.testNaviView) {
        [self.testNaviView removeFromSuperview];
    }
    
    self.testNaviView = [JXNaviView naviView];
    [self.view addSubview:self.testNaviView];
    [self.testNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(200.0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(JX_NAVBAR_H);
    }];
    {
        self.testNaviView.title = @"JXNaviView";
        self.testNaviView.leftButtonImage = [UIImage imageNamed:@"JXTestBaseVC_navi_left_icon"];
//        self.testNaviView.rightSubButtonImage = [UIImage imageNamed:@"JXTest_JXNaviView_VC_icon"];
        self.testNaviView.rightSubButtonImage = [UIImage imageNamed:@"JXTestBaseVC_navi_subRight_icon"];
//        self.testNaviView.rightButtonImage = [UIImage imageNamed:@"JXTestBaseVC_naiv_right_icon"];
    }
//    {
//        self.testNaviView.title = @"JXNaviView";
////        self.testNaviView.leftButtonTitle = @"Left";
//        self.testNaviView.rightSubButtonTitle = @"SubRight";
//        self.testNaviView.rightButtonTitle = @"Right";
//    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.testNaviView.rightButtonTitle = @"Right";
    });

    
}

@end
