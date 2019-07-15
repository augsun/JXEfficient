//
//  JXCircularArcView.h
//  JXEfficient
//
//  Created by augsun on 7/15/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 位置 */
typedef NS_ENUM(NSInteger, JXCircularArcViewArcPosition) {
    JXCircularArcViewArcPositionTop        = 1, ///< 上
    JXCircularArcViewArcPositionLeft       = 2, ///< 左
    JXCircularArcViewArcPositionBottom     = 3, ///< 下
    JXCircularArcViewArcPositionRight      = 4, ///< 右
};

/**
 单边指定圆弧
 */
@interface JXCircularArcView : UIView

@property (nonatomic, assign) JXCircularArcViewArcPosition position; ///< 位置 [上 | 左 | 下 | 右], 默认 下
@property (nonatomic, assign) CGFloat radian; ///< 圆弧高 或 宽, 可为负值, 正值凸 负值凹, 默认 15.0

@end

NS_ASSUME_NONNULL_END
