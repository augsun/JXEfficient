//
//  JXPagingView.m
//  JXEfficient
//
//  Created by augsun on 3/2/18.
//

#import "JXPagingView.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "JXInline.h"
#import "UIView+JXCategory.h"

static const CGFloat kDefaultPagesGap = 8.f;

@interface JXPagingView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSLayoutConstraint *scrollView_toR;
@property (nonatomic, strong) NSLayoutConstraint *bgView_w;

@property (nonatomic, assign) BOOL draggingTriggered; // 手动触发滚动标识
@property (nonatomic, assign) NSInteger pages; ///< 总页数

/**
 用以确定指定的 page 是否添加过约束, 或对保存的距左约束进行调整
 
 @discussion key 为 page 的 hash, value 为 page 距离 bgView 左边的约束.
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSLayoutConstraint *> *page_toL_cons;

/**
 保存已经添加到 bgView 上的 page 所对应的 页号, 用以屏幕旋转或布局变化的情况下, 对其进行约束调整.
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *didAddedPages;

@end

@implementation JXPagingView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self jx_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self jx_moreInit];
    }
    return self;
}

- (void)jx_moreInit {
    self.backgroundColor = [UIColor whiteColor];
    
    _currentPage = NSIntegerMin;
    _pagesGap = kDefaultPagesGap;
    self.page_toL_cons = [[NSMutableDictionary alloc] init];
    self.didAddedPages = [[NSMutableDictionary alloc] init];
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    self.scrollView_toR = [self.scrollView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:self.pagesGap];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.scrollView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0],
                                              [self.scrollView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0],
                                              [self.scrollView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0],
                                              self.scrollView_toR,
                                              ]];
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollsToTop = NO;

    // bgView
    self.bgView = [[UIView alloc] init];
    [self.scrollView addSubview:self.bgView];
    self.bgView_w = [self.bgView jx_con_same:NSLayoutAttributeWidth equal:self.scrollView m:1.0 c:0.0];
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[self.bgView jx_con_edgeEqual:self.scrollView]];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.bgView jx_con_same:NSLayoutAttributeCenterY equal:self.scrollView m:1.0 c:0],
                                              self.bgView_w,
                                              ]];
    self.bgView.backgroundColor = [UIColor clearColor];
}

- (void)setPagesGap:(CGFloat)pagesGap {
    if (pagesGap >= 0) {
        _pagesGap = pagesGap;
        self.scrollView_toR.constant = pagesGap;
    }
}

- (void)setPagesForPaging:(NSUInteger (^)(void))pagesForPaging {
    if (pagesForPaging) {
        _pagesForPaging = pagesForPaging;
    }
}

- (void)setViewForPage:(__kindof UIView * _Nonnull (^)(NSInteger))viewForPage {
    if (viewForPage) {
        _viewForPage = viewForPage;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self jx_relayout_bgView];
    [self jx_relayout_allDidAddedPages];
    [self jx_relayout_scrollViewOffsetXWithAnimated:NO];
}

// 外部调用
- (void)pagingToPage:(NSInteger)page animated:(BOOL)animated {
    NSAssert(self.pagesForPaging != nil, JX_ASSERT_MSG(@"pagesForPaging 必须实现."));
    
    NSUInteger pages = self.pagesForPaging();
    self.pages = pages;
    
    if (page < 0 || page >= self.pages) {
        return;
    }
    _currentPage = page;

    //
    self.scrollView.bounces = YES;

    //
    [self jx_relayout_bgView];
    [self jx_relayout_currentPageView];
    [self jx_relayout_scrollViewOffsetXWithAnimated:animated];
}

// 重新布局 bgView 的宽度
- (void)jx_relayout_bgView {
    NSInteger pages = self.pages;
    if (pages == 0) {
        return;
    }
    
    [NSLayoutConstraint deactivateConstraints:@[self.bgView_w]];
    self.bgView_w = [self.bgView jx_con_same:NSLayoutAttributeWidth equal:self.scrollView m:pages c:0.0];
    [NSLayoutConstraint activateConstraints:@[self.bgView_w]];
}

// 重新布局 scrollView 的 offset.x
- (void)jx_relayout_scrollViewOffsetXWithAnimated:(BOOL)animated {
    CGFloat offset_x = self.currentPage * (self.jx_width + self.pagesGap);
    [self.scrollView setContentOffset:CGPointMake(offset_x, 0) animated:animated];
}

// 布局当前页 page
- (void)jx_relayout_currentPageView {
    [self jx_relayout_page:self.currentPage];
}

// 重新布局所有已加到 bgView 上的 page
- (void)jx_relayout_allDidAddedPages {
    [self.didAddedPages enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSInteger page = jx_intValue(key);
        [self jx_relayout_page:page];
    }];
}

// 重新布局指定 page
- (void)jx_relayout_page:(NSInteger)page {
    NSInteger self_w = self.jx_width;
    NSInteger pagesGap = self.pagesGap;
    
    NSAssert(self.viewForPage != nil, JX_ASSERT_MSG(@"viewForPage 必须实现."));

    // 保存当前添加到 bgView 上的 page
    NSString *page_string = [NSString stringWithFormat:@"%ld", (long)page];
    NSString *pageNum = [self.didAddedPages objectForKey:page_string];
    if (!pageNum) {
        [self.didAddedPages setObject:page_string forKey:page_string];
    }
    
    UIView *view = self.viewForPage(page);
    [self.bgView addSubview:view];
    
    CGFloat toL = page * (self_w + pagesGap);
    
    // 检查是否需要为 page 再次添加约束, 还是只调整约束
    NSString *view_hash = [NSString stringWithFormat:@"%lu", (unsigned long)view.hash];
    NSLayoutConstraint *view_con_toL = [self.page_toL_cons objectForKey:view_hash];
    if (view_con_toL) {
        view_con_toL.constant = toL;
    }
    else {
        view_con_toL = [view jx_con_same:NSLayoutAttributeLeft equal:self.bgView m:1.0 c:toL];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [view jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:0],
                                                  view_con_toL,
                                                  [view jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:0],
                                                  [view jx_con_same:NSLayoutAttributeCenterY equal:self.bgView m:1.0 c:0],
                                                  [view jx_con_same:NSLayoutAttributeWidth equal:self m:1.0 c:0],
                                                  ]];
        
        // 标记当前 page 为已添加过约束
        [self.page_toL_cons setObject:view_con_toL forKey:view_hash];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.draggingTriggered = YES;
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger pages = 0;
    if (self.pagesForPaging) {
        pages = self.pagesForPaging();
    }

    if (pages > 0) {
        CGFloat scrollingPage = scrollView.contentOffset.x / scrollView.jx_width;
        JX_BLOCK_EXEC(self.scrollingPage, scrollingPage);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.jx_width;
    if (currentPage != self.currentPage && currentPage < self.pages) {
        _currentPage = currentPage;
        
        [self jx_relayout_currentPageView];
        
        if (self.draggingTriggered) {
            JX_BLOCK_EXEC(self.didScrollToPage, currentPage);
        }
    }
    
    //
    self.draggingTriggered = NO;
}

- (void)resetPaging {
    [self.bgView jx_removeAllSubviews];
    self.scrollView.bounces = NO;
}

@end
