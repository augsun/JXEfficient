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
//    popView.backgroundColorForDebug = YES;

    // popView.titleLabel.attributedText
    popView.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"通过APP展示H5地图"];
    
    // contentLabel
    popView.contentLabel.text = @"此种方法可以解决问题但是又引出了新的问题，使用此种方法，会出现本应该换行输入时，UITextView的高度并没有改变，而是再输入几个字符才会改变高度，这个问题我没有找到原因，搜索网络上，也有存在此问题的网友，如果您知道解决办法，请在下方留言，多谢!";
    
    // button0Label | button1Label
    popView.button0Label.text = @"取消";
    popView.button1Label.text = @"确定";
    
//    popView.buttonsViewContentH = 100.0;
    
//    UIView *vvv = [[UIView alloc] init];
//    vvv.backgroundColor = JX_COLOR_RANDOM;
//    popView.customContentView = vvv;
//    popView.heightFor_customContentView = ^CGFloat{
//        return 20.0;
//    };
    
    popView.hideJustByClicking = YES;
    popView.didDisappear = ^{
        NSLog(@"bbbb");
    };
    
    
    [popView show];
    jx_weakify(popView);
    popView.backgroundTap = ^{
        jx_strongify(popView)
        [popView hide];
    };
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        popView.titleViewContentH = 100.0;
//        popView.contentViewContentH = 100.0;
//        popView.buttonsViewContentH = 70.0;
//        [popView refreshLayoutAnimated:YES];
//    });
    
    
    
}

@end
