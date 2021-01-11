//
//  JXPhotosGeneralPreviewView.h
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPhotosGeneralNaviView.h>
#import <JXPhotosGeneralPreviewBottomView.h>
#import <JXPhotosGeneralUsage.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosGeneralPreviewView : UIView

- (instancetype)initWithUsage:(JXPhotosGeneralUsage *)usage;

@property (nonatomic, readonly) JXPhotosGeneralNaviView *naviView; ///< 导航条
@property (nonatomic, readonly) JXPhotosGeneralPreviewBottomView *bottomView; ///< 底部视图 tagsView 和 bottomBarView

@property (nonatomic, readonly) BOOL fullShow; ///< 是否全屏显示
- (void)setFullShow:(BOOL)fullShow animated:(BOOL)animated; ///< 是否全屏显示, YES 隐藏 tagsView 和 bottomBarView
- (void)setTagsViewShow:(BOOL)show animated:(BOOL)animated; ///< 是否显示 bottomView.tagsView

/**
 由手左右滑动 主视图 页数改变的回调
 
 @warning 只有手动滑动会触发回调, -[JXPhotosGeneralPreviewView setCurrentIndex:animated:] 则不会.
 */
@property (nonatomic, copy) void (^currentIndexChanged)(NSInteger currentIndex);
- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated; ///< 外部设置 主视图 指定页数

@property (nonatomic, copy) NSArray <JXPhotosGeneralAsset *> *showingAssets; ///< 要左右滑动显示的 asset

@property (nonatomic, copy) void (^dragChanged)(CGFloat percent, BOOL needAnimation); ///< percent 为偏移百分比
@property (nonatomic, copy) void (^dragBegan)(void); 
@property (nonatomic, copy) void (^dragEnded)(BOOL forHidden);
@property (nonatomic, copy) void (^singleTapAction)(void);
@property (nonatomic, copy) void (^didZoomOutAction)(void);

@end

NS_ASSUME_NONNULL_END
