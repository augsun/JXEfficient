//
//  JXTestBaseVC.m
//  JXEfficient_Example
//
//  Created by augsun on 7/3/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTestBaseVC.h"

#import <Masonry/Masonry.h>
#import <JXEfficient/JXEfficient.h>

@interface JXTestBaseVC ()

@end

@implementation JXTestBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    JX_WEAK_SELF;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _naviView = [JXNaviView naviView];
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(JX_NAVBAR_H);
    }];
    self.naviView.title = @"Test Page";
    self.naviView.backClick = ^{
        JX_STRONG_SELF;
        [self backButton_click];
    };
}

- (void)setLeftButton_enable:(BOOL)leftButton_enable {
    _leftButton_enable = leftButton_enable;
    
    JX_WEAK_SELF;
    self.naviView.leftButtonImage = [UIImage imageNamed:@"JXTestBaseVC_navi_left_icon"];
    self.naviView.leftButtonTap = ^{
        JX_STRONG_SELF;
        [self leftButton_click];
    };
}

- (void)setRightButton_enable:(BOOL)rightButton_enable {
    _rightButton_enable = rightButton_enable;
    
    JX_WEAK_SELF;
    self.naviView.rightButtonImage = [UIImage imageNamed:@"JXTestBaseVC_naiv_right_icon"];
    self.naviView.rightButtonTap = ^{
        JX_STRONG_SELF;
        [self rightButton_click];
    };
}

- (void)setRightSubButton_enable:(BOOL)rightSubButton_enable {
    _rightSubButton_enable = rightSubButton_enable;
    
    JX_WEAK_SELF;
    self.naviView.rightSubButtonImage = [UIImage imageNamed:@"JXTestBaseVC_navi_subRight_icon"];
    self.naviView.rightSubButtonTap = ^{
        JX_STRONG_SELF;
        [self rightSubButton_click];
    };
}

- (void)backButton_click {
    [self jx_popVC];
}

- (void)leftButton_click {
    
}

- (void)rightButton_click {
    
}

- (void)rightSubButton_click {
    
}

JX_DEALLOC_TEST

@end
