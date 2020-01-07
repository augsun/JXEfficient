//
//  JXPhotosGeneralPreviewBottomView.h
//  JXEfficient
//
//  Created by augsun on 7/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPhotosGeneralPreviewBottomTagsView.h"
#import "JXPhotosGeneralBottomBarView.h"

#import "JXPhotosGeneralPreviewBottomTagModel.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat JXPhotosGeneralPreviewBottomViewTagsFixedHeight;

@interface JXPhotosGeneralPreviewBottomView : UIView

@property (nonatomic, readonly) JXPhotosGeneralPreviewBottomTagsView *tagsView;
@property (nonatomic, readonly) JXPhotosGeneralBottomBarView *bottomBarView;

@end

NS_ASSUME_NONNULL_END
