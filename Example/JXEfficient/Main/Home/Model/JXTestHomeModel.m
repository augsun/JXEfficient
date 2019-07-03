
//
//  JXTestHomeModel.m
//  JXEfficient_Example
//
//  Created by augsun on 7/3/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTestHomeModel.h"

@implementation JXTestHomeModel

- (void)setVcClass:(Class)vcClass {
    _vcClass = vcClass;
    self.title = NSStringFromClass(vcClass);
}

+ (instancetype)modelFromVcClass:(Class)vcClass {
    JXTestHomeModel *model = [[JXTestHomeModel alloc] init];
    model.vcClass = vcClass;
    return model;
}

@end
