//
//  JXTagsGeneralViewTagModel.h
//  JXEfficient_Example
//
//  Created by augsun on 5/2/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import "JXTagsViewTagModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 JXEfficient Internal Use Class.
 */
@interface JXTagsGeneralViewTagModel : JXTagsViewTagModel

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;

@end

NS_ASSUME_NONNULL_END
