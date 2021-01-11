//
//  JXPhotosGeneralPreviewBottomTagModel.h
//  JXEfficient
//
//  Created by augsun on 7/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JXPhotosGeneralAsset.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosGeneralPreviewBottomTagModel : NSObject

@property (nonatomic, strong) JXPhotosGeneralAsset *asset;

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, assign) BOOL isCurrentShowing; ///< 是否当前选浏览的图片

@end

NS_ASSUME_NONNULL_END
