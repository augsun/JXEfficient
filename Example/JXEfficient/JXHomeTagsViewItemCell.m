//
//  JXHomeTagsViewItemCell.m
//  JXEfficient_Example
//
//  Created by augsun on 2/27/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXHomeTagsViewItemCell.h"
#import <JXEfficient.h>

static const CGFloat kTagNameLabel_toLR = 4.0;

@interface JXHomeTagsViewItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;

@end

@implementation JXHomeTagsViewItemCell

+ (void)customForModel:(JXHomeTagsModel *)model inHeight:(CGFloat)inHeight {
    CGSize size = CGSizeMake(CGFLOAT_MAX, inHeight);
    CGFloat wTagName = [model.tagName boundingRectWithSize:size
                                                   options:JX_DRAW_OPTION
                                                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                                   context:nil].size.width + 1.0;
    
    model.tagWidth = wTagName + 2 * kTagNameLabel_toLR;
    model.indicatorWidth = wTagName;

}

- (void)setModel:(JXHomeTagsModel *)model {
    _model = model;
    
    self.tagNameLabel.text = model.tagName;
    
    if (model.tagSelected) {
        self.tagNameLabel.textColor = [UIColor redColor];
    }
    else {
        self.tagNameLabel.textColor = [UIColor grayColor];
    }
}

@end
