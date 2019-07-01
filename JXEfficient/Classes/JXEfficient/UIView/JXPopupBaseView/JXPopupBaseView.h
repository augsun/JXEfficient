//
//  JXPopupBaseView.h
//  JXEfficient
//
//  Created by augsun on 2/23/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义弹窗的抽象类, 不直接实例化使用.
 添加到 UIWindow<[UIApplication sharedApplication].keyWindow> 上的全屏弹窗.
 内部封装实现了背景灰层的渐显渐隐, 灰色背景点击事件回调, 以及要实现动画改变<change>的回调, 以及动画结束<从 keyWindow 上移除>回调.
 */
@interface JXPopupBaseView : UIView

@property (nonatomic, copy) void (^backgroundTap)(void); ///< 背景点击 注意循环引用

/**
 显示 <添加到 UIWindow 上, 外部不需要添加约束>
 
 @param animated 是否显示动画
 @param change 要动画的 frame 或 color 写在这个 block 里 <类似 UIView 动画的 animations block>
 @param completion 动画结束
 */
- (void)show:(BOOL)animated change:(nullable void (^)(void))change completion:(nullable void (^)(void))completion NS_REQUIRES_SUPER;

/**
 隐藏 (动画)从 UIWindow 上移除
 
 @param animated 是否显示动画
 @param change 要动画的 frame 或 color 写在这个 block 里 <类似 UIView 动画的 animations block>
 @param completion 动画结束
 */
- (void)hide:(BOOL)animated change:(nullable void (^)(void))change completion:(nullable void (^)(void))completion NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
