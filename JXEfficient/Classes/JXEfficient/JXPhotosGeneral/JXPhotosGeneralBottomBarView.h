//
//  JXPhotosGeneralBottomBarView.h
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat JXPhotosGeneralBottomBarViewFixedHeight;

@interface JXPhotosGeneralBottomBarView : UIView

@property (nonatomic, copy) NSString *leftTitle; ///< 左边按钮标题 "预览"
@property (nonatomic, assign) BOOL leftButtonEnable; ///< 左边按钮是否 可用 或 不可用<置灰>
@property (nonatomic, copy) void (^leftClick)(void); ///< 左边按钮事件

@property (nonatomic, copy) NSString *rightTitle; ///< 左边按钮标题 "发送(1/9)" 或 "发送(9)"
@property (nonatomic, assign) BOOL rightButtonEnable; ///< 右边按钮是否 可用 或 不可用<置灰>
@property (nonatomic, copy) void (^rightClick)(void); ///< 右边按钮事件

@end

NS_ASSUME_NONNULL_END
