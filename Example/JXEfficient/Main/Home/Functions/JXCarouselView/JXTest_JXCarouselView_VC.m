//
//  JXTest_JXCarouselView_VC.m
//  JXEfficient
//
//  Created by augsun on 7/5/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXCarouselView_VC.h"

#import <JXEfficient/JXEfficient.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImageManager.h>

#import "JXTest_JXCarouselView_CustomView.h"

static const CGFloat kCarouseToLR = 8.0;

@interface JXTest_JXCarouselView_VC ()

@property (nonatomic, copy) NSArray <NSURL *> *URLs;

@property (nonatomic, strong) JXCarouselView *carouselView_normal;

@property (nonatomic, strong) JXCarouselView *carouselView_customIndicator;

@property (nonatomic, strong) JXCarouselView *carouselView_customView;
@property (nonatomic, strong) NSMutableArray <JXTest_JXCarouselView_CustomModel *> *models;

@end

@implementation JXTest_JXCarouselView_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    JX_WEAK_SELF;
    
    //
    self.rightButton_enable = YES;
    self.models = [[NSMutableArray alloc] init];
    
    //
    self.URLs = @[
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/101749.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/107500.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/108389.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/111258.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/112793.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/355362.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/931282.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/969118.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/970400.375.jpg"),
                  jx_URLValue(@"https://raw.githubusercontent.com/augsun/Resources/master/JXCarouselView/986765.375.jpg"),
                  ];
    
    void (^loadImage)(NSURL *,
                      void (^_Nullable)(NSInteger, NSInteger),
                      void (^)(UIImage * _Nullable, NSError * _Nullable)) = ^
    (NSURL *URL,
     void (^_Nullable progress)(NSInteger receivedSize, NSInteger expectedSize),
     void (^completed)(UIImage * _Nullable image, NSError * _Nullable error))
    {
        [[SDWebImageManager sharedManager] loadImageWithURL:URL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            JX_BLOCK_EXEC(progress, receivedSize, expectedSize);
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            JX_BLOCK_EXEC(completed, image, error);
        }];
    };

    // 样式一 carouselView_normal
    self.carouselView_normal = [[JXCarouselView alloc] init];
    [self.view addSubview:self.carouselView_normal];
    [self.carouselView_normal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(JX_NAVBAR_H + 10.0 + 50.0 + 20.0);
        make.left.mas_equalTo(self.view).with.offset(kCarouseToLR);
        make.right.mas_equalTo(self.view).with.offset(-kCarouseToLR);
        make.height.mas_equalTo(160.0);
    }];
    self.carouselView_normal.autoRolling = NO;
    self.carouselView_normal.interitemSpacing = 8.0;
    self.carouselView_normal.pageControlView.hidesForSinglePage = YES;
    self.carouselView_normal.pageControlView.currentIndicatorColor = [UIColor redColor];
    self.carouselView_normal.pageControlView.normalIndicatorColor = [UIColor grayColor];
    // progress 可空, completed 不可空
    self.carouselView_normal.loadImage = loadImage ;
    self.carouselView_normal.didTapItemAtIndex = ^(NSInteger index) {
        // 处理点击事件
        
    };
    
    // 样式二 carouselView_customIndicator
    self.carouselView_customIndicator = [[JXCarouselView alloc] init];
    [self.view addSubview:self.carouselView_customIndicator];
    [self.carouselView_customIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.carouselView_normal.mas_bottom).with.offset(30.0);
        make.left.mas_equalTo(self.view).with.offset(kCarouseToLR);
        make.right.mas_equalTo(self.view).with.offset(-kCarouseToLR);
        make.height.mas_equalTo(100.0);
    }];
    self.carouselView_customIndicator.autoRolling = NO;
    self.carouselView_customIndicator.interitemSpacing = 8.0;
    self.carouselView_customIndicator.pageControlView.hidesForSinglePage = YES;
    self.carouselView_customIndicator.pageControlView.currentIndicatorImage = [UIImage jx_PDFImageWithNamed:@"JXTest_JXCarouselView_VC_current" inBundle:nil];
    self.carouselView_customIndicator.pageControlView.normalIndicatorImage = [UIImage jx_PDFImageWithNamed:@"JXTest_JXCarouselView_VC_normal" inBundle:nil];
    // progress 可空, completed 不可空
    self.carouselView_customIndicator.loadImage = loadImage;
    self.carouselView_customIndicator.didTapItemAtIndex = ^(NSInteger index) {
        // 处理点击事件
        
    };
    
    // 样式三 carouselView_customView
    self.carouselView_customView = [[JXCarouselView alloc] init];
    [self.view addSubview:self.carouselView_customView];
    [self.carouselView_customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.carouselView_customIndicator.mas_bottom).with.offset(30.0);
        make.left.mas_equalTo(self.view).with.offset(kCarouseToLR);
        make.right.mas_equalTo(self.view).with.offset(-kCarouseToLR);
        make.height.mas_equalTo(120.0);
    }];
    self.carouselView_customView.autoRolling = NO;
    self.carouselView_customView.interitemSpacing = 8.0;
    self.carouselView_customView.pageControlView.hidesForSinglePage = YES;
    self.carouselView_customView.pageControlView.currentIndicatorColor = [UIColor redColor];
    self.carouselView_customView.pageControlView.normalIndicatorColor = [UIColor grayColor];
    // progress 可空, completed 不可空
    self.carouselView_customView.loadImage = loadImage;
    self.carouselView_customView.customCarouselViewClass = [JXTest_JXCarouselView_CustomView class];
    self.carouselView_customView.setImageIfCustomCarouselView = NO;
    self.carouselView_customView.carouselViewForIndex = ^(__kindof JXCarouselImageView * _Nonnull carouselView, NSInteger index) {
        JX_STRONG_SELF;
        JXTest_JXCarouselView_CustomView *view = (JXTest_JXCarouselView_CustomView *)carouselView;
        view.model = self.models[index];
    };
    self.carouselView_customView.didTapItemAtIndex = ^(NSInteger index) {
        // 处理点击事件
        
    };
    

}

- (void)rightButton_click {

    NSInteger total_count = self.URLs.count;
    NSAssert(total_count > 0, @"请先初始化 self.URLs 且 self.URLs.count > 0");
    
    static NSInteger random_count = 0;
    NSInteger (^get_random_count)(void) = ^ NSInteger {
        return [JXChowder randomUIntegerFrom:1 to:total_count];
    };
    NSInteger now_get_random_count = 0;
    do {
        now_get_random_count = get_random_count();
        
    } while (now_get_random_count == random_count);
    random_count = now_get_random_count;
    
    NSMutableArray <NSNumber *> *temp_nums = [[NSMutableArray alloc] init];
    NSMutableArray <NSURL *> *temp_URLs = [[NSMutableArray alloc] init];
    while (1) {
        NSInteger random_get_index = [JXChowder randomUIntegerFrom:0 to:total_count - 1];
        if (![temp_nums containsObject:@(random_get_index)]) {
            [temp_URLs addObject:self.URLs[random_get_index]];
            if (temp_URLs.count >= random_count) {
                break;
            }
        }
    }
    
    NSString *tipMsg = [NSString stringWithFormat:@"当前有 %ld 张轮播图片", random_count];
    [self.view jx_showToast:tipMsg animated:YES yOffset:JX_NAVBAR_H + 10.0];

    //
    [self.carouselView_normal reloadDataWithImageURLs:temp_URLs];
    [self.carouselView_customIndicator reloadDataWithImageURLs:temp_URLs];
    
    [self.models removeAllObjects];
    for (NSURL *enumURL in temp_URLs) {
        JXTest_JXCarouselView_CustomModel *model = [[JXTest_JXCarouselView_CustomModel alloc] init];
        model.URL = enumURL;
        model.browseCount = [JXChowder randomUIntegerFrom:1000 - 20 to:1000 + 20];
        [self.models addObject:model];
    }
    
    [self.carouselView_customView reloadDataWithImageURLs:temp_URLs];
}

@end
