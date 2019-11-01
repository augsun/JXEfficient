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

// ====================================================================================================

@interface JXPagingViewAddedViewObject : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong, nullable) UIView *view;
@property (nonatomic, strong, nullable) NSLayoutConstraint *con_toL;

@end

@implementation JXPagingViewAddedViewObject

@end

// ====================================================================================================

@interface JXPagingView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSLayoutConstraint *scrollView_toR;
@property (nonatomic, strong) NSLayoutConstraint *bgView_w;

@property (nonatomic, assign) BOOL draggingTriggered; // 手动触发滚动标识
@property (nonatomic, assign) NSInteger pages; ///< 总页数

/// 保存已经添加到 bgView 上的 page 所对应的 view 的状态.
@property (nonatomic, strong) NSMutableDictionary <NSString *, JXPagingViewAddedViewObject *> *didAddedPages;

@property (nonatomic, assign) CGSize previous_self_size;

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
//    self.page_toL_cons = [[NSMutableDictionary alloc] init];
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
    
    if (self.previous_self_size.width == self.jx_width && self.previous_self_size.height == self.jx_height) {
        return;
    }
    if (self.jx_width <= 0.0 || self.jx_height <= 0.0) {
        return;
    }
    self.previous_self_size = self.jx_size;
    
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
    NSDictionary *didAddedPages_copy = [self.didAddedPages copy];
    [didAddedPages_copy enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, JXPagingViewAddedViewObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.page >= self.pages) {
            [self removeAddedViewObject:obj];
        }
        else {
            [self jx_relayout_page:obj.page];
        }
    }];
}

// 重新布局指定 page
- (void)jx_relayout_page:(NSInteger)page {
    NSInteger self_w = self.jx_width;
    NSInteger pagesGap = self.pagesGap;
    
    NSAssert(self.viewForPage != nil, JX_ASSERT_MSG(@"viewForPage 必须实现."));

    //
    UIView *view = self.viewForPage(page);
    if (view.superview != self.bgView) {
        [self.bgView addSubview:view];
    }
    
    //
    CGFloat toL = page * (self_w + pagesGap);
    
    // 获取当前 page 下的 addedViewObject
    NSString *page_string = [NSString stringWithFormat:@"%ld", (long)page];
    JXPagingViewAddedViewObject *addedViewObject = [self.didAddedPages objectForKey:page_string];
    
    // 没有 page 下的 addedViewObject, 则创建一个
    if (!addedViewObject) {
        addedViewObject = [[JXPagingViewAddedViewObject alloc] init];
        addedViewObject.page = page;
        [self.didAddedPages setObject:addedViewObject forKey:page_string];
    }
    
    // addedViewObject 下的 view 与 将要布局的 view 相同, 则更新 con_toL
    if (addedViewObject.view == view) {
        addedViewObject.con_toL.constant = toL;
    }
    // addedViewObject 下的 view 与 将要布局的 view 不同, 则移除记录在 addedViewObject 下的 view 的状态, 并绑定为当前将要布局的 view.
    else {
        [self removeAddedViewObject:addedViewObject];
        [self updateAddedViewObject:addedViewObject view:view toL:toL];
    }
}

- (void)removeAddedViewObject:(JXPagingViewAddedViewObject *)addedViewObject {
    [addedViewObject.view removeFromSuperview];
    addedViewObject.view = nil;
    addedViewObject.con_toL = nil;
}

- (void)updateAddedViewObject:(JXPagingViewAddedViewObject *)addedViewObject view:(UIView *)view toL:(CGFloat)toL {
    addedViewObject.con_toL = [view jx_con_same:NSLayoutAttributeLeft equal:self.bgView m:1.0 c:toL];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [view jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:0],
                                              addedViewObject.con_toL,
                                              [view jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:0],
                                              [view jx_con_same:NSLayoutAttributeCenterY equal:self.bgView m:1.0 c:0],
                                              [view jx_con_same:NSLayoutAttributeWidth equal:self m:1.0 c:0],
                                              ]];
    addedViewObject.view = view;
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
    [self.didAddedPages removeAllObjects];
    self.scrollView.bounces = NO;
}

@end
