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
 @discussion 目前最多支持两个按钮, 如果需要支持更多按钮, 请自行创建 JXPopupGeneralView 子类, 封装底部按钮并加于 buttonsView 上, 同时设置 buttonsViewContentH 即可. 其它部位有需要自定义同理.
 */
@interface JXPopupGeneralView : JXPopupView

@property (nonatomic, readonly) UILabel *titleLabel; ///< 标题
@property (nonatomic, readonly) UILabel *contentLabel; ///< 内容
@property (nonatomic, readonly) UILabel *button0Label; ///< 左边按钮, button0Label 与 button1Label 设置一个时则显示一个按钮.
@property (nonatomic, readonly) UILabel *button1Label; ///< 右边按钮, button0Label 与 button1Label 设置一个时则显示一个按钮.

@property (nonatomic, readonly) UIView *buttonHorizontalLineView; ///< 按钮水平线
@property (nonatomic, readonly) UIView *buttonVerticalLineView; ///< 按钮竖直线

@property (nonatomic, copy) void (^button0Click)(void); ///< button0 点击
@property (nonatomic, copy) void (^button1Click)(void); ///< button1 点击

@end

NS_ASSUME_NONNULL_END
