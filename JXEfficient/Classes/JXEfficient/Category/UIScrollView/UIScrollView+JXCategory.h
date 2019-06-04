//
//  UIScrollView+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 3/2/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (JXCategory)

/**
 滚动到左边.

 @param animated 动画与否.
 */
- (void)jx_scrollTo_x0:(BOOL)animated;

/**
 滚动到顶边.
 
 @param animated 动画与否.
 */
- (void)jx_scrollTo_y0:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
