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
    
    NSURLComponents *cp = [NSURLComponents componentsWithString:@"https://www.baidu.com"];
    NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"name" value:@"https%3a%2f%2fwww.baidu.com"];
    cp.queryItems = @[queryItem];

    NSLog(@"%@", cp.URL.absoluteString);

    NSLog(@"%@ %@", queryItem.name, queryItem.value);
    
    
    //
    NSString *URLString = nil;
    URLString = @"https://app.mixcapp.com/h5/share/templates/shop.html?shopId=L0124N03&mallNo=1102A001&name=%E6%9D%A5&mixcNativeUrl=mixc%3a%2f%2fapp%2fshopDetail%3fshopId%3dL0124N03";
    
//    NSDictionary *dicParams = [URLString jx_URLParams];
    
    
    NSString *newURLString = nil;
    NSDictionary *params = @{
                             @"hqsmUrl": @"%e5%85%b7",
                             };
    newURLString = [URLString jx_URLAddParams:params];
    
    NSLog(@"\n%@", newURLString);
    // https://app.mixcapp.com/h5/share/templates/shop.html?shopId=L0124N03&mallNo=1102A001&name=%E6%9D%A5&mixcNativeUrl=mixc%3A%2F%2Fapp%2FshopDetail%3FshopId%3DL0124N03
    // https://app.mixcapp.com/h5/share/templates/shop.html?shopId=L0124N03&mallNo=1102A001&mixcNativeUrl=mixc%3A%2F%2Fapp%2FshopDetail%3FshopId%3DL0124N03&name=%E6%9D%A5

    // https://app.mixcapp.com/h5/share/templates/shop.html?shopId=L0124N03&mallNo=1102A001&mixcNativeUrl=mixc://app/shopDetail?shopId%3DL0124N03&name=%E6%9D%A5


    
    NSLog(@"");
    
    
    [JXSystemAlert alertFromVC:self alertTitle:@"" alertMessage:@"" defaultTtitle:@"" defaultHandler:^{
        
    }];

    
    
    
}

@end
