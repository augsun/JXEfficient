//
//  JXPopupGeneralView.h
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import "JXPopupView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 通用弹窗
 @discussion 目前最多支持两个按钮, 如果需要支持更多按钮, 请自行封装底部按钮视图并设置为 costomButtonsView, 同时实现 heightFor_costomButtonsView 即可. 其它部位若自定义同理.
 */
@interface JXPopupGeneralView : JXPopupView

// 标题
@property (nonatomic, readonly) UILabel *titleLabel; ///< 标题
@property (nonatomic, strong, nullable) UIView *costomTitleView; ///< 自定义标题 <若自定义, 则必须一并实现 heightFor_costomTitleView, 否则不展示.>
@property (nonatomic, copy) CGFloat (^heightFor_costomTitleView)(void);

// 内容
@property (nonatomic, readonly) UILabel *contentLabel; ///< 内容
@property (nonatomic, strong, nullable) UIView *costomContentView; ///< 自定义内容 <若自定义, 则必须一并实现 heightFor_costomContentView, 否则不展示.>
@property (nonatomic, copy) CGFloat (^heightFor_costomContentView)(void);

// 按钮
@property (nonatomic, readonly) UILabel *button0Label; ///< 左边按钮, button0Label 与 button1Label 可任意只设置一个.
@property (nonatomic, readonly) UILabel *button1Label; ///< 右边按钮, button0Label 与 button1Label 可任意只设置一个.
@property (nonatomic, strong, nullable) UIView *costomButtonsView; ///< 自定义按钮 <若自定义, 则必须一并实现 heightFor_costomButtonsView, 否则不展示.>
@property (nonatomic, copy) CGFloat (^heightFor_costomButtonsView)(void);

//
@property (nonatomic, readonly) UIView *buttonHorizontalLineView; ///< 按钮水平线
@property (nonatomic, readonly) UIView *buttonVerticalLineView; ///< 按钮竖直线

// 事件回调
@property (nonatomic, copy) void (^button0Click)(void); ///< button0 点击
@property (nonatomic, copy) void (^button1Click)(void); ///< button1 点击

@end

NS_ASSUME_NONNULL_END
