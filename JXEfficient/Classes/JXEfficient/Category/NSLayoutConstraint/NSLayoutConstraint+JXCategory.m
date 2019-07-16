//
//  NSLayoutConstraint+JXCategory.m
//  JXEfficient
//
//  Created by augsun on 2/3/19.
//

#import "NSLayoutConstraint+JXCategory.h"

@implementation NSLayoutConstraint (JXCategory)

@end

@implementation UIView (NSLayoutConstraint_JXCategory)

- (void)jx_add_cons:(NSArray<NSLayoutConstraint *> *)cons {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:cons];
}

- (NSArray<NSLayoutConstraint *> *)jx_con_edgeEqual:(id)view2 {
    NSLayoutConstraint *con_T = [self jx_con_same:NSLayoutAttributeTop equal:view2 m:1.0 c:0.0];
    NSLayoutConstraint *con_L = [self jx_con_same:NSLayoutAttributeLeft equal:view2 m:1.0 c:0.0];
    NSLayoutConstraint *con_B = [self jx_con_same:NSLayoutAttributeBottom equal:view2 m:1.0 c:0.0];
    NSLayoutConstraint *con_R = [self jx_con_same:NSLayoutAttributeRight equal:view2 m:1.0 c:0.0];
    return @[con_T, con_L, con_B, con_R];
}

// same equal
- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att equal:(id)view2 m:(CGFloat)m c:(CGFloat)c {
    NSLayoutConstraint *con = [self jx_con_diff:att equal:view2 att2:att m:m c:c];
    return con;
}

- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att equal:(id)view2 m:(CGFloat)m c:(CGFloat)c p:(UILayoutPriority)p {
    NSLayoutConstraint *con = [self jx_con_diff:att equal:view2 att2:att m:m c:c p:p];
    return con;
}

// same lessEqual
- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att lessEqual:(id)view2 m:(CGFloat)m c:(CGFloat)c {
    NSLayoutConstraint *con = [self jx_con_diff:att lessEqual:view2 att2:att m:m c:c];
    return con;
}

- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att lessEqual:(id)view2 m:(CGFloat)m c:(CGFloat)c p:(UILayoutPriority)p {
    NSLayoutConstraint *con = [self jx_con_diff:att lessEqual:view2 att2:att m:m c:c p:p];
    return con;
}

// same greaterEqual
- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att greaterEqual:(id)view2 m:(CGFloat)m c:(CGFloat)c {
    NSLayoutConstraint *con = [self jx_con_diff:att greaterEqual:view2 att2:att m:m c:c];
    return con;
}

- (NSLayoutConstraint *)jx_con_same:(NSLayoutAttribute)att greaterEqual:(id)view2 m:(CGFloat)m c:(CGFloat)c p:(UILayoutPriority)p {
    NSLayoutConstraint *con = [self jx_con_diff:att greaterEqual:view2 att2:att m:m c:c p:p];
    return con;
}

// diff equal
- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att equal:(id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c {
    NSLayoutConstraint *con = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:att
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:view2
                                                           attribute:att2
                                                          multiplier:m
                                                            constant:c];
    return con;
}

- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att equal:(id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c p:(UILayoutPriority)p {
    NSLayoutConstraint *con = [self jx_con_diff:att equal:view2 att2:att2 m:m c:c];
    con.priority = p;
    return con;
}

// diff lessEqual
- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att lessEqual:(id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c {
    NSLayoutConstraint *con = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:att
                                                           relatedBy:NSLayoutRelationLessThanOrEqual
                                                              toItem:view2
                                                           attribute:att2
                                                          multiplier:m
                                                            constant:c];
    return con;
}

- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att lessEqual:(id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c p:(UILayoutPriority)p {
    NSLayoutConstraint *con = [self jx_con_diff:att lessEqual:view2 att2:att2 m:m c:c];
    con.priority = p;
    return con;
}

// diff lessEqual
- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att greaterEqual:(id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c {
    NSLayoutConstraint *con = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:att
                                                           relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                              toItem:view2
                                                           attribute:att2
                                                          multiplier:m
                                                            constant:c];
    return con;
}

- (NSLayoutConstraint *)jx_con_diff:(NSLayoutAttribute)att greaterEqual:(id)view2 att2:(NSLayoutAttribute)att2 m:(CGFloat)m c:(CGFloat)c p:(UILayoutPriority)p {
    NSLayoutConstraint *con = [self jx_con_diff:att greaterEqual:view2 att2:att2 m:m c:c];
    con.priority = p;
    return con;
}

@end

