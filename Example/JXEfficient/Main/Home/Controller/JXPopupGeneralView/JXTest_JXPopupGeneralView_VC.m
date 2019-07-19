//
//  JXTest_JXPopupGeneralView_VC.m
//  JXEfficient
//
//  Created by augsun on 7/3/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXPopupGeneralView_VC.h"

#import <JXEfficient/JXEfficient.h>
#import <Masonry/Masonry.h>

@interface JXTest_JXPopupGeneralView_VC ()

@end

@implementation JXTest_JXPopupGeneralView_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightButton_enable = YES;
}

- (void)rightButton_click {
    //
    
    JXPopupGeneralView *popView = [[JXPopupGeneralView alloc] init];
    popView.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"I'm JXPopupGeneralView."];
    popView.contentLabel.text = @"Apple has determined that, in a limited number of older generation 15-inch MacBook Pro units, the battery may overheat and pose a fire safety risk. Affected units were sold primarily between September 2015 and February 2017 and product eligibility is determined by the product serial number. AFNetworking is a delightful networking library for iOS, macOS, watchOS, and tvOS. It's built on top of the Foundation URL Loading System, extending the powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use. Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day. AFNetworking powers some of the most popular and critically-acclaimed apps on the iPhone, iPad, and Mac. Choose AFNetworking for your next project, or migrate over your existing projects—you'll be happy you did! AFNetworking includes a suite of unit tests within the Tests subdirectory. These tests can be run simply be executed the test action on the platform framework you would like to test. AFNetworking is released under the MIT license. See LICENSE for details. First check to see which 15-inch MacBook Pro you have. Choose About This Mac from the Apple menu () in the upper-left corner of your screen. Confirm your model is \"MacBook Pro (Retina, 15-inch, Mid 2015).\" If you have that model, enter your computer's serial number below to see if it is eligible for this program. Choose one of the service options below to have your battery replaced. In all cases, your device will be sent to an Apple Repair Center for service. Your MacBook Pro will be examined prior to any service to verify that it is eligible for this program. Service may take 1-2 weeks. This program is for battery replacement only. Please contact Apple Support and speak with an Advisor if you would like to arrange paid service for any additional issue." ;
    popView.button0Label.text = @"Cancel";
    popView.button1Label.text = @"Done";
    popView.button1Label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    popView.hideJustByClicking = YES;
    //    popView.backgroundColorForDebug = YES;
    popView.willRemoveFromSuperview = ^{
        NSLog(@"didDisappear");
    };
    popView.button0Click = ^{
        NSLog(@"button0Click");
    };
    popView.button1Click = ^{
        NSLog(@"button1Click");
    };
    jx_weakify(popView);
    popView.backgroundTap = ^{
        jx_strongify(popView);
        [popView hide];
    };
    [popView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test0:popView];
    });
    

    
}

- (void)test0:(JXPopupGeneralView *)popView {
    popView.contentLabel.text = @"Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.";
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test1:popView];
    });
}

// 1 1 0
- (void)test1:(JXPopupGeneralView *)popView {
    popView.button0Label.text = nil;
    popView.button1Label.text = nil;
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test2:popView];
    });
}

// 1 0 1
- (void)test2:(JXPopupGeneralView *)popView {
    popView.titleLabel.text = @"I'm JXPopupGeneralView.";
    popView.contentLabel.text = nil;
    popView.button0Label.text = @"Cancel";
    popView.button1Label.text = @"Done";
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test20:popView];
    });
}

// 1 0 1
- (void)test20:(JXPopupGeneralView *)popView {
    popView.titleLabel.text = @"I'm JXPopupGeneralView.";
    popView.contentLabel.text = nil;
    popView.button0Label.text = nil;
    popView.button1Label.text = @"Done";
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test21:popView];
    });
}

// 1 0 1
- (void)test21:(JXPopupGeneralView *)popView {
    popView.titleLabel.text = @"I'm JXPopupGeneralView.";
    popView.contentLabel.text = nil;
    popView.button0Label.text = @"Cancel";
    popView.button1Label.text = nil;
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test3:popView];
    });
}

// 1 0 0
- (void)test3:(JXPopupGeneralView *)popView {
    popView.titleLabel.text = @"I'm JXPopupGeneralView.";
    popView.contentLabel.text = nil;
    popView.button0Label.text = nil;
    popView.button1Label.text = nil;
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test4:popView];
    });
}

// 0 1 1
- (void)test4:(JXPopupGeneralView *)popView {
    popView.titleLabel.text = nil;
    popView.contentLabel.text = @"Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.";
    popView.button0Label.text = @"Cancel";
    popView.button1Label.text = @"Done";
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test5:popView];
    });
}

// 0 1 0
- (void)test5:(JXPopupGeneralView *)popView {
    popView.titleLabel.text = nil;
    popView.contentLabel.text = @"Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.";
    popView.button0Label.text = nil;
    popView.button1Label.text = nil;
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test6:popView];
    });
}

// 0 0 1
- (void)test6:(JXPopupGeneralView *)popView {
    popView.titleLabel.text = nil;
    popView.contentLabel.text = nil;
    popView.button0Label.text = @"Cancel";
    popView.button1Label.text = @"Done";
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test8:popView];
    });
}

//// 0 0 0
//- (void)test7:(JXPopupGeneralView *)popView {
//    popView.titleLabel.text = nil;
//    popView.contentLabel.text = nil;
//    popView.button0Label.text = nil;
//    popView.button1Label.text = nil;
//    [popView refreshLayoutAnimated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self test8:popView];
//    });
//}

// custom title
- (void)test8:(JXPopupGeneralView *)popView {
    {
        UIView *bgView = [[UIView alloc] init];
        {
            UILabel *lbl = [[UILabel alloc] init];
            [bgView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(bgView);
            }];
            lbl.text = @"Custom Title Part.";
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightBold];
            lbl.textColor = JX_COLOR_RANDOM;
            lbl.numberOfLines = 0;
            lbl.transform = CGAffineTransformRotate(lbl.transform, -M_1_PI);
        }
        bgView.backgroundColor = JX_COLOR_RANDOM;
        popView.customTitleView = bgView;
    }
    popView.heightFor_customTitleView = ^CGFloat{
        return 150.0;
    };
    popView.contentLabel.text = @"Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.";
    popView.button0Label.text = @"Cancel";
    popView.button1Label.text = @"Done";
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test9:popView];
    });
}

// custom content
- (void)test9:(JXPopupGeneralView *)popView {
    popView.customTitleView = nil;
    popView.heightFor_customTitleView = nil;
    popView.titleLabel.text = @"I'm JXPopupGeneralView.";
    {
        UIView *bgView = [[UIView alloc] init];
        {
            UILabel *lbl = [[UILabel alloc] init];
            [bgView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(bgView);
            }];
            lbl.text = @"Custom Content Part.";
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightBold];
            lbl.textColor = JX_COLOR_RANDOM;
            lbl.numberOfLines = 0;
            lbl.transform = CGAffineTransformRotate(lbl.transform, -M_1_PI);
        }
        bgView.backgroundColor = JX_COLOR_RANDOM;
        popView.customContentView = bgView;
    }
    popView.heightFor_customContentView = ^CGFloat{
        return 200.0;
    };
    popView.button0Label.text = @"Cancel";
    popView.button1Label.text = @"Done";
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test10:popView];
    });
}

// custom buttons
- (void)test10:(JXPopupGeneralView *)popView {
    popView.titleLabel.text = @"I'm JXPopupGeneralView.";
    popView.customContentView = nil;
    popView.heightFor_customContentView = nil;
    popView.contentLabel.text = @"Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.";
    
    CGFloat button_h = 44.0;
    UIView *buttonsBgView = [[UIView alloc] init];
    
    NSArray <NSString *> *buttonTitles = @[
                                           @"Custom Button 0.",
                                           @"Custom Button 1.",
                                           @"Custom Button 2.",
                                           @"Custom Button 3.",
                                           ];
    
    for (NSInteger i = 0; i < buttonTitles.count; i ++)     {
        UILabel *lbl = [[UILabel alloc] init];
        [buttonsBgView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(buttonsBgView).with.offset(i * button_h);
            make.left.right.mas_equalTo(buttonsBgView);
            make.height.mas_equalTo(button_h);
        }];
        lbl.text = buttonTitles[i];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        lbl.backgroundColor = JX_COLOR_RANDOM;
        lbl.textColor = JX_COLOR_RANDOM;
        lbl.alpha = 0.3;
    }
    {
        UILabel *lbl = [[UILabel alloc] init];
        [buttonsBgView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(buttonsBgView);
        }];
        lbl.text = @"Custom Buttons Part.";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightMedium];
        lbl.textColor = JX_COLOR_RANDOM;
        lbl.transform = CGAffineTransformRotate(lbl.transform, -M_1_PI);
    }
    popView.customButtonsView = buttonsBgView;
    popView.heightFor_customButtonsView = ^CGFloat{
        return button_h * buttonTitles.count;
    };
    [popView refreshLayoutAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test11:popView];
    });
}

// custom title content buttons
- (void)test11:(JXPopupGeneralView *)popView {
    {
        {
            UIView *bgView = [[UIView alloc] init];
            {
                UILabel *lbl = [[UILabel alloc] init];
                [bgView addSubview:lbl];
                [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(bgView);
                }];
                lbl.text = @"Custom Title Part.";
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightBold];
                lbl.textColor = JX_COLOR_RANDOM;
                lbl.numberOfLines = 0;
                lbl.transform = CGAffineTransformRotate(lbl.transform, -M_1_PI);
            }
            bgView.backgroundColor = JX_COLOR_RANDOM;
            popView.customTitleView = bgView;
        }
        popView.heightFor_customTitleView = ^CGFloat{
            return 130.0;
        };
    }
    {
        {
            UIView *bgView = [[UIView alloc] init];
            {
                UILabel *lbl = [[UILabel alloc] init];
                [bgView addSubview:lbl];
                [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(bgView);
                }];
                lbl.text = @"Custom Content Part.";
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightBold];
                lbl.textColor = JX_COLOR_RANDOM;
                lbl.numberOfLines = 0;
                lbl.transform = CGAffineTransformRotate(lbl.transform, -M_1_PI);
            }
            bgView.backgroundColor = JX_COLOR_RANDOM;
            popView.customContentView = bgView;
        }
        popView.heightFor_customContentView = ^CGFloat{
            return 200.0;
        };
    }
    {
        CGFloat button_h = 50.0;
        UIView *buttonsBgView = [[UIView alloc] init];
        
        NSArray <NSString *> *buttonTitles = @[
                                               @"Custom Button 0.",
                                               @"Custom Button 1.",
                                               @"Custom Button 2.",
                                               ];
        
        for (NSInteger i = 0; i < buttonTitles.count; i ++)     {
            UILabel *lbl = [[UILabel alloc] init];
            [buttonsBgView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(buttonsBgView).with.offset(i * button_h);
                make.left.right.mas_equalTo(buttonsBgView);
                make.height.mas_equalTo(button_h);
            }];
            lbl.text = buttonTitles[i];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
            lbl.backgroundColor = JX_COLOR_RANDOM;
            lbl.textColor = JX_COLOR_RANDOM;
            lbl.alpha = 0.3;
        }
        {
            UILabel *lbl = [[UILabel alloc] init];
            [buttonsBgView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(buttonsBgView);
            }];
            lbl.text = @"Custom Buttons Part.";
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightMedium];
            lbl.textColor = JX_COLOR_RANDOM;
            lbl.transform = CGAffineTransformRotate(lbl.transform, -M_1_PI);
        }
        popView.customButtonsView = buttonsBgView;
        popView.heightFor_customButtonsView = ^CGFloat{
            return button_h * buttonTitles.count;
        };
    }
    
    [popView refreshLayoutAnimated:YES];
}

@end
