//
//  NSLayoutConstraint+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 2/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (JXCategory)

@end

/**
 NSLayoutConstraint 在 UIView 下使用的简单封装
 */
@interface UIView (NSLayoutConstraint_JXCategory)

/**
 添加约束

 @param cons 要添加的约束
 @discussion 内部将设置: self.translatesAutoresizingMaskIntoConstraints = NO, 和 [NSLayoutConstraint activateConstraints:cons].
 */
- (void)jx_add_cons:(NSArray <NSLayoutConstraint *> *)cons;

/**
 边距约束于 view2 的边距

 @param view2 相关的 view2
 @return 返回该约束的实例数组 @[上, 左, 下, 右].
 */
- (NSArray <NSLayoutConstraint *> *)jx_con_edgeEqual:(id)view2;

/**
 将要约束的 att 与 view2 的 att 相同, 其 NSLayoutRelation 为 Equal

 @param att 将要约束的 att
 @param view2 相关的 view2
 @param m multiplier
 @param c constant
 @return 返回该约束的实例
 */
- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att equal:(nullable id)view2 m:(CGFloat)m c:(CGFloat)c;

/**
 将要约束的 att 与 view2 的 att 相同, 其 NSLayoutRelation 为 LessThanOrEqual
 
 @param att 将要约束的 att
 @param view2 相关的 view2
 @param m multiplier
 @param c constant
 @return 返回该约束的实例
 */
- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att lessEqual:(nullable id)view2 m:(CGFloat)m c:(CGFloat)c;

/**
 将要约束的 att 与 view2 的 att 相同, 其 NSLayoutRelation 为 GreaterThanOrEqual
 
 @param att 将要约束的 att
 @param view2 相关的 view2
 @param m multiplier
 @param c constant
 @return 返回该约束的实例
 */
- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att greaterEqual:(nullable id)view2 m:(CGFloat)m c:(CGFloat)c;

/**
 将要约束的 att 与 view2 的 att 不同, 其 NSLayoutRelation 为 Equal

 @param att 将要约束的 att
 @param view2 相关的 view2
 @param att2 相关的 view2 的 att2
 @param m multiplier
 @param c constant
 @return 返回该约束的实例
 */
- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att equal:(nullable id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c;

/**
 将要约束的 att 与 view2 的 att 不同, 其 NSLayoutRelation 为 LessThanOrEqual
 
 @param att 将要约束的 att
 @param view2 相关的 view2
 @param att2 相关的 view2 的 att2
 @param m multiplier
 @param c constant
 @return 返回该约束的实例
 */
- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att lessEqual:(nullable id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c;

/**
 将要约束的 att 与 view2 的 att 不同, 其 NSLayoutRelation 为 GreaterThanOrEqual
 
 @param att 将要约束的 att
 @param view2 相关的 view2
 @param att2 相关的 view2 的 att2
 @param m multiplier
 @param c constant
 @return 返回该约束的实例
 */
- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att greaterEqual:(nullable id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c;

@end

NS_ASSUME_NONNULL_END

