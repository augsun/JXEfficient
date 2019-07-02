//
//  JXViewController.m
//  JXEfficient
//
//  Created by 452720799@qq.com on 12/29/2018.
//  Copyright (c) 2018 452720799@qq.com. All rights reserved.
//

#import "JXViewController.h"
#import <JXEfficient/JXEfficient.h>
#import <Masonry/Masonry.h>

#import "JXTestVC.h"

@interface JXViewController ()

@property (nonatomic, strong) JXNaviView *naviView;

@end

@implementation JXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JX_WEAK_SELF;
    self.view.backgroundColor = JX_COLOR_SYS_SECTION;
    
    self.naviView = [JXNaviView naviView];
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(JX_NAVBAR_H);
    }];
    self.naviView.title = @"Test Page";
    self.naviView.rightButtonTitle = @"Test";
    self.naviView.backButtonHidden = YES;
    self.naviView.bottomLineHidden = NO;
    self.naviView.rightButtonTap = ^{
        JX_STRONG_SELF;
        [self pushTest];
    };
}

- (void)pushTest {
    JXTestVC *vc = [[JXTestVC alloc] init];
    [self jx_pushVC:vc];
}

@end















