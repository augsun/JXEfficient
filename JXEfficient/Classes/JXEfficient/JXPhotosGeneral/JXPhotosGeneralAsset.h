//
//  JXPhotosGeneralAsset.h
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <JXPhotosAsset.h>

NS_ASSUME_NONNULL_BEGIN

/**
 代表一张图片实例
 */
@interface JXPhotosGeneralAsset : JXPhotosAsset

@property (nonatomic, assign) BOOL covered; ///< 是否蒙层

@end

NS_ASSUME_NONNULL_END
