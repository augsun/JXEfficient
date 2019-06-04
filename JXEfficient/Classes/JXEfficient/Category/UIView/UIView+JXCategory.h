//
//  UIView+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 6/2/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JXCategory)

/**
 从 xib 取得 view
 */
+ (nullable instancetype)jx_createFromXib;

/**
 在 bundle 里, 从 xib 取得 view
 */
+ (nullable instancetype)jx_createFromXibInBundle:(nullable NSBundle *)bundle;

+ (nullable instancetype)jx_createFromXibWithFrame:(CGRect)frame;
+ (nullable instancetype)jx_createFromXibWithFrame:(CGRect)frame inBundle:(nullable NSBundle *)bundle;

// 快速(设置或取得) view 的坐标
@property (nonatomic, assign)   CGFloat     jx_x;
@property (nonatomic, assign)   CGFloat     jx_y;
@property (nonatomic, assign)   CGFloat     jx_width;
@property (nonatomic, assign)   CGFloat     jx_height;
@property (nonatomic, assign)   CGPoint     jx_origin;
@property (nonatomic, assign)   CGSize      jx_size;
@property (nonatomic, assign)   CGFloat     jx_centerX;
@property (nonatomic, assign)   CGFloat     jx_bottom;
@property (nonatomic, assign)   CGFloat     jx_right;

- (void)jx_subviewsHidden:(BOOL)hidden; ///< 隐藏子视图
- (void)jx_removeAllSubviews; ///< 移除子视图

@end

 NS_ASSUME_NONNULL_END










