//
//  JXCarouselView.h
//  JXEfficient
//
//  Created by CoderSun on 9/25/15.
//  Copyright © 2015 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCarouselImageView.h"
#import "JXCarouselPageControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXCarouselView : UIView

/**
 自定义 pageControl 样式 <详见 JXCarouselPageControlView 的属性>
 可设置其 hidden 进行隐藏, 以便针对不同应用开发自定义的 pageControlView 加到 JXCarouselView 上
 */
@property (nonatomic, readonly) JXCarouselPageControlView *pageControlView;

@property (nonatomic, assign) BOOL autoRolling; ///< 自动滚动 默认 YES.
@property (nonatomic, assign) CGFloat autoRollingTimeInterval; ///< 自动滚动时间间隔 [1.5, 8.0]s 默认 3s.

@property (nonatomic, assign) CGFloat pageControlToBottomSpacing; ///< Indicator 距离底部的距离 用以动态调整 [如: 传入 20 则向上偏移 20pt]
@property (nonatomic, assign) CGFloat interitemSpacing; ///< 两张轮播图之间的间距 (>= 0.0pt, def. 8.0pt)
@property (nonatomic, assign) UIViewContentMode imageContentMode; /// < 图片的内容模式 (def. UIViewContentModeScaleToFill)

/**
 图片加载回调 <必须实现>
 */
@property (nonatomic, copy) void (^loadImage)(NSURL *URL, void (^_Nullable progress)(NSInteger receivedSize, NSInteger expectedSize), void (^completed)(UIImage * _Nullable image, NSError * _Nullable error));

/**
 点击事件 <可以不实现> refreshCarouselView
 */
@property (nonatomic, copy) void (^didTapItemAtIndex)(NSInteger index);

// carouselViewClass 和 carouselViewForIndex 可以自定义轮播内部的样式或控件
/**
 自定义 carouselView <类似 UITableView 注册 cell 一样> 必须继承自 JXCarouselImageView, 其子类可以自定义(或添加)每个轮播的子控件(比如给每个轮播右上角添加一个角标)<类似自定义 cell> 默认 JXCarouselImageView
 @discussion 实例化后只对第一次设置有效 以保证 carouselViewForIndex 的回调参数 carouselView 都为同一类型实例, 且调用 reloadDataWithImageURLs: 后再设置无效
 @warning carouselViewClass 所对应的类不能关联 xib
 */
@property (nonatomic, strong) Class carouselViewClass;

/**
 每次轮播时的回调 <类似 UITableView 的 cell 的复用方法>
 */
@property (nonatomic, copy) void (^carouselViewForIndex)(__kindof JXCarouselImageView *carouselView, NSInteger index);

/**
 刷新 <与 UITableView 类似>
 @discussion 当只有 1 个 carousel 的情况左右滚动禁用.
 */
- (void)reloadDataWithImageURLs:(NSArray <NSURL *> *)imageURLs;

#pragma mark - 子类实现方法 <二次开发>
/**
 由子类实现 <当自定义 pageControlView 的时候, 可在子类里对 pageControlView 进行页数刷新>
 */
- (void)pageDidChanged:(NSInteger)currentPage totalPages:(NSInteger)totalPages;

@end

NS_ASSUME_NONNULL_END





/* ================================================================================================== */
/* ====================================== JXEfficient Example. ====================================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Example.

#if 0

// 作为属性持有 xib 或 代码实例化
@property (weak, nonatomic) IBOutlet JXCarouselView *bannersView;

- (void)awakeFromNib {
    [super awakeFromNib];
    JX_WEAK_SELF;
    
    // 自定义样式及设置回调
    self.bannersView.autoRolling = NO;
    self.bannersView.interitemSpacing = 8.0;
    self.bannersView.pageControlView.hidesForSinglePage = YES;
    self.bannersView.pageControlView.currentIndicatorColor = [UIColor redColor];
    self.bannersView.pageControlView.normalIndicatorColor = [UIColor grayColor];
    // progress 可空, completed 不可空
    self.loadImage = ^(NSURL * _Nonnull URL, void (^ _Nullable progress)(NSInteger, NSInteger), void (^ _Nonnull completed)(UIImage * _Nullable, NSError * _Nullable)) {
        // 建议使用带缓存的图片框架 比如 SDWebImage
        [[SDWebImageManager sharedManager] loadImageWithURL:URL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            JX_BLOCK_EXEC(progress, receivedSize, expectedSize);
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            JX_BLOCK_EXEC(completed, image, error);
        }];
    };
    self.bannersView.didTapItemAtIndex = ^(NSInteger index) {
        JX_STRONG_SELF;

    };
}

- (void)refreshUI {
    // 刷新 UI
    [self.bannersView reloadDataWithImageURLs:<#URLs#>];
}

#endif
