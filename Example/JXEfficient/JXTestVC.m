//
//  JXTestVC.m
//  JXEfficient_Example
//
//  Created by augsun on 3/2/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTestVC.h"
#import <JXEfficient/JXEfficient.h>
#import <Masonry/Masonry.h>

#import "JXPagingView.h"

#import "JXTagsGeneralView.h"
#import "JXNavigationBar.h"
#import "NSString+JXCategory.h"
#import "NSString+JXCategory_URLString.h"

#import "JXPopupGeneralView.h"

@interface JXTestVC ()

@property (nonatomic, strong) JXNaviView *naviView;

@property (nonatomic, strong) JXNavigationBar *naviBar;

@property (nonatomic, strong) JXPagingView *pagingView;
@property (nonatomic, copy) NSArray <UIView *> *pageViews;

@property (nonatomic, strong) JXTagsGeneralView *tagsGeneralView;

@end

@implementation JXTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    JX_WEAK_SELF;
    
    self.naviView = [JXNaviView naviView];
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(2 * JX_NAVBAR_H);
    }];
    self.naviView.title = @"Test Page";
    self.naviView.backClick = ^{
        JX_STRONG_SELF;
        [self backClick];
        
        
    };

    self.naviView.leftButtonTitle = @"Left";
    self.naviView.leftButtonTap = ^{
        JX_STRONG_SELF;
        [self leftClick];
    };
    self.naviView.rightButtonImage = [UIImage imageNamed:@"timg.jpeg"];
    self.naviView.rightButtonTap = ^{
        JX_STRONG_SELF;
        [self rightClick];
    };
    self.naviView.rightSubButtonTitle = @"rightSub";
    self.naviView.rightSubButtonTap = ^{
        JX_STRONG_SELF;
        [self rightSubClick];
    };
}

- (void)backClick {
    [self jx_popVC];
}

- (void)leftClick {
    
}

- (void)rightSubClick {
    
}

- (void)rightClick {
    //
    
    JXPopupGeneralView *popView = [[JXPopupGeneralView alloc] init];
    popView.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"AFNetworking"];
    popView.contentLabel.text = @"Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.";
    popView.button0Label.text = @"Cancel";
    popView.button1Label.text = @"Done";
    popView.button1Label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    popView.hideJustByClicking = YES;
    popView.didDisappear = ^{
        NSLog(@"didDisappear");
    };
    popView.button0Click = ^{
        NSLog(@"button0Click");
    };
    popView.button1Click = ^{
        NSLog(@"button1Click");
    };
    [popView show];

    
    
}

@end
