//
//  JXHomeTagsModel.m
//  JXEfficient_Example
//
//  Created by augsun on 2/27/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXHomeTagsModel.h"

@implementation JXHomeTagsModel

+ (NSArray<JXHomeTagsModel *> *)modelsFromStrings:(NSArray<NSString *> *)strings {
    NSMutableArray <JXHomeTagsModel *> *tempArr = [[NSMutableArray alloc] init];
    for (NSString *strEnum in strings) {
        JXHomeTagsModel *model = [[JXHomeTagsModel alloc] init];
        model.tagName = strEnum;
        [tempArr addObject:model];
    }
    
    return tempArr;
}

@end
