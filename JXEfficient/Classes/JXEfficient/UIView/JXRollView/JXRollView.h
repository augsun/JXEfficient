//
//  JXRollView.h
//  JXEfficient
//
//  Created by CoderSun on 9/25/15.
//  Copyright © 2015 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXRollView;

@protocol JXRollViewDelegate <NSObject>

@required

// 返回 JXRollView 的图片张数.
- (NSInteger)numberOfItemsInRollView:(nonnull JXRollView *)rollView;

// 设置图片, 推荐使用 [[SDWebImageManager sharedManager] downloadImageWithURL:options:progress:completed:] 方法设置图片, 因为 [sd_setImageWithURL:] 方法会调用 [sd_cancelCurrentImageLoad] 而中断当前正在下载的图片, 下载到一半的图片将被忽略, 如果 JXRollView 在差的网络情形下快速滑动将造成极大的浪费. 同时你不必担心 imageView 的复用问题.
 - (void)rollView:(nonnull JXRollView *)rollView setImageForImageView:(nonnull UIImageView *)imageView atIndex:(NSInteger)index;

@optional

// 点击事件回调
- (void)rollView:(nonnull JXRollView *)rollView didTapItemAtIndex:(NSInteger)index;

@end

__deprecated_msg("将在 JXEfficient 版本 1.0.0 中废除, 请使用 JXCarouselView.")
NS_CLASS_AVAILABLE_IOS(8_0) @interface JXRollView : UIView

@property (nonatomic, weak, nullable) id <JXRollViewDelegate> delegate;

// 自定义指示器颜色.
@property (nonatomic, strong, nullable) UIColor *pageIndicatorColor;
@property (nonatomic, strong, nullable) UIColor *currentPageIndicatorColor;

// 自定义指示器的图片, 两者同时设置才有效果并且忽略指示器的颜色设置.(图片大小[4, 18]pt.)
@property (nonatomic, strong, nullable) UIImage *pageIndicatorImage;
@property (nonatomic, strong, nullable) UIImage *currentPageIndicatorImage;

// 视图的内容模式. 默认 UIViewContentModeScaleAspectFill.
@property (nonatomic, assign) UIViewContentMode imageContentMode;

// 图片之间的间距 默认 8pt.
@property (nonatomic, assign) CGFloat interitemSpacing;

// 自动滚动 默认 YES.
@property (nonatomic, assign) BOOL autoRolling;

// 自动滚动时间间隔 [1.6, 6.0]s 默认 3s.
@property (nonatomic, assign) CGFloat autoRollingTimeInterval;

// 页面指示器距底部的距离 默认 8pt.
@property (nonatomic, assign) CGFloat indicatorToBottomSpacing;

// 如果只有一张图片时自动隐藏指示器, 同时滚动禁用. 默认 NO.
@property (nonatomic, assign) BOOL hideIndicatorForSinglePage;

// 隐藏后可自定义页面指示器
@property (nonatomic, assign) BOOL hideIndicatorOrUseCustom;

// 与 UITableView 类似
- (void)reloadData;

// 由子类实现
- (void)pageDidChanged:(NSInteger)currentPage totalPages:(NSInteger)totalPages;

@end

@interface JXRollView (deprecated)

//  释放 JXRollView 的定时器.
- (void)free __deprecated_msg("不再需要调用该方法.");

@end


















