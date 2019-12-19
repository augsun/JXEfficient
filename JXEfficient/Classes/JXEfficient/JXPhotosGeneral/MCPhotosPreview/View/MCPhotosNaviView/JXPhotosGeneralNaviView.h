//
//  JXPhotosGeneralNaviView.h
//  JXEfficient
//
//  Created by augsun on 7/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXNaviView.h"
#import "JXPhotosGeneralUsage.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosGeneralNaviView : JXNaviView

- (instancetype)initWithUsage:(JXPhotosGeneralUsage *)usage;

@property (nonatomic, strong) JXPhotosGeneralAsset *asset;

@end

NS_ASSUME_NONNULL_END
