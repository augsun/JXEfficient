//
//  JXPhotosGeneralUsage.m
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralUsage.h"

@implementation JXPhotosGeneralUsage

- (instancetype)init {
    self = [super init];
    if (self) {
        self.firstPageTo = JXPhotosGeneralFirstPageToCaneralRoll;
        self.selectionType = JXPhotosGeneralLayoutSelectionTypeSingle;
        self.maximumNumberOfChoices = 0;
    }
    return self;
}

@end
