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

@interface JXCCCA : UIView

@end

@implementation JXCCCA

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = JX_COLOR_RANDOM;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", self.superview);
//            self.frame = CGRectMake(0, 0, 100, 100);
//            [self.superview layoutIfNeeded];
            [self.superview setNeedsLayout];
        });
    }
    return self;
}

@end

@interface JXCCCB : UIView

@property (nonatomic, strong) JXCCCA *caView;

@end

@implementation JXCCCB

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = JX_COLOR_RANDOM;
        self.caView = [[JXCCCA alloc] init];
        [self addSubview:self.caView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"ppp%@", NSStringFromCGRect(self.caView.frame));
}

@end

@interface JXTest_JXNaviView_VC ()

@property (nonatomic, strong) JXNaviView *testNaviView;
@property (nonatomic, strong) JXCCCB *cbView;;

@end

@implementation JXTest_JXNaviView_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightSubButton_enable = YES;
    
    self.cbView = [[JXCCCB alloc] init];
    self.cbView.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:self.cbView];
    
}

- (void)rightSubButton_click {
    
    self.testNaviView = [JXNaviView naviView];
    [self.view addSubview:self.testNaviView];
    [self.testNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(200.0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(JX_NAVBAR_H);
    }];
    
    
    
}

@end
