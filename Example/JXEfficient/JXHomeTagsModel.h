//
//  JXHomeTagsModel.h
//  JXEfficient_Example
//
//  Created by augsun on 2/27/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTagsViewTagModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXHomeTagsModel : JXTagsViewTagModel

@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, assign) BOOL tagSelected;

+ (NSArray <JXHomeTagsModel *> *)modelsFromStrings:(NSArray <NSString *> *)strings;

@end

NS_ASSUME_NONNULL_END
