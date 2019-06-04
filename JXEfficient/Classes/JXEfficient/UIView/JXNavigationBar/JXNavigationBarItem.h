//
//  JXNavigationBarItem.h
//  JXEfficient
//
//  Created by augsun on 3/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const NSInteger JXNavigationBarItemNormalTitleColorDefault; ///< Normal 状态下默认颜色
UIKIT_EXTERN const NSInteger JXNavigationBarItemHighlightedColorDefault; ///< Highlighted 状态下默认颜色
UIKIT_EXTERN const NSInteger JXNavigationBarItemDisabledColorDefault; ///< Disabled 状态下默认颜色

/**
 导航条的 Item.
 
 @discussion 最小内容宽度不会小于 20pt, contentEdgeInsets.left 和 contentEdgeInsets.right 默认 4pt.
 */
@interface JXNavigationBarItem : UIView

@property (nonatomic, readonly) BOOL rightForShowing; ///< 是否符合展示

#pragma mark - 标题 设置方式

/**
 标题 设置方式 1: 不同状态下 [同一标题 同一颜色 同一字体]

 @param title 标题
 @param color 颜色, 默认 normal:0x333333, highlighted:0x999999, disabledColor:0xbbbbbb
 @param font 字体, 默认系统字体 15pt
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setTitle:(nullable NSString *)title
           color:(nullable UIColor *)color
            font:(nullable UIFont *)font;

/**
 标题 设置方式 2: 不同状态下 [同一标题 不同颜色 同一字体]

 @param title 标题
 @param normalColor Normal 状态下颜色
 @param highlightedColor Highlighted 状态下颜色
 @param disabledColor Disabled 状态下颜色
 @param font 字体, 默认系统字体 15pt
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setTitle:(nullable NSString *)title
     normalColor:(nullable UIColor *)normalColor
highlightedColor:(nullable UIColor *)highlightedColor
   disabledColor:(nullable UIColor *)disabledColor
            font:(nullable UIFont *)font;

/**
 标题 设置方式 3: 不同状态下 [不同标题 不同颜色 同一字体]

 @param normalTitle Normal 状态下标题
 @param normalColor Normal 状态下颜色
 @param highlightedTitle Highlighted 状态下标题
 @param highlightedColor Highlighted 状态下颜色
 @param disabledTitle Disabled 状态下标题
 @param disabledColor Disabled 状态下颜色
 @param font 字体, 默认系统字体 15pt
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setNormalTitle:(nullable NSString *)normalTitle
           normalColor:(nullable UIColor *)normalColor
      highlightedTitle:(nullable NSString *)highlightedTitle
      highlightedColor:(nullable UIColor *)highlightedColor
         disabledTitle:(nullable NSString *)disabledTitle
         disabledColor:(nullable UIColor *)disabledColor
                  font:(nullable UIFont *)font;

/**
 标题 设置方式 4: 自定义富文本设置 (支持更多样式)

 @param normalAttributedTitle Normal 状态下富文本标题
 @param highlightedAttributedTitle Highlighted 状态下富文本标题
 @param disabledAttributedTitle Disabled 状态下富文本标题
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setNormalAttributedTitle:(nullable NSAttributedString *)normalAttributedTitle
      highlightedAttributedTitle:(nullable NSAttributedString *)highlightedAttributedTitle
         disabledAttributedTitle:(nullable NSAttributedString *)disabledAttributedTitle;

#pragma mark - 图片 设置方式

/**
 图片 设置方式

 @param normalImage Normal 状态下图片
 @param highlightedImage Highlighted 状态下图片
 @param disabledImage Disabled 状态下图片
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setImageForNormal:(nullable UIImage *)normalImage
              highlighted:(nullable UIImage *)highlightedImage
                 disabled:(nullable UIImage *)disabledImage;

#pragma mark - 背景图片 设置方式

/**
 背景图片 设置方式

 @param normalBgImage Normal 状态下背景图片
 @param highlightedBgImage Highlighted 状态下背景图片
 @param disabledBgImage Disabled 状态下背景图片
 */
- (void)setBackgroundImageForNormal:(nullable UIImage *)normalBgImage
                        highlighted:(nullable UIImage *)highlightedBgImage
                           disabled:(nullable UIImage *)disabledBgImage;

#pragma mark - 事件及样式

@property (nonatomic, copy, nullable) void (^click)(void); ///< 点击事件响应回调
@property (nonatomic, assign) BOOL enable; ///< 是否能响应点击事件
@property (nonatomic, assign) CGFloat titleMinimumScaleFactor; ///< 标题 UILabel 的 minimumScaleFactor 属性, 默认 0.65
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; ///< 内容边距, 默认 [0, 4, 0, 4]





/* ================================================================================================== */
/* ======================== JXEfficient Internal Use Properties And Methods. ======================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Internal Use Properties And Methods.

@property (nonatomic, readonly) CGFloat itemWidth; ///< itemView 的宽度
@property (nonatomic, copy) void (^needLayout)(void); ///< 回调调整布局

@end

NS_ASSUME_NONNULL_END
