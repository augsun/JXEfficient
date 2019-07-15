//
//  JXTest_JXCircularArcView_VC.m
//  JXEfficient_Example
//
//  Created by augsun on 7/15/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXCircularArcView_VC.h"
#import <Masonry/Masonry.h>
#import <JXEfficient/JXEfficient.h>

#import "JXCircularArcView.h"

@interface JXTest_JXCircularArcView_VC ()

@property (nonatomic, strong) JXCircularArcView *arcView;

@end

@implementation JXTest_JXCircularArcView_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rightButton_enable = YES;
    
    
    self.arcView = [[JXCircularArcView alloc] init];
    [self.view addSubview:self.arcView];
    [self.arcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(200.0);
        make.left.mas_equalTo(self.view).with.offset(20.0);
        make.right.mas_equalTo(self.view).with.offset(-20.0);
        make.height.mas_equalTo(200.0);
    }];
    self.arcView.backgroundColor = JX_COLOR_RANDOM;
    self.arcView.radian = 30.0;
    self.arcView.position = JXCircularArcViewArcPositionTop;
    
}

- (void)rightButton_click {
    self.arcView.radian = 40.0;
    self.arcView.position = JXCircularArcViewArcPositionLeft;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self t0];
    });
}

- (void)t0 {
    self.arcView.radian = 20.0;
    self.arcView.position = JXCircularArcViewArcPositionBottom;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self t1];
    });
}

- (void)t1 {
    self.arcView.radian = 50.0;
    self.arcView.position = JXCircularArcViewArcPositionRight;
}

@end
