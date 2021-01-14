//
//  JXTest_JXTagsGeneralView_VC.m
//  JXEfficient
//
//  Created by augsun on 9/25/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXTagsGeneralView_VC.h"
#import <JXEfficient/JXEfficient.h>

@interface JXTest_JXTagsGeneralView_VC ()

@property (nonatomic, strong) JXTagsGeneralView *tagsGeneralView;

@end

@implementation JXTest_JXTagsGeneralView_VC

- (void)viewDidLoad {
    [super viewDidLoad];


    self.tagsGeneralView = [[JXTagsGeneralView alloc] init];
    [self.view addSubview:self.tagsGeneralView];
    self.tagsGeneralView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tagsGeneralView jx_con_diff:NSLayoutAttributeTop equal:self.naviView att2:NSLayoutAttributeBottom m:1.0 c:0.0],
                                              [self.tagsGeneralView jx_con_same:NSLayoutAttributeLeft equal:self.view m:1.0 c:0.0],
                                              [self.tagsGeneralView jx_con_same:NSLayoutAttributeRight equal:self.view m:1.0 c:0.0],
                                              [self.tagsGeneralView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:40.0],
                                              ]];
    
    self.tagsGeneralView.normalFont = [UIFont systemFontOfSize:15.0];
    self.tagsGeneralView.selectedFont = [UIFont systemFontOfSize:20.0];
    self.tagsGeneralView.normalColor = JX_COLOR_GRAY(51);
    self.tagsGeneralView.selectedColor = JX_COLOR_HEX(0xFF4500);
        
    self.tagsGeneralView.tagNames = @[@"虚拟专用", @"数据", @"部署", @"最便宜"];

}


@end
