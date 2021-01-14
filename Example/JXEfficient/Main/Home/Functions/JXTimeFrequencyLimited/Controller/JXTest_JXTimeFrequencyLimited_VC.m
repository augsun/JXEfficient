//
//  JXTest_JXTimeFrequencyLimited_VC.m
//  JXEfficient
//
//  Created by yangjianxing on 2021/1/14.
//  Copyright © 2021 CoderSun. All rights reserved.
//

#import "JXTest_JXTimeFrequencyLimited_VC.h"
#import <JXEfficient/JXTimeFrequencyLimited.h>

@interface JXTest_JXTimeFrequencyLimited_VC ()

@property (nonatomic, strong) JXTimeFrequencyLimited *timeFrequencyLimited;

@end

@implementation JXTest_JXTimeFrequencyLimited_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightButton_enable = YES;
    
    self.timeFrequencyLimited = [[JXTimeFrequencyLimited alloc] init];
}

- (void)rightButton_click {
    
}

@end
