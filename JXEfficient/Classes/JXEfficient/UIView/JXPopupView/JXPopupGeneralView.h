//
//  JXPopupGeneralView.h
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import "JXPopupView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 通用弹窗, 可使用默认的 (titleLabel, contentLabel, <button0Label | button1Label>), 或对其中任意一部件进行自定义.
 @discussion 目前最多支持两个按钮, 如果需要支持更多按钮, 请自行封装底部按钮视图并设置为 customButtonsView, 同时实现 heightFor_customButtonsView 即可. 其它部位若自定义同理.
 @note
 Example:
 @code
 JXPopupGeneralView *popView = [[JXPopupGeneralView alloc] init];
 popView.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"AFNetworking"];
 popView.contentLabel.text = @"Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day.";
 popView.button0Label.text = @"Cancel";
 popView.button1Label.text = @"Done";
 popView.button1Label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
 popView.hideJustByClicking = YES;
 popView.didDisappear = ^{
    NSLog(@"didDisappear");
 };
 popView.button0Click = ^{
    NSLog(@"button0Click");
 };
 popView.button1Click = ^{
    NSLog(@"button1Click");
 };
 [popView show];
 @endcode
 @warning 如果使用默认的 (titleLabel, contentLabel, <button0Label | button1Label>) 部件, 外部需要自定义设置对应的 (titleViewContentH, contentViewContentH, buttonsViewContentH) 部件高度,  将可能被内部重新布局时计算高度<屏幕旋转情况>覆盖. 该类对父类 JXPopupView 的各布局属性进行默认通用<General(目前包括 popupBgViewContentEdgeT, popupBgViewContentEdgeB, titleViewContentH, contentViewToAboveWidget, contentViewContentH, buttonsViewToAboveWidget, buttonsViewContentH)>化, 并提供 3 个部件的 custom 半自定义功能. 如果需要高度自定义, 继承抽象类 JXPopupView 于子类自定义即可.
 */
@interface JXPopupGeneralView : JXPopupView

// 标题
@property (nonatomic, readonly) UILabel *titleLabel; ///< 标题, 默认 font(18.0), textColor gray(51), textAlignment(center), numberOfLines(0)
@property (nonatomic, strong, nullable) UIView *customTitleView; ///< 自定义标题 <若自定义, 则必须一并实现 heightFor_customTitleView, 否则不展示.>, 如果设置 titleLabel 被忽略.
@property (nonatomic, copy) CGFloat (^heightFor_customTitleView)(void); ///< 自定义标题 高度. 若实现, 标题高度内部不做计算. <除自定义 customTitleView, 否则不建议实现, 只需设置好 titleLabel 相关属性, 内部计算.>

// 内容
@property (nonatomic, readonly) UILabel *contentLabel; ///< 内容 默认 font(14.0), textColor (gray 51), textAlignment(center), numberOfLines(0)
@property (nonatomic, strong, nullable) UIView *customContentView; ///< 自定义内容 <若自定义, 则必须一并实现 heightFor_customContentView, 否则不展示.>, 如果设置 contentLabel 被忽略.
@property (nonatomic, copy) CGFloat (^heightFor_customContentView)(void); ///< 自定义内容 高度. 若实现, 内容高度内部不做计算. <除自定义 customContentView, 否则不建议实现, 只需设置好contentLabel 相关属性, 内部计算.>

// 按钮
@property (nonatomic, readonly) UILabel *button0Label; ///< 左边按钮, button0Label 与 button1Label 可任意只设置一个. 默认 font(16.0), textColor (gray 51), textAlignment(center)
@property (nonatomic, readonly) UILabel *button1Label; ///< 右边按钮, button0Label 与 button1Label 可任意只设置一个. 默认 font(16.0), textColor (gray 51), textAlignment(center)
@property (nonatomic, strong, nullable) UIView *customButtonsView; ///< 自定义按钮 <若自定义, 则必须一并实现 heightFor_customButtonsView, 否则不展示.>, 如果设置 button0Label button1Label 被忽略.
@property (nonatomic, copy) CGFloat (^heightFor_customButtonsView)(void); ///< 自定义按钮 高度. 若实现, 按钮高度内部不做计算. <除自定义 customButtonsView, 否则不建议实现, 内部默认 44.0>

//
@property (nonatomic, readonly) UIView *buttonHorizontalLineView; ///< 按钮水平线
@property (nonatomic, readonly) UIView *buttonVerticalLineView; ///< 按钮竖直线

// 事件回调
@property (nonatomic, assign) BOOL hideJustByClicking; ///< 所有按钮点击后, 隐藏 self, 默认 NO.
@property (nonatomic, copy) void (^button0Click)(void); ///< button0 点击
@property (nonatomic, copy) void (^button1Click)(void); ///< button1 点击

@end

NS_ASSUME_NONNULL_END
