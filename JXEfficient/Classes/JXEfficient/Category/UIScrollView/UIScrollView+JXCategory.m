//
//  UIScrollView+JXCategory.m
//  JXEfficient
//
//  Created by augsun on 3/2/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import "UIScrollView+JXCategory.h"

@implementation UIScrollView (JXCategory)

- (void)jx_scrollTo_x0:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}
    
- (void)jx_scrollTo_y0:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

@end
