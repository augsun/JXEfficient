//
//  JXTagsGeneralView.m
//  JXEfficient_Example
//
//  Created by augsun on 5/2/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import "JXTagsGeneralView.h"
#import "JXTagsGeneralViewTagCell.h"
#import "JXMacro.h"
#import "JXInline.h"

static const NSInteger kNormalColorDefault = 0x666666;
static const NSInteger kSelectedColorDefault = 0x333333;
static const CGFloat kNormalFontSizeDefault = 14.0;
static const CGFloat kSelectedFontSizeDefault = 14.0;

@interface JXTagsGeneralView ()

@property (nonatomic, copy) NSArray <JXTagsGeneralViewTagModel *> *models;

@end

@implementation JXTagsGeneralView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self jx_setting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self jx_setting];
    }
    return self;
}

- (void)jx_setting {
    JX_WEAK_SELF;
    
    //
    self.normalColor = JX_COLOR_HEX(kNormalColorDefault);
    self.selectedColor = JX_COLOR_HEX(kSelectedColorDefault);
    self.normalFont = [UIFont systemFontOfSize:kNormalFontSizeDefault];
    self.selectedFont = [UIFont systemFontOfSize:kSelectedFontSizeDefault];
    
    self.forRemainSpacingLayoutType = JXTagsViewForRemainSpacingLayoutTypeWeightedAverage;
    self.tagCellClass = [JXTagsGeneralViewTagCell class];

    //
    self.tagCellForIndex = ^(__kindof UICollectionViewCell * _Nonnull tagCell, NSInteger tagIndex) {
        JX_STRONG_SELF;
        JXTagsGeneralViewTagCell *cell = tagCell;
        cell.model = self.models[tagIndex];
    };
    self.tagModelsForReloadData = ^NSArray<__kindof JXTagsViewTagModel *> * _Nullable{
        JX_STRONG_SELF;
        return self.models;
    };
}

- (void)setNormalColor:(UIColor *)normalColor {
    if (normalColor) {
        _normalColor = normalColor;
        [self checkToReloadData];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if (selectedColor) {
        _selectedColor = selectedColor;
        [self checkToReloadData];
    }
}

- (void)setNormalFont:(UIFont *)normalFont {
    if (normalFont) {
        _normalFont = normalFont;
        [self checkToReloadData];
    }
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    if (selectedFont) {
        _selectedFont = selectedFont;
        [self checkToReloadData];
    }
}

- (void)checkToReloadData {
    if (self.models.count > 0) {
        [self jx_refreshModels];
    }
}

- (void)setTagNames:(NSArray<NSString *> *)tagNames {
    NSMutableArray <JXTagsGeneralViewTagModel *> *tempArr = [[NSMutableArray alloc] init];
    for (NSString *strEnum in tagNames) {
        NSString *tempStr = strEnum;
        if (jx_isStrObj(strEnum)) {
            if (tempStr.length == 0) {
                tempStr = @"Empty string";
            }
        }
        else {
            tempStr = jx_strValue(tempStr);
            if (tempStr.length == 0) {
                tempStr = @"Non string";
            }
        }
        
        JXTagsGeneralViewTagModel *model = [[JXTagsGeneralViewTagModel alloc] init];
        model.tagName = tempStr;
        
        [tempArr addObject:model];
    }

    _tagNames = tagNames;

    //
    self.models = tempArr;
    
    //
    [self jx_refreshModels];
    
}

- (void)jx_refreshModels {
    UIFont *normalFont = self.normalFont;
    UIFont *selectedFont = self.selectedFont;
    
    for (JXTagsGeneralViewTagModel *modelEnum in self.models) {
        modelEnum.normalColor = self.normalColor;
        modelEnum.selectedColor = self.selectedColor;
        modelEnum.normalFont = normalFont;
        modelEnum.selectedFont = selectedFont;
        
        [JXTagsGeneralViewTagCell customForModel:modelEnum];
    }
    
    [self reloadData];
}

@end
