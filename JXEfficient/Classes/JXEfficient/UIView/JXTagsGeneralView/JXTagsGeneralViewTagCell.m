//
//  JXTagsGeneralViewTagCell.m
//  JXEfficient_Example
//
//  Created by augsun on 5/2/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import "JXTagsGeneralViewTagCell.h"
#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

static const CGFloat kNameLabel_toLR = 1.0;

@interface JXTagsGeneralViewTagCell ()

@property (nonatomic, strong) UILabel *tagNameLabel;

@end

@implementation JXTagsGeneralViewTagCell

+ (void)customForModel:(JXTagsGeneralViewTagModel *)model {
    CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGFloat tagName_w_normal = [model.tagName boundingRectWithSize:size
                                                           options:JX_DRAW_OPTION
                                                        attributes:@{NSFontAttributeName: model.normalFont}
                                                           context:nil].size.width + 1.0;
    CGFloat tagName_w_selected = [model.tagName boundingRectWithSize:size
                                                             options:JX_DRAW_OPTION
                                                          attributes:@{NSFontAttributeName: model.selectedFont}
                                                             context:nil].size.width + 1.0;
    CGFloat tagName_w = MAX(tagName_w_normal, tagName_w_selected);

    CGFloat tag_w = tagName_w + 2 * kNameLabel_toLR;
    model.indicatorWidth = tagName_w;
    model.tagWidth = tag_w;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.tagNameLabel = [[UILabel alloc] init];
        [self addSubview:self.tagNameLabel];
        self.tagNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.tagNameLabel jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                                  [self.tagNameLabel jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:kNameLabel_toLR],
                                                  [self.tagNameLabel jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                                  [self.tagNameLabel jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:-kNameLabel_toLR],
                                                  ]];
        self.tagNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setModel:(JXTagsGeneralViewTagModel *)model {
    _model = model;
    
    self.tagNameLabel.text = model.tagName;
    
    if (model.selected) {
        self.tagNameLabel.font = model.selectedFont;
        self.tagNameLabel.textColor = model.selectedColor;
    }
    else {
        self.tagNameLabel.font = model.normalFont;
        self.tagNameLabel.textColor = model.normalColor;
    }
}

@end
