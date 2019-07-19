//
//  JXTestHomeCell.m
//  JXEfficient
//
//  Created by augsun on 7/3/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTestHomeCell.h"

#import <JXEfficient/JXEfficient.h>

@interface JXTestHomeCell ()

@end

@implementation JXTestHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textLabel.textColor = JX_COLOR_GRAY(51);
}

- (void)setModel:(JXTestHomeModel *)model {
    _model = model;
    
    self.textLabel.text = model.title;
}

@end
