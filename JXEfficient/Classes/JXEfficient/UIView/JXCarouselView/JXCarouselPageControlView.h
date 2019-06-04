//
//  JXCarouselPageControlView.h
//  JXEfficient
//
//  Created by augsun on 1/31/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXCarouselPageControlView : UIView

@property (nonatomic, strong, nullable) UIColor *normalIndicatorColor; ///< 类似 UIPageControl 的 pageIndicatorColor
@property (nonatomic, strong, nullable) UIColor *currentIndicatorColor; ///< 类似 UIPageControl 的 currentPageIndicatorColor

/**
 自定义 JXCarouselPageControlView 的图片, 与 currentImage 同时设置才有效果并且忽略指示器的颜色设置.
 @discussion (图片大小 <最小边 min(size.w, size.h) > 0.0pt, 最大边 max(size.w, size.h) <= 18.0pt>, 如果 max > 18.0pt, 则等比例缩放至最大边为 18.0pt), 图片都将垂直居中于 JXCarouselPageControlView 进行布局
 */
@property (nonatomic, strong, nullable) UIImage *normalIndicatorImage;
/**
 自定义 JXCarouselPageControlView 的图片, 与 normalImage 同时设置才有效果并且忽略指示器的颜色设置.
 @discussion (图片大小 <最小边 min(size.w, size.h) > 0.0pt, 最大边 max(size.w, size.h) <= 18.0pt>, 如果 max > 18.0pt, 则等比例缩放至最大边为 18.0pt), 图片都将垂直居中于 JXCarouselPageControlView 进行布局
 */
@property (nonatomic, strong, nullable) UIImage *currentIndicatorImage;

/**
 同 UIPageControl 的 hidesForSinglePage <hide the the indicator if there is only one page. default is NO>
 */
@property (nonatomic, assign) BOOL hidesForSinglePage;

/**
 同 UIPageControl 的 currentPage <default is 0. value pinned to 0..numberOfPages-1>
 */
@property (nonatomic, assign) NSUInteger currentPage;

/**
 同 UIPageControl 的 numberOfPages <default is 0>
 */
@property (nonatomic, assign) NSUInteger numberOfPages;





/* ================================================================================================== */
/* ======================== JXEfficient Internal Use Properties And Methods. ======================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Internal Use Properties And Methods.

@property (nonatomic, copy) void (^heightNeedUpdate)(CGFloat height);

@end

NS_ASSUME_NONNULL_END
