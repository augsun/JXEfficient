//
//  JXKeysValuesViewCell.m
//  JXEfficient
//
//  Created by augsun on 8/1/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXKeysValuesViewCell.h"
#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

@interface JXKeysValuesViewCell ()

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) NSLayoutConstraint *key_con_change; ///< 初始为 Y
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *key_cons; ///< [L, W, H] 用于调整边距

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSLayoutConstraint *value_con_change; ///< 初始为 Y
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *value_cons; ///< [L, R, H] 用于调整边距

@property (nonatomic, strong) UIView *separatorView; ///< 分割线

//
@property (nonatomic, strong) JXKeysValuesModel *model;
@property (nonatomic, strong) JXKeysValuesViewLayout *layout;

@end

@implementation JXKeysValuesViewCell

+ (void)countWithModel:(JXKeysValuesModel *)model layout:(JXKeysValuesViewLayout *)layout {
    //
    CGFloat width = layout.width - layout.contentEdges.left - layout.contentEdges.right;
    CGFloat key_w = 0.0;
    CGFloat value_w = 0.0;
    
    switch (layout.keyLayoutType) {
        case JXKeysValuesViewKeyLayoutTypePercentKeyWidth:
        {
            key_w = layout.percentOfKeyWidth * width - layout.keyContentEdges.left - layout.keyContentEdges.right;
        } break;
            
        case JXKeysValuesViewKeyLayoutTypeFixedWidth:
        {
            key_w = layout.keyFixedWidth - layout.keyContentEdges.left - layout.keyContentEdges.right;
        } break;
            
        default: break;
    }
    value_w = width - key_w - layout.keyContentEdges.left - layout.keyContentEdges.right - layout.valueContentEdges.left - layout.valueContentEdges.right;

    // key
    CGFloat key_h = 0.0;
    {
        CGSize size = CGSizeZero;
        if (layout.keyNumberOfLines == 1) {
            size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        }
        else {
            size = CGSizeMake(key_w, CGFLOAT_MAX);
        }
        
        if (model.key) {
            key_h = [model.key boundingRectWithSize:size
                                            options:JX_DRAW_OPTION
                                         attributes:@{
                                                      NSFontAttributeName: layout.keyFont,
                                                      }
                                            context:nil].size.height + 1.0;
        }
        else {
            key_h = [model.attributedKey boundingRectWithSize:size options:JX_DRAW_OPTION context:nil].size.height + 1.0;
        }
    }
    
    // value
    CGFloat value_h = 0.0;
    {
        CGSize single_line_size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);;
        CGSize multi_lines_size = CGSizeMake(value_w, CGFLOAT_MAX);
        
        if (model.value) {
            NSDictionary *attributes = @{
                                         NSFontAttributeName: layout.valueFont,
                                         };
            
            // 尝试获取第一行数据
            NSString *firstLine_value = [model.value componentsSeparatedByString:@"\n"].firstObject;
            if ([firstLine_value isEqualToString:model.value]) {
                firstLine_value = [model.value componentsSeparatedByString:@"\r\n"].firstObject;
            }
            
            CGFloat value_single_line_h = [firstLine_value boundingRectWithSize:single_line_size
                                                                        options:JX_DRAW_OPTION
                                                                     attributes:attributes
                                                                        context:nil].size.height + 1.0;
            
            // 单行条件下 <强制单行>
            if (layout.valueNumberOfLines == 1) {
                model.valueOnlyOneLine = YES;
                
                if (layout.keyForceCloseToCenterYIfValueOnlyOneLine) {
                    model.keyCloseTo = JXKeysValuesCloseToCenterY;
                }

                value_h = value_single_line_h;
            }
            // 多行条件下
            else {
                CGFloat value_multi_line_h = [model.value boundingRectWithSize:multi_lines_size
                                                                       options:JX_DRAW_OPTION
                                                                    attributes:attributes
                                                                       context:nil].size.height + 1.0;
                
                // 有多行
                if (value_multi_line_h > 1.5 * value_single_line_h) {
                    model.valueOnlyOneLine = NO;
                    
                    value_h = value_multi_line_h;
                }
                // 无多行 <强制为单行>
                else {
                    model.valueOnlyOneLine = YES;
                    
                    if (layout.keyForceCloseToCenterYIfValueOnlyOneLine) {
                        model.keyCloseTo = JXKeysValuesCloseToCenterY;
                    }

                    value_h = value_single_line_h;
                }
            }
        }
        else {
            // 尝试获取第一行数据 <目前以获取第一个字符为准, 会有不准确的情况>
            NSAttributedString *firstLine_value = [model.attributedValue attributedSubstringFromRange:NSMakeRange(0, 1)];
            CGFloat value_single_line_h = [firstLine_value boundingRectWithSize:single_line_size
                                                                        options:JX_DRAW_OPTION
                                                                        context:nil].size.height + 1.0;
            
            // 单行条件下 <强制单行>
            if (layout.valueNumberOfLines == 1) {
                model.valueOnlyOneLine = YES;
                
                if (layout.keyForceCloseToCenterYIfValueOnlyOneLine) {
                    model.keyCloseTo = JXKeysValuesCloseToCenterY;
                }
                
                value_h = value_single_line_h;
            }
            // 多行条件下
            else {
                CGFloat value_multi_line_h = [model.attributedValue boundingRectWithSize:multi_lines_size
                                                                                 options:JX_DRAW_OPTION
                                                                                 context:nil].size.height + 1.0;
                
                // 有多行
                if (value_multi_line_h > 1.5 * value_single_line_h) {
                    model.valueOnlyOneLine = NO;
                    
                    value_h = value_multi_line_h;
                }
                // 无多行 <强制为单行>
                else {
                    model.valueOnlyOneLine = YES;
                    
                    if (layout.keyForceCloseToCenterYIfValueOnlyOneLine) {
                        model.keyCloseTo = JXKeysValuesCloseToCenterY;
                    }
                    
                    value_h = value_single_line_h;
                }
            }
        }
    }

    //
    CGFloat row_h = MAX(
                        key_h + layout.keyContentEdges.top + layout.keyContentEdges.bottom,
                        value_h + layout.valueContentEdges.top + layout.valueContentEdges.bottom
                        );
    
    //
    model.key_w = key_w;
    model.key_h = key_h;
    
    model.value_w = value_w;
    model.value_h = value_h;
    
    if (layout.minimumRowHeight > 0.0) {
        row_h = row_h > layout.minimumRowHeight ? row_h : layout.minimumRowHeight;
    }
    
    model.row_h = row_h;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        //
        self.keyLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.keyLabel];
        self.keyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        {
            NSLayoutConstraint *con_toL = [self.keyLabel jx_con_same:NSLayoutAttributeLeft equal:self.contentView m:1.0 c:0.0];
            NSLayoutConstraint *con_w = [self.keyLabel jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:0.0];
            NSLayoutConstraint *con_h = [self.keyLabel jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:0.0];
            self.key_con_change = [self.keyLabel jx_con_same:NSLayoutAttributeCenterY equal:self.contentView m:1.0 c:0.0];
            self.key_cons = @[con_toL, con_w, con_h];
            [NSLayoutConstraint activateConstraints:@[con_toL, con_w, con_h, self.key_con_change]];
        }
        self.keyLabel.textColor = JX_COLOR_HEX(0x333333);
        self.keyLabel.numberOfLines = 0;

        self.valueLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.valueLabel];
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        {
            NSLayoutConstraint *con_toL = [self.valueLabel jx_con_diff:NSLayoutAttributeLeft equal:self.keyLabel att2:NSLayoutAttributeRight m:1.0 c:0.0];
            NSLayoutConstraint *con_toR = [self.valueLabel jx_con_same:NSLayoutAttributeRight equal:self.contentView m:1.0 c:0.0];
            NSLayoutConstraint *con_h = [self.valueLabel jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:0.0];
            self.value_con_change = [self.valueLabel jx_con_same:NSLayoutAttributeCenterY equal:self.contentView m:1.0 c:0.0];
            self.value_cons = @[con_toL, con_toR, con_h];
            [NSLayoutConstraint activateConstraints:@[con_toL, con_toR, con_h, self.value_con_change]];
        }
        self.valueLabel.textColor = JX_COLOR_HEX(0x333333);
        self.valueLabel.numberOfLines = 0;
    }
    return self;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        [self.contentView addSubview:_separatorView];
        _separatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.separatorView jx_con_same:NSLayoutAttributeLeft equal:self.contentView m:1.0 c:self.layout.separatorInset.left],
                                                  [self.separatorView jx_con_same:NSLayoutAttributeBottom equal:self.contentView m:1.0 c:-self.layout.separatorInset.bottom],
                                                  [self.separatorView jx_con_same:NSLayoutAttributeRight equal:self.contentView m:1.0 c:-self.layout.separatorInset.right],
                                                  [self.separatorView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_SCREEN_ONE_PIX],
                                                  ]];
        _separatorView.backgroundColor = self.layout.separatorColor;
    }
    return _separatorView;
}

- (void)refreshWithModel:(JXKeysValuesModel *)model layout:(JXKeysValuesViewLayout *)layout lastCell:(BOOL)lastCell {
    self.model = model;
    
    //
    if (layout.backgroundColorForDebug) {
        self.backgroundColor = JX_COLOR_RANDOM;
        self.keyLabel.backgroundColor = JX_COLOR_RANDOM;
        self.valueLabel.backgroundColor = JX_COLOR_RANDOM;
    }

    //
    if (self.layout != layout) {
        self.layout = layout;
        
        self.keyLabel.minimumScaleFactor = layout.keyMinimumScaleFactor;
        self.valueLabel.minimumScaleFactor = layout.valueMinimumScaleFactor;
        
        // key
        self.keyLabel.font = layout.keyFont;
        self.keyLabel.numberOfLines = layout.keyNumberOfLines;
        self.keyLabel.textAlignment = layout.keyTextAlignment;
        
        JXKeysValuesCloseTo keyCloseTo = JXKeysValuesCloseToCenterY;
        if (model.keyCloseTo == JXKeysValuesCloseToTop || model.keyCloseTo == JXKeysValuesCloseToCenterY || model.keyCloseTo == JXKeysValuesCloseToBottom) {
            keyCloseTo = model.keyCloseTo;
        }
        else if (layout.keyCloseTo == JXKeysValuesCloseToTop || layout.keyCloseTo == JXKeysValuesCloseToCenterY || layout.keyCloseTo == JXKeysValuesCloseToBottom) {
            keyCloseTo = layout.keyCloseTo;
        }
        
        switch (keyCloseTo) {
            case JXKeysValuesCloseToTop:
            {
                [NSLayoutConstraint deactivateConstraints:@[self.key_con_change]];
                self.key_con_change = [self.keyLabel jx_con_same:NSLayoutAttributeTop equal:self.contentView m:1.0 c:layout.keyContentEdges.top];
                [NSLayoutConstraint activateConstraints:@[self.key_con_change]];
            } break;
                
            case JXKeysValuesCloseToBottom:
            {
                [NSLayoutConstraint deactivateConstraints:@[self.key_con_change]];
                self.key_con_change = [self.keyLabel jx_con_same:NSLayoutAttributeBottom equal:self.contentView m:1.0 c:-layout.keyContentEdges.bottom];
                [NSLayoutConstraint activateConstraints:@[self.key_con_change]];
            } break;
                
            default: break;
        }
        self.key_cons[0].constant = layout.keyContentEdges.left;
        self.key_cons[1].constant = model.key_w;
        self.key_cons[2].constant = model.key_h;
        
        // value
        self.valueLabel.font = layout.valueFont;
        self.valueLabel.numberOfLines = layout.valueNumberOfLines;
        self.valueLabel.textAlignment = layout.valueTextAlignment;
        
        switch (layout.valueCloseTo) {
            case JXKeysValuesCloseToTop:
            {
                [NSLayoutConstraint deactivateConstraints:@[self.value_con_change]];
                self.value_con_change = [self.valueLabel jx_con_same:NSLayoutAttributeTop equal:self.contentView m:1.0 c:layout.valueContentEdges.top];
                [NSLayoutConstraint activateConstraints:@[self.value_con_change]];
            } break;
                
            case JXKeysValuesCloseToBottom:
            {
                [NSLayoutConstraint deactivateConstraints:@[self.value_con_change]];
                self.value_con_change = [self.valueLabel jx_con_same:NSLayoutAttributeBottom equal:self.contentView m:1.0 c:-layout.valueContentEdges.bottom];
                [NSLayoutConstraint activateConstraints:@[self.value_con_change]];
            } break;
                
            default: break;
        }
        self.value_cons[0].constant = self.layout.keyContentEdges.right + self.layout.valueContentEdges.left;
        self.value_cons[1].constant = -self.layout.valueContentEdges.right;
        self.value_cons[2].constant = model.value_h;
    }
    
    // key
    if (model.key) {
        self.keyLabel.text = model.key;
    }
    else {
        self.textLabel.attributedText = model.attributedKey;
    }
    
    // value
    if (model.value) {
        self.valueLabel.text = model.value;
    }
    else {
        self.valueLabel.attributedText = model.attributedValue;
        
        NSInteger lines = self.valueLabel.numberOfLines;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger lines1 = self.valueLabel.numberOfLines;
            NSLog(@"");
//            self.valueLabel.font.lineHeight
        });
    }
    
    // key
    self.keyLabel.textColor = model.keyTextColor != nil ? model.keyTextColor : layout.keyTextColor;

    // value
    self.valueLabel.textColor = model.valueTextColor != nil ? model.valueTextColor : layout.valueTextColor;

    //
    if (layout.showSeparator && !lastCell) {
        self.separatorView.hidden = NO;
    }
    else {
        _separatorView.hidden = YES;
    }
}

@end
