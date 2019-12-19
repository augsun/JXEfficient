//
//  JXPhotosGeneralPreviewBottomView.m
//  JXEfficient
//
//  Created by augsun on 7/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralPreviewBottomView.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

#import "JXPhotosGeneralPreviewBottomTagCell.h"

const CGFloat JXPhotosGeneralPreviewBottomViewTagsFixedHeight = 80.0;

@interface JXPhotosGeneralPreviewBottomView ()

@end

@implementation JXPhotosGeneralPreviewBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // tagsView
        _tagsView = [[JXPhotosGeneralPreviewBottomTagsView alloc] init];
        [self addSubview:self.tagsView];
        self.tagsView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.tagsView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                                  [self.tagsView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.tagsView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [self.tagsView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JXPhotosGeneralPreviewBottomViewTagsFixedHeight],
                                                  ]];
        self.tagsView.backgroundColor = [JX_COLOR_GRAY(40) colorWithAlphaComponent:0.9];

        // bottomBarView
        _bottomBarView = [[JXPhotosGeneralBottomBarView alloc] init];
        [self addSubview:self.bottomBarView];
        self.bottomBarView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.bottomBarView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.bottomBarView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                                  [self.bottomBarView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [self.bottomBarView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_TABBAR_H],
                                                  ]];
        self.bottomBarView.backgroundColor = [JX_COLOR_GRAY(40) colorWithAlphaComponent:0.9];
    }
    return self;
}

@end
