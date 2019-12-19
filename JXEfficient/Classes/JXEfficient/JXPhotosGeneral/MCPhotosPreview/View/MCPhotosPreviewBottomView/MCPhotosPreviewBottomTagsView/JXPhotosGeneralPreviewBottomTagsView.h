//
//  JXPhotosGeneralPreviewBottomTagsView.h
//  JXEfficient
//
//  Created by augsun on 7/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPhotosGeneralPreviewBottomTagModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosGeneralPreviewBottomTagsView : UIView

@property (nonatomic, copy) NSArray <JXPhotosGeneralPreviewBottomTagModel *> *tagModels; ///< 要显示的 tag
@property (nonatomic, copy) void (^didSelectTagAtIndex)(NSInteger tagIndex, JXPhotosGeneralPreviewBottomTagModel *tagModel); ///< 点击回调
- (void)scrollTagIndexToCenter:(NSInteger)tagIndex animated:(BOOL)animated; ///< 趋向中间滚动

@end

NS_ASSUME_NONNULL_END
