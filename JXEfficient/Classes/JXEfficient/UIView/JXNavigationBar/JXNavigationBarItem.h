//
//  JXNavigationBarItem.h
//  JXEfficient
//
//  Created by augsun on 3/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const NSInteger JXNavigationBarItemNormalTitleColorDefault; ///< Normal 状态下默认颜色, 0x333333
UIKIT_EXTERN const NSInteger JXNavigationBarItemHighlightedColorDefault; ///< Highlighted 状态下默认颜色, 0xcccccc
UIKIT_EXTERN const NSInteger JXNavigationBarItemDisabledColorDefault; ///< Disabled 状态下默认颜色, 0xbbbbbb

UIKIT_EXTERN const NSInteger JXNavigationBarItemFontSizeDefault; ///< 默认 Item 的 fontSize, 15.0pt

UIKIT_EXTERN const NSInteger JXNavigationBarItemContentMinWidth; ///< 最小内容宽度, 20.0pt

/**
 导航条的 Item.
 
 @discussion 最小内容宽度不会小于 20pt, 高度固定 44pt, contentEdgeInsets.left 和 contentEdgeInsets.right 默认 4pt. 需要隐藏可以调用 JXNavigationBarItem.hidden 属性.
 */
@interface JXNavigationBarItem : UIView

@property (nonatomic, readonly) BOOL rightForShowing; ///< 是否符合展示

@property (nonatomic, readonly) UIButton *button; ///< 按钮, 其 minimumScaleFactor 默认 0.65.
@property (nonatomic, copy, nullable) void (^click)(void); ///< 点击事件响应回调
@property (nonatomic, assign) BOOL enable; ///< 是否能响应点击事件(非隐藏该 Item)

@property (nonatomic, readonly) CGFloat contentWidth; ///< 内容宽度, 最小不低于 JXNavigationBarItemContentMinWidth.
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; ///< 内容边距, 默认 [0, 4, 0, 4]
@property (nonatomic, readonly) CGFloat itemWidth; ///< 最佳 itemView 的宽度 <即 contentEdgeInsets.left + contentWidth + contentEdgeInsets.right>.

#pragma mark - 标题 设置方式

/**
 标题 设置方式 1_0: 不同状态下 [同一标题 同一颜色 同一字体]
 
 @param title 标题
 @discussion 同一颜色为 <JXNavigationBarItemNormalTitleColorDefault, JXNavigationBarItemHighlightedColorDefault, JXNavigationBarItemDisabledColorDefault>, 同一字体为 <系统字体 JXNavigationBarItemFontSizeDefault>
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setTitle:(NSString *)title;

/**
 标题 设置方式 1_1: 不同状态下 [同一标题 同一颜色 同一字体]

 @param title 标题
 @param color 颜色, 为 nil 则默认 [JXNavigationBarItemNormalTitleColorDefault, JXNavigationBarItemHighlightedColorDefault, JXNavigationBarItemDisabledColorDefault]
 @param font 字体, 为 nil 则默认系统字体 JXNavigationBarItemFontSizeDefault
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setTitle:(NSString *)title
           color:(nullable UIColor *)color
            font:(nullable UIFont *)font;

/**
 标题 设置方式 2: 不同状态下 [同一标题 不同颜色 同一字体]

 @param title 标题
 @param normalColor Normal 状态下颜色, 为 nil 则默认 JXNavigationBarItemNormalTitleColorDefault
 @param highlightedColor Highlighted 状态下颜色, 为 nil 则默认 JXNavigationBarItemHighlightedColorDefault
 @param disabledColor Disabled 状态下颜色, 为 nil 则默认 JXNavigationBarItemDisabledColorDefault
 @param font 字体, 为 nil 则默认系统字体 JXNavigationBarItemFontSizeDefault
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setTitle:(NSString *)title
     normalColor:(nullable UIColor *)normalColor
highlightedColor:(nullable UIColor *)highlightedColor
   disabledColor:(nullable UIColor *)disabledColor
            font:(nullable UIFont *)font;

/**
 标题 设置方式 3: 不同状态下 [不同标题 不同颜色 同一字体]

 @param normalTitle Normal 状态下标题
 @param normalColor Normal 状态下颜色, 为 nil 则默认 JXNavigationBarItemNormalTitleColorDefault
 @param highlightedTitle Highlighted 状态下标题, 为 nil 则取 normalTitle.
 @param highlightedColor Highlighted 状态下颜色, 为 nil 则默认 JXNavigationBarItemHighlightedColorDefault
 @param disabledTitle Disabled 状态下标题, 为 nil 则取 normalTitle.
 @param disabledColor Disabled 状态下颜色, 为 nil 则默认 JXNavigationBarItemDisabledColorDefault
 @param font 字体, 为 nil 则默认系统字体 JXNavigationBarItemFontSizeDefault
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setNormalTitle:(NSString *)normalTitle
           normalColor:(nullable UIColor *)normalColor
      highlightedTitle:(nullable NSString *)highlightedTitle
      highlightedColor:(nullable UIColor *)highlightedColor
         disabledTitle:(nullable NSString *)disabledTitle
         disabledColor:(nullable UIColor *)disabledColor
                  font:(nullable UIFont *)font;

/**
 标题 设置方式 4: 自定义富文本设置 (支持更多样式)

 @param normalAttributedTitle Normal 状态下富文本标题
 @param highlightedAttributedTitle Highlighted 状态下富文本标题, 为 nil 则默认 normalAttributedTitle
 @param disabledAttributedTitle Disabled 状态下富文本标题, 为 nil 则默认 normalAttributedTitle
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示, 即 rightForShowing == NO. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setNormalAttributedTitle:(NSAttributedString *)normalAttributedTitle
      highlightedAttributedTitle:(nullable NSAttributedString *)highlightedAttributedTitle
         disabledAttributedTitle:(nullable NSAttributedString *)disabledAttributedTitle;

#pragma mark - 图片 设置方式

/**
 图片 设置方式

 @param normalImage Normal 状态下图片
 @param highlightedImage Highlighted 状态下图片, 为 nil 则默认 normalImage
 @param disabledImage Disabled 状态下图片, 为 nil 则默认 normalImage
 @warning 如果传入的参数不符合展示, 该 Item 不会被展示. 标题 设置方式 和 "图片 设置方式" 会相互覆盖, 不能共存.
 */
- (void)setImageForNormal:(UIImage *)normalImage
              highlighted:(nullable UIImage *)highlightedImage
                 disabled:(nullable UIImage *)disabledImage;

#pragma mark - 背景图片 设置方式

/**
 背景图片 设置方式

 @param normalBgImage Normal 状态下背景图片
 @param highlightedBgImage Highlighted 状态下背景图片, 为 nil 则默认 normalImage
 @param disabledBgImage Disabled 状态下背景图片, 为 nil 则默认 normalImage
 */
- (void)setBackgroundImageForNormal:(UIImage *)normalBgImage
                        highlighted:(nullable UIImage *)highlightedBgImage
                           disabled:(nullable UIImage *)disabledBgImage;





/* ================================================================================================== */
/* ======================== JXEfficient Internal Use Properties And Methods. ======================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Internal Use Properties And Methods.

@property (nonatomic, copy) void (^setNeedsLayoutInHoldingView)(void); ///< 回调标记持有视图进行重新布局

@end

NS_ASSUME_NONNULL_END
