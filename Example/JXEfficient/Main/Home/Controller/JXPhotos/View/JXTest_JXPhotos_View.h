//
//  JXTest_JXPhotos_View.h
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTest_JXPhotos_AlbumImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXTest_JXPhotos_View : UIView

@property (nonatomic, copy) NSArray <JXTest_JXPhotos_AlbumImageModel *> *models;

@end

NS_ASSUME_NONNULL_END
