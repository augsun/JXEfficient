//
//  JXCarouselView.m
//  JXEfficient
//
//  Created by CoderSun on 9/25/15.
//  Copyright © 2015 CoderSun. All rights reserved.
//

#import "JXCarouselView.h"
#import "JXCarouselPageControlView.h"
#import "JXCarouselImageView.h"

#import "JXMacro.h"
#import "UIView+JXCategory.h"

#import "NSLayoutConstraint+JXCategory.h"

static const CGFloat kAutoRollTimeIntervalDefault = 3.0;
static const CGFloat kAutoRollTimeIntervalMin = 1.499999;
static const CGFloat kAutoRollTimeIntervalMax = 8.000001;
static const CGFloat kInteritemSpacingDefault = 8.0;
static const CGFloat kPageControlToBottomSpacingDefault = 8.0;

@interface JXCarouselView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSLayoutConstraint *con_scrollView_toR;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSLayoutConstraint *bgView_w;

@property (nonatomic, strong) NSMutableArray <JXCarouselImageView *> *carouselImageViews;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *cons_of_carouselImageViews;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *cons_of_carouselImageViews_w;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *cons_of_carouselImageViews_toL;

@property (nonatomic, copy) NSArray <NSURL *> *imageURLs;
@property (nonatomic, copy) NSArray <JXCarouselModel *> *models;

@property (nonatomic, strong) NSLayoutConstraint *con_pageControl_toB;
@property (nonatomic, strong) NSLayoutConstraint *con_pageControl_h;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, strong) dispatch_source_t gcd_timer;
@property (nonatomic, assign) BOOL gcdTimerRuning; ///< 定时器开关

@property (nonatomic, assign) BOOL didSetCarouselViewClass;

@property (nonatomic, assign) BOOL inWindow;

@end

@implementation JXCarouselView

@synthesize carouselViewClass = _carouselViewClass;

- (void)setAutoRollingTimeInterval:(CGFloat)autoRollingTimeInterval {
    if (autoRollingTimeInterval >= kAutoRollTimeIntervalMin &&
        autoRollingTimeInterval <= kAutoRollTimeIntervalMax &&
        _autoRollingTimeInterval != autoRollingTimeInterval) {
        
        _autoRollingTimeInterval = autoRollingTimeInterval;
        
        [self resetGcdTimer];
    }
}

- (void)setPageControlToBottomSpacing:(CGFloat)pageControlToBottomSpacing {
    _pageControlToBottomSpacing = pageControlToBottomSpacing;
    self.con_pageControl_toB.constant = -pageControlToBottomSpacing;
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    if (interitemSpacing < 0.0) {
        return;
    }
    _interitemSpacing = interitemSpacing;
    
    if (self.carouselImageViews.count > 0) {
        // 修改 scrollView 的外界偏移
        self.con_scrollView_toR.constant = interitemSpacing;
        
        // 修改回退偏移
        for (NSLayoutConstraint *conENum in self.cons_of_carouselImageViews_w) {
            conENum.constant = -interitemSpacing;
        }
        // 修改距左
        for (NSInteger i = 0; i < self.cons_of_carouselImageViews_toL.count; i ++) {
            if (i == 0) {
                self.cons_of_carouselImageViews_toL[i].constant = 0.0;
            }
            else {
                self.cons_of_carouselImageViews_toL[i].constant = interitemSpacing;
            }
        }
        
        // 重置偏移
        [self layoutIfNeeded];
        self.scrollView.contentOffset = CGPointMake(self.scrollView.jx_width * (self.currentPage + 1), 0.0);
    }
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
    for (JXCarouselImageView *carouselImageViewEnum in self.carouselImageViews) {
        carouselImageViewEnum.imageView.contentMode = imageContentMode;
    }
}

- (void)setCarouselViewClass:(Class)carouselViewClass {
    if (!self.didSetCarouselViewClass && [carouselViewClass isSubclassOfClass:[JXCarouselImageView class]]) {
        _carouselViewClass = carouselViewClass;
        self.didSetCarouselViewClass = YES;
    }
}

- (Class)carouselViewClass {
    if (!self.didSetCarouselViewClass) {
        self.didSetCarouselViewClass = YES;
    }
    return _carouselViewClass;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self jx_initBaseViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self jx_initBaseViews];
    }
    return self;
}

- (void)jx_initBaseViews {
    JX_WEAK_SELF;

    //
    self.backgroundColor = JX_COLOR_SYS_SECTION;
    self.clipsToBounds = YES;
    self.carouselImageViews = [[NSMutableArray alloc] init];
    self.cons_of_carouselImageViews = [[NSMutableArray alloc] init];
    self.cons_of_carouselImageViews_w = [[NSMutableArray alloc] init];
    self.cons_of_carouselImageViews_toL = [[NSMutableArray alloc] init];

    _autoRollingTimeInterval = kAutoRollTimeIntervalDefault;
    _imageContentMode = UIViewContentModeScaleAspectFill;
    _interitemSpacing = kInteritemSpacingDefault;
    _pageControlToBottomSpacing = kPageControlToBottomSpacingDefault;
    _carouselViewClass = [JXCarouselImageView class];

    // scrollView
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.con_scrollView_toR = [self.scrollView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:self.interitemSpacing];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.scrollView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                              [self.scrollView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                              [self.scrollView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                              self.con_scrollView_toR,
                                              ]];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    // bgView
    self.bgView = [[UIView alloc] init];
    [self.scrollView addSubview:self.bgView];
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.bgView_w = [self.bgView jx_con_same:NSLayoutAttributeWidth equal:self.scrollView m:1.0 c:0.0];
    
    [NSLayoutConstraint activateConstraints:[self.bgView jx_con_edgeEqual:self.scrollView]];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.bgView jx_con_same:NSLayoutAttributeCenterY equal:self.scrollView m:1.0 c:0.0],
                                              self.bgView_w,
                                              ]];

    // pageControlView
    _pageControlView = [[JXCarouselPageControlView alloc] init];
    [self addSubview:self.pageControlView];
    self.pageControlView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.con_pageControl_toB = [self.pageControlView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:-self.pageControlToBottomSpacing];
    self.con_pageControl_h = [self.pageControlView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:10.0];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.pageControlView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                              self.con_pageControl_toB,
                                              [self.pageControlView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                              self.con_pageControl_h,
                                              ]
     ];
    self.pageControlView.heightNeedUpdate = ^(CGFloat height) {
        JX_STRONG_SELF;
        self.con_pageControl_h.constant = height;
    };
    
    // 定时器
    self.gcd_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_event_handler(self.gcd_timer, ^{
        JX_STRONG_SELF;
        [self jx_timerTicking];
    });
    self.autoRolling = YES;

    // 相关通知 (9.0 及以上无需在 dealloc 里移除)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jx_applicationWillEnterForegroundNotification)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jx_applicationDidEnterBackgroundNotification)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    // 手势点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jx_tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setAutoRolling:(BOOL)autoRolling {
    if (_autoRolling != autoRolling) {
        _autoRolling = autoRolling;
        
        if (autoRolling) {
            [self resetGcdTimerAndRuning];
        }
        else {
            [self suspendGcdTimer];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.scrollView.jx_width > 0.0) {
        [self jx_layoutBgViewAndItsSubviews];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.jx_width * (self.currentPage + 1), 0.0) animated:NO];
    }
}

- (void)jx_layoutBgViewAndItsSubviews {
    JX_WEAK_SELF;

    NSInteger imgView_count = self.numberOfPages + 2;
    NSInteger didHave_count = self.carouselImageViews.count;
    
    if (imgView_count != didHave_count) {
        
        self.con_scrollView_toR.constant = self.interitemSpacing;
        
        [NSLayoutConstraint deactivateConstraints:@[self.bgView_w]];
        self.bgView_w = [self.bgView jx_con_same:NSLayoutAttributeWidth equal:self.scrollView m:imgView_count c:0.0];
        [NSLayoutConstraint activateConstraints:@[self.bgView_w]];
        
        // 移除现有 JXCarouselImageView 所有添加过的约束
        if (self.cons_of_carouselImageViews.count > 0) {
            [NSLayoutConstraint deactivateConstraints:self.cons_of_carouselImageViews];
            [self.cons_of_carouselImageViews removeAllObjects];
            
            [self.cons_of_carouselImageViews_w removeAllObjects];
            [self.cons_of_carouselImageViews_toL removeAllObjects];
        }
        // 所有现有 JXCarouselImageView 从父视图中移除
        for (JXCarouselImageView *viewEnum in self.carouselImageViews) {
            [viewEnum removeFromSuperview];
        }
        
        // 新增 或 释放 JXCarouselImageView
        if (didHave_count < imgView_count) {
            for (NSInteger i = 0; i < imgView_count - didHave_count; i ++) {
                JXCarouselImageView *carouselImageView = [[self.carouselViewClass alloc] init];
                carouselImageView.imageView.contentMode = self.imageContentMode;
                // 加载图片
                carouselImageView.loadImage = ^(NSURL * _Nonnull URL, void (^ _Nonnull completed)(UIImage * _Nullable, NSError * _Nullable)) {
                    JX_STRONG_SELF;
                    if (self.loadImage) {
                        self.loadImage(URL, nil, ^(UIImage * _Nullable image, NSError * _Nullable error) {
                            JX_BLOCK_EXEC(completed, image, error);
                        });
                    }
                };
                [self.carouselImageViews addObject:carouselImageView];
            }
        }
        else  {
            for (NSInteger i = 0; i < didHave_count - imgView_count; i ++) {
                [self.carouselImageViews removeLastObject];
            }
        }
        
        // 对所有 JXCarouselImageView 进行重新约束
        for (NSInteger i = 0; i < imgView_count; i ++) {
            JXCarouselImageView *carouselImageView = self.carouselImageViews[i];
            [self.bgView addSubview:carouselImageView];
            
            UIView *leftView = nil;
            NSLayoutAttribute layoutAttribute = NSLayoutAttributeNotAnAttribute;
            CGFloat constant_toL = 0.0;
            if (i == 0) {
                leftView = self.bgView;
                layoutAttribute = NSLayoutAttributeLeft;
                constant_toL = 0.0;
            }
            else {
                leftView = self.carouselImageViews[i - 1];
                layoutAttribute = NSLayoutAttributeRight;
                constant_toL = self.interitemSpacing;
            }
            carouselImageView.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *con_w = [carouselImageView jx_con_same:NSLayoutAttributeWidth equal:self.bgView m:1.0 / imgView_count c:-self.interitemSpacing];
            NSLayoutConstraint *con_toL = [carouselImageView jx_con_diff:NSLayoutAttributeLeft equal:leftView att2:layoutAttribute m:1.0 c:constant_toL];
            NSArray <NSLayoutConstraint *> *temp_cons = @[
                                                          [carouselImageView jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:0.0],
                                                          con_toL,
                                                          [carouselImageView jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:0.0],
                                                          con_w,
                                                          ];
            [NSLayoutConstraint activateConstraints:temp_cons];
            [self.cons_of_carouselImageViews addObjectsFromArray:temp_cons];
            [self.cons_of_carouselImageViews_w addObject:con_w];
            [self.cons_of_carouselImageViews_toL addObject:con_toL];
        }
        
        //
        [self layoutIfNeeded];
    }
}

- (void)reloadDataWithImageURLs:(NSArray<NSURL *> *)imageURLs {
    if (imageURLs.count == 0) {
        self.scrollView.hidden = YES;
        self.userInteractionEnabled = NO;
        return;
    }

    self.imageURLs = imageURLs;
    self.scrollView.hidden = NO;
    self.userInteractionEnabled = YES;
    
    //
    self.currentPage = 0;
    self.numberOfPages = self.imageURLs.count;
    
    // 生成数据
    {
        NSMutableArray <JXCarouselModel *> *tempArr = [[NSMutableArray alloc] init];
        // 前置 补 最后一个
        {
            JXCarouselModel *model = [[JXCarouselModel alloc] init];
            model.URL = self.imageURLs.lastObject;
            model.index = self.imageURLs.count - 1;
            [tempArr addObject:model];
        }
        
        // 正常序列
        NSInteger index = 0;
        for (NSURL *URLEnum in self.imageURLs) {
            JXCarouselModel *model = [[JXCarouselModel alloc] init];
            model.URL = URLEnum;
            model.index = index;
            [tempArr addObject:model];
            index ++;
        }
        
        // 后置 补 最前一个
        {
            JXCarouselModel *model = [[JXCarouselModel alloc] init];
            model.URL = self.imageURLs.firstObject;
            model.index = 0;
            [tempArr addObject:model];
        }
        self.models = tempArr;
    }
    
    // 布局背景视图和其子控件
    [self jx_layoutBgViewAndItsSubviews];
    
    //
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.jx_width, 0.0) animated:NO];

    // 刷新 UI
    [self jx_refreshImages];

}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    
    self.pageControlView.numberOfPages = numberOfPages;
    
    if (numberOfPages <= 1) {
        self.scrollView.scrollEnabled = NO;
    }
    else {
        self.scrollView.scrollEnabled = YES;
    }
    
    [self pageDidChanged:self.currentPage totalPages:numberOfPages];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    self.pageControlView.currentPage = currentPage;
    [self pageDidChanged:currentPage totalPages:self.numberOfPages];
}

- (void)pageDidChanged:(NSInteger)currentPage totalPages:(NSInteger)totalPages {
    
}

- (void)jx_refreshImages {
    void (^refresh_carouselImageView)(NSInteger sequence) = ^(NSInteger sequence) {
        // 模算 取出 imgView_index 和 item_index
        NSInteger imgView_index = (self.numberOfPages + self.currentPage + 2 + sequence) % (self.numberOfPages + 2);
        NSInteger item_index = (self.numberOfPages + self.currentPage - 1 + sequence) % self.numberOfPages;
        
        // 刷新 UI
        self.carouselImageViews[imgView_index].model = self.models[imgView_index];
        
        // 回调
        JX_BLOCK_EXEC(self.carouselViewForIndex, self.carouselImageViews[imgView_index], item_index);
    };
    
    // 根据常用习惯进行优先级加载图片
    refresh_carouselImageView(1); // 优先加载 currentPage 的 carousel
    refresh_carouselImageView(2); // 再次预加载 currentPage 后一个 carousel
    refresh_carouselImageView(0); // 最后预加载 currentPage 前一个 carousel
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self checkGcdTimerEnable:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self checkGcdTimerEnable:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat wScrollView = scrollView.jx_width;
    if (self.numberOfPages > 0) {
        CGFloat xOffSet = scrollView.contentOffset.x;
        if (xOffSet < wScrollView * 0.5) {
            self.scrollView.contentOffset = CGPointMake(xOffSet + wScrollView * self.numberOfPages, 0.0);
        }
        if (xOffSet > wScrollView * (self.numberOfPages + 0.5)) {
            self.scrollView.contentOffset = CGPointMake(xOffSet - wScrollView * self.numberOfPages, 0.0);
        }
        
        xOffSet = scrollView.contentOffset.x;
        NSInteger currentPageNow = (xOffSet - wScrollView * 0.5) / wScrollView;
        
        if (currentPageNow >= 0 && currentPageNow < self.numberOfPages && self.currentPage != currentPageNow) {
            self.currentPage = currentPageNow;
            [self jx_refreshImages];
        }
    }
}

- (void)jx_applicationDidEnterBackgroundNotification {
    [self checkGcdTimerEnable:NO];
}

- (void)jx_applicationWillEnterForegroundNotification {
    [self checkGcdTimerEnable:YES];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    BOOL inWindow = newWindow != nil;
    self.inWindow = inWindow;
    [self checkGcdTimerEnable:inWindow];
}

- (void)checkGcdTimerEnable:(BOOL)enable {
    if (self.autoRolling) {
        if (enable) {
            [self resetGcdTimerAndRuning];
        }
        else {
            [self suspendGcdTimer];
        }
    }
}

- (void)resetGcdTimer {
    dispatch_source_set_timer(self.gcd_timer,
                              dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoRollingTimeInterval * NSEC_PER_SEC)),
                              (uint64_t)(self.autoRollingTimeInterval * NSEC_PER_SEC),
                              0);
}

- (void)resetGcdTimerAndRuning {
    [self resetGcdTimer];
    self.gcdTimerRuning = YES;
}

- (void)suspendGcdTimer {
    self.gcdTimerRuning = NO;
}

#pragma mark 定时器开关, 传 YES 时 重置计时.
- (void)setGcdTimerRuning:(BOOL)gcdTimerRuning {
    if (_gcdTimerRuning != gcdTimerRuning) {
        _gcdTimerRuning = gcdTimerRuning;
        if (gcdTimerRuning) {
            dispatch_resume(self.gcd_timer);
        }
        else {
            dispatch_suspend(self.gcd_timer);
        }
    }
}

- (void)jx_timerTicking {
    BOOL showing = self.inWindow;
    BOOL autoRolling = self.autoRolling;
    BOOL unDragging = !self.scrollView.isDragging;
    BOOL moreThan1Carousels = self.numberOfPages > 1;
    
    if (showing && autoRolling && unDragging && moreThan1Carousels) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.jx_width * (self.currentPage + 2), 0) animated:YES];
    }
}

- (void)jx_tapAction {
    JX_BLOCK_EXEC(self.didTapItemAtIndex, self.currentPage);
}

- (void)dealloc {
    // suspend 状态不允许 cancel, 先进行 resume.
    if (!self.gcdTimerRuning) {
        [self resetGcdTimerAndRuning];
    }
    dispatch_source_cancel(self.gcd_timer);
}

@end











