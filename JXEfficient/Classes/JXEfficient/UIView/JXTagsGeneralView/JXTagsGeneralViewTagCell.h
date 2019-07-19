//
//  JXTagsGeneralViewTagCell.h
//  JXEfficient
//
//  Created by augsun on 5/2/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTagsGeneralViewTagModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 JXEfficient Internal Use Class.
 */
@interface JXTagsGeneralViewTagCell : UICollectionViewCell

+ (void)customForModel:(JXTagsGeneralViewTagModel *)model;

@property (nonatomic, strong) JXTagsGeneralViewTagModel *model;

@end

NS_ASSUME_NONNULL_END
