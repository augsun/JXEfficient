//
//  JXKeysValuesViewLayout.m
//  JXEfficient
//
//  Created by augsun on 8/1/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXKeysValuesViewLayout.h"
#import "JXMacro.h"

@implementation JXKeysValuesViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.keyLayoutType = JXKeysValuesViewKeyLayoutTypePercentKeyWidth;
        self.percentOfKeyWidth = 0.2;
        
        self.keyNumberOfLines = 0;
        self.keyCloseTo = JXKeysValuesCloseToCenterY;
        self.keyTextAlignment = NSTextAlignmentCenter;
        self.keyTextColor = JX_COLOR_HEX(0x333333);
        self.keyContentEdges = UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
        self.keyMinimumScaleFactor = 0.9;
        
        self.valueNumberOfLines = 0;
        self.valueCloseTo = JXKeysValuesCloseToCenterY;
        self.valueTextAlignment = NSTextAlignmentCenter;
        self.valueTextColor = JX_COLOR_HEX(0x333333);
        self.valueContentEdges = UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
        self.valueMinimumScaleFactor = 0.9;

        self.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0);
    }
    return self;
}

- (UIFont *)keyFont {
    if (!_keyFont) {
        _keyFont = [UIFont systemFontOfSize:14.0];
    }
    return _keyFont;
}

- (UIFont *)valueFont {
    if (!_valueFont) {
        _valueFont = [UIFont systemFontOfSize:14.0];
    }
    return _valueFont;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = JX_COLOR_HEX(0xDEDEDE);
    }
    return _separatorColor;
}

@end
