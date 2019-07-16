//
//  JXCircularArcView.h
//  JXEfficient
//
//  Created by augsun on 7/15/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 圆弧位置 */
typedef NS_ENUM(NSInteger, JXCircularArcViewArcPosition) {
    JXCircularArcViewArcPositionTop = 1, ///< 上
    JXCircularArcViewArcPositionLeft, ///< 左
    JXCircularArcViewArcPositionBottom, ///< 下
    JXCircularArcViewArcPositionRight, ///< 右
};

/**
 单边指定圆弧
 */
@interface JXCircularArcView : UIView

@property (nonatomic, assign) JXCircularArcViewArcPosition arcPosition; ///< 圆弧位置 [上 | 左 | 下 | 右], 默认 下
@property (nonatomic, assign) CGFloat arcMigration; ///< 弧偏移 [高 | 宽], 可为负值, 正值凸 负值凹, 默认 20.0

@end

NS_ASSUME_NONNULL_END
