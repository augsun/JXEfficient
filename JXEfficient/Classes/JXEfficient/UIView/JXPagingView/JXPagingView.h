//
//  JXPagingView.h
//  JXEfficient
//
//  Created by augsun on 3/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 可实现左右分页滚动的视图, 配合 JXTagsView 实现标签页滚动切换功能.
 */
@interface JXPagingView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat pagesGap; ///< 页面之间的间隙, 默认 8pt, 值应大等于 0.0
@property (nonatomic, readonly) NSInteger currentPage; ///< 当前页
@property (nonatomic, copy) NSUInteger (^pagesForPaging)(void); ///< 返回 paging 的页数, 必须实现.

/**
 内部滚动触发的回调
 
 @discussion 只有内部手动触发滚动改变 page 的情况才会回调, 调用 -scrollToPage:animated: 方法不会回调
 */
@property (nonatomic, copy, nullable) void (^didScrollToPage)(NSInteger page);

@property (nonatomic, copy, nullable) void (^scrollingPage)(CGFloat scrollingPage); ///< 实时滚动回调

@property (nonatomic, copy) __kindof UIView *(^viewForPage)(NSInteger page); ///< 向外部请求所在 tag 的 View, 必须实现.

/**
 翻页到指定的 page
 
 @param page 要翻页到的 page
 @param animated 是否动画
 @discussion 调用该方法不会触发 didScrollToPage 回调
 */
- (void)pagingToPage:(NSInteger)page animated:(BOOL)animated;

- (void)resetPaging; ///< 重置, 移除释放所有通过 viewForPage 添加的 View.

@end

NS_ASSUME_NONNULL_END
