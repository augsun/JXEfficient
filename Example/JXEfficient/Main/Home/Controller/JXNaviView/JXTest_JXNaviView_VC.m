//
//  JXTest_JXNaviView_VC.m
//  JXEfficient_Example
//
//  Created by augsun on 7/15/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXNaviView_VC.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <JXEfficient/JXEfficient.h>

@interface JXTest_JXNaviView_VC ()

@property (nonatomic, strong) JXNaviView *testNaviView;
@property (nonatomic, strong) UIScrollView *bg_for_translucent_scrollView;

@property (nonatomic, strong) UIImage *for_translucent_bg_img;
@property (nonatomic, strong) UIImage *for_testNaviView_bg_img;

@end

@implementation JXTest_JXNaviView_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JX_COLOR_SYS_IMG_BG;
    
    self.rightSubButton_enable = YES;
    
}

- (void)rightSubButton_click {
    //
    void (^show_testNaviView)(void) = ^ {
        //
        [self.bg_for_translucent_scrollView removeFromSuperview];
        self.bg_for_translucent_scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:self.bg_for_translucent_scrollView];
        [self.bg_for_translucent_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        self.bg_for_translucent_scrollView.bounces = YES;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.bg_for_translucent_scrollView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.centerX.mas_equalTo(self.bg_for_translucent_scrollView);
            make.height.mas_equalTo(JX_SCREEN_H);
        }];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.image = self.for_translucent_bg_img;
        
        //
        [self.testNaviView removeFromSuperview];
        self.testNaviView = [JXNaviView naviView];
        [self.view addSubview:self.testNaviView];
        [self.testNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).with.offset(200.0);
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(JX_NAVBAR_H);
        }];
        
        [self.view bringSubviewToFront:self.naviView];
        [self.view bringSubviewToFront:self.testNaviView];
        
#if 0
        @{
          @"title": @"JXNaviView",
          @"leftButtonTitle": @"Left",
          @"subRightButtonTitle": @"SubRight",
          @"rightButtonTitle": @"Right",
          
          @"leftButtonImage": [UIImage imageNamed:@"JXTestBaseVC_navi_left_icon"],
          @"subRightButtonImage": [UIImage imageNamed:@"JXTestBaseVC_navi_subRight_icon"],
          @"rightButtonImage": [UIImage imageNamed:@"JXTestBaseVC_naiv_right_icon"],
          
          @"bgColorStyle": @(YES),
          @"translucent": @(YES),
          
          @"backgroundImageView_image_url": @"",
          
          @"contentEdgeInsets_right": ,
              
              //
          @"usingTime": @(1.0),
          @"toast": "",
          }
#endif
        
        NSArray <NSDictionary <NSString *, id> *> *frames = @[
                                                              @{@"toast": @"标题", },
                                                              @{
                                                                  @"title": @"JXNaviView",
                                                                  },
                                                              @{@"toast": @"左按钮", },
                                                              @{
                                                                  @"leftButtonTitle": @"Left",
                                                                  },
                                                              @{@"toast": @"右按钮", },
                                                              @{
                                                                  @"rightButtonTitle": @"Right",
                                                                  },
                                                              @{@"toast": @"右副按钮", },
                                                              @{
                                                                  @"subRightButtonTitle": @"SubRight",
                                                                  },
                                                              @{@"toast": @"右图片", },
                                                              @{
                                                                  @"rightButtonImage": [UIImage imageNamed:@"JXTestBaseVC_naiv_right_icon"],
                                                                  },
                                                              @{@"toast": @"右副图片", },
                                                              @{
                                                                  @"subRightButtonImage": [UIImage imageNamed:@"JXTestBaseVC_navi_subRight_icon"],
                                                                  },
                                                              @{@"toast": @"左图片", },
                                                              @{
                                                                  @"leftButtonImage": [UIImage imageNamed:@"JXTestBaseVC_navi_left_icon"],
                                                                  },
                                                              @{@"toast": @"当一或多个 Item 内容过大时, 执行抗压优先 [back > right > left > subRight > title]", },
                                                              @{
                                                                  @"title": @"JXNaviViewJ",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJX",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJXN",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJXNa",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJXNav",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJXNavi",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJXNaviV",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJXNaviVi",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJXNaviVie",
                                                                  @"usingTime": @(0.1),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviViewJXNaviView",
                                                                  },
                                                              @{@"toast": @"背景颜色样式导航条", },
                                                              @{
                                                                  @"leftButtonTitle": @"Left",
                                                                  @"rightButtonTitle": @"Right",
                                                                  @"subRightButtonTitle": @"SubRight",
                                                                  @"bgColorStyle": @(YES),
                                                                  },
                                                              @{@"toast": @"Item 的 contentEdgeInsets 调整", },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 10.0, 0.0, 9.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 9.0, 0.0, 9.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 4.0, 0.0, 4.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 3.0, 0.0, 3.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0)),
                                                                  @"usingTime": @(0.3),
                                                                  },
                                                              @{
                                                                  @"contentEdgeInsets_right": NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)),
                                                                  },
                                                              @{@"toast": @"translucent 导航条样式", },
                                                              @{
                                                                  @"bgColorStyle": @(NO),
                                                                  @"translucent": @(YES),
                                                                  },
                                                              @{
                                                                  @"title": @"JXNaviView",
                                                                  @"rightButtonImage": [UIImage imageNamed:@"JXTestBaseVC_naiv_right_icon"],
                                                                  @"subRightButtonImage": [UIImage imageNamed:@"JXTestBaseVC_navi_subRight_icon"],
                                                                  @"leftButtonImage": [UIImage imageNamed:@"JXTestBaseVC_navi_left_icon"],
                                                                  @"usingTime": @(3.0),
                                                                  },
                                                              @{@"toast": @"背景图片导航条样式", },
                                                              @{
                                                                  @"translucent": @(NO),
                                                                  @"bgColorStyle": @(YES),
                                                                  @"leftButtonTitle": @"Left",
                                                                  @"rightButtonTitle": @"Right",
                                                                  @"subRightButtonTitle": @"SubRight",
                                                                  @"backgroundImageView_image_url": self.for_testNaviView_bg_img,
                                                                  },
                                                              ];
        
        //
        [self testFrames:frames i:0];
    };
    
    if (!self.for_translucent_bg_img || !self.for_testNaviView_bg_img) {
        
        void (^check_ready)(void) = ^ {
            if (self.for_translucent_bg_img && self.for_testNaviView_bg_img) {
                [self.view jx_hideProgressHUD:YES];
                JX_BLOCK_EXEC(show_testNaviView);
            }
        };
        
        [self.view jx_showProgressHUD:@"测试数据准备中..."];
        NSString *for_translucent_bg_img_url = @"https://gitee.com/codersun/Resources/raw/master/JXCarouselView/931282.375.jpg";
        if (!self.for_translucent_bg_img) {
            [[SDWebImageManager sharedManager] loadImageWithURL:jx_URLValue(for_translucent_bg_img_url) options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    self.for_translucent_bg_img = image;
                    JX_BLOCK_EXEC(check_ready);
                }
                else {
                    [self.view jx_hideProgressHUD:YES];
                    [self.view jx_showToast:@"资源准备失败" animated:YES];
                }
            }];
        }
        if (!self.for_testNaviView_bg_img) {
            NSString *for_testNaviView_bg_img_url = @"https://gitee.com/codersun/Resources/raw/master/JXCarouselView/111258.375.jpg";
            [[SDWebImageManager sharedManager] loadImageWithURL:jx_URLValue(for_testNaviView_bg_img_url) options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    self.for_testNaviView_bg_img = image;
                    check_ready();
                }
                else {
                    [self.view jx_hideProgressHUD:YES];
                    [self.view jx_showToast:@"资源准备失败" animated:YES];
                }
            }];
        }
    }
}

- (void)testFrames:(NSArray <NSDictionary <NSString *, id> *> *)frames i:(NSInteger)i {
    if (i >= frames.count) {
        
    }
    else {
        NSDictionary <NSString *, id> *data = frames[i];
        id toast = [data objectForKey:@"toast"];
        if (toast) {
            [self.view jx_showToast:toast animated:YES yOffset:JX_NAVBAR_H + 20.0];
            [self testFrames:frames i:i + 1];
            return;
        }
        
        CGFloat usingTime = 1.0;
        id obj = [data objectForKey:@"usingTime"];
        if (obj) {
            usingTime = jx_floValue(obj);
        }
        
        [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self setKey:key value:obj];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(usingTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self testFrames:frames i:i + 1];
        });
    }
}

- (void)setKey:(NSString *)key value:(id)value {
    if ([key isEqualToString:@"title"]) {
        self.testNaviView.title = value;
    }
    
    if ([key isEqualToString:@"leftButtonTitle"]) {
        self.testNaviView.leftButtonTitle = value;
    }
    if ([key isEqualToString:@"subRightButtonTitle"]) {
        self.testNaviView.subRightButtonTitle = value;
    }
    if ([key isEqualToString:@"rightButtonTitle"]) {
        self.testNaviView.rightButtonTitle = value;
    }
    
    if ([key isEqualToString:@"leftButtonImage"]) {
        self.testNaviView.leftButtonImage = value;
    }
    if ([key isEqualToString:@"subRightButtonImage"]) {
        self.testNaviView.subRightButtonImage = value;
    }
    if ([key isEqualToString:@"rightButtonImage"]) {
        self.testNaviView.rightButtonImage = value;
    }
    if ([key isEqualToString:@"bgColorStyle"]) {
        BOOL bgColorStyle = jx_booValue(value);
        self.testNaviView.bgColorStyle = bgColorStyle;
        
        if (bgColorStyle) {
            self.testNaviView.backgroundColor = JX_COLOR_HEX(0x008ab8);
        }
        else {
            self.testNaviView.backgroundColor = [UIColor whiteColor];
        }
    }
    if ([key isEqualToString:@"translucent"]) {
        BOOL translucent = jx_booValue(value);
        self.testNaviView.translucent = translucent;
        
        if (translucent) {
            [self.view layoutIfNeeded];
            
            [self.testNaviView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view).with.offset(160.0);
            }];
            [UIView animateWithDuration:1.5 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self.testNaviView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.view).with.offset(250.0);
                }];
                [UIView animateWithDuration:1.5 animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }
        else {
            [self.bg_for_translucent_scrollView removeFromSuperview];
        }
    }
    if ([key isEqualToString:@"backgroundImageView_image_url"]) {
        self.testNaviView.backgroundImageView.image = value;
        
    }
    if ([key isEqualToString:@"contentEdgeInsets_right"]) {
        self.testNaviView.rightItem.contentEdgeInsets = UIEdgeInsetsFromString(value);
    }
}

@end

