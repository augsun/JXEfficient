//
//  JXFlowViewItemView.h
//  JXEfficient
//
//  Created by augsun on 9/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 子类必须继承自 MCFlowItemView, 且必须是 xib
 */
@interface JXFlowViewItemView : UIView

// 以下为私有属性
@property (nonatomic, assign) BOOL didSetConstraint; ///< 是否已经设置了约束
@property (nonatomic, strong) NSLayoutConstraint *conToL;
@property (nonatomic, strong) NSLayoutConstraint *conToT;
@property (nonatomic, strong) NSLayoutConstraint *conW;
@property (nonatomic, strong) NSLayoutConstraint *conH;

@end

NS_ASSUME_NONNULL_END
