//
//  JXPhotosGeneralLayoutView.h
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXNavigationBar.h"
#import "JXPhotosLayoutView.h"

#import "JXPhotosGeneralAsset.h"
#import "JXPhotosGeneralUsage.h"
#import "JXPhotosGeneralBottomBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosGeneralLayoutView : UIView

- (instancetype)initWithUsage:(JXPhotosGeneralUsage *)usage;

@property (nonatomic, readonly) JXNavigationBar *naviBar; ///< 导航条
@property (nonatomic, readonly) JXPhotosLayoutView *layoutView; ///< 主布局图
@property (nonatomic, readonly) JXPhotosGeneralBottomBarView *bottomBarView; ///< 底部 barView

- (void)refreshUIWithAssets:(NSArray <JXPhotosGeneralAsset *> *)assets; ///< 刷新列表
@property (nonatomic, copy) void (^selectClick)(JXPhotosGeneralAsset *asset); ///< 右上角选中

@end

NS_ASSUME_NONNULL_END
