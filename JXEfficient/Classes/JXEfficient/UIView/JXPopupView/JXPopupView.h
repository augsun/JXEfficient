//
//  JXPopupView.h
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import "JXPopupBaseView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 JXPopupView.popupBgView 的贴近位置.
 */
typedef NS_ENUM(NSUInteger, JXPopupViewCloseTo) {
    JXPopupViewCloseToCenter, ///< 居中, 默认
    JXPopupViewCloseToTop, ///< 靠上
    JXPopupViewCloseToBottom, ///< 靠下
};

/**
 自定义弹窗的抽象类, 不直接实例化使用. 请使用其子类 JXPopupGeneralView 或自定义子类进行实例化使用.
 @discussion 该抽象类为内部布局使用.
 */
@interface JXPopupView : JXPopupBaseView

//
@property (nonatomic, assign) JXPopupViewCloseTo closeTo; ///< popupView 的贴近位置
@property (nonatomic, assign) BOOL animation; ///< 显示或隐藏是否动画
@property (nonatomic, assign) CGFloat cornerRadius; ///< 圆角, 默认 12.0

// popupBgView
@property (nonatomic, readonly) UIView *popupBgView; ///< 主弹窗视图
@property (nonatomic, assign) CGFloat popupBgViewToT_min; ///< popupBgView 与 self 上边间距, 默认 40.0
@property (nonatomic, assign) CGFloat popupBgViewToLR; ///< popupBgView 与 self 左右边间距, 默认 20.0
@property (nonatomic, assign) CGFloat popupBgViewToB_min; ///< popupBgView 与 self 下边间距, 默认 40.0

@property (nonatomic, assign) CGFloat popupBgViewContentEdgeT; ///< popupBgView 子控件起始位置顶边距, 默认 8.0
@property (nonatomic, assign) CGFloat popupBgViewContentEdgeB; ///< popupBgView 子控件结束位置底边距, 默认 8.0

// titleView
@property (nonatomic, readonly) UIView *titleView; ///< popupBgView -> titleView <标题视图>, (若自定义, 加在该 View 上).
@property (nonatomic, assign) CGFloat titleViewToAboveWidget; ///< 距上个控件的间距, 如果为第一个控件, 则取 popupBgViewContentEdgeT. 注: titleView 目前为第一个控件, 该属性暂无用.
@property (nonatomic, assign) UIEdgeInsets titleViewEdgeInsets; ///< 默认 {0.0, 8.0, 0.0, 8.0}
@property (nonatomic, assign) CGFloat titleViewContentH; ///< 不包含 titleViewEdgeInsets 的高度, 为 0.0 时隐藏 titleView.

// contentView
@property (nonatomic, readonly) UIView *contentView; ///< popupBgView -> contentBgView -> scrollView -> contentView <内容视图>, (若自定义, 加在该 View 上).
@property (nonatomic, assign) CGFloat contentViewToAboveWidget; ///< 距上个控件的间距, 如果为第一个控件, 则取 popupBgViewContentEdgeT.
@property (nonatomic, assign) UIEdgeInsets contentViewEdgeInsets; ///< 默认 {15.0, 15.0, 20.0, 15.0}
@property (nonatomic, assign) CGFloat contentViewContentH; ///< 不包含 contentViewEdgeInsets 的高度, 内容区域, 可以设置很大, 将进行滚动. 为 0.0 时隐藏 contentView.

// buttonsView
@property (nonatomic, readonly) UIView *buttonsView; ///< popupBgView -> buttonsView <按钮视图>, (若自定义, 加在该 View 上).
@property (nonatomic, assign) CGFloat buttonsViewToAboveWidget; ///< 距上个控件的间距, 如果为第一个控件, 则取 popupBgViewContentEdgeT.
@property (nonatomic, assign) UIEdgeInsets buttonsViewEdgeInsets; ///< 默认 {0.0, 0.0, 0.0, 0.0}
@property (nonatomic, assign) CGFloat buttonsViewContentH; ///< 不包含 buttonsViewEdgeInsets 的高度, 为 0.0 时隐藏 buttonsView.

/**
 显示 popup.
 */
- (void)show;

/**
 布局改变后调用

 @param animated 是否动画调整布局
 */
- (void)refreshAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
