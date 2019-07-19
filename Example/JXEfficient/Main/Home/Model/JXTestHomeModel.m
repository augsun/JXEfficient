
//
//  JXTestHomeModel.m
//  JXEfficient
//
//  Created by augsun on 7/3/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTestHomeModel.h"

@implementation JXTestHomeModel

- (void)setVcClass:(Class)vcClass {
    _vcClass = vcClass;
    NSString *fullClassString = NSStringFromClass(vcClass);
    NSString *string = fullClassString;
    string = [string stringByReplacingOccurrencesOfString:@"JXTest_" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"_VC" withString:@""];
    self.title = string;
}

+ (instancetype)modelFromVcClass:(Class)vcClass {
    JXTestHomeModel *model = [[JXTestHomeModel alloc] init];
    model.vcClass = vcClass;
    return model;
}

@end
