//
//  JXPhotosGeneralLayoutCell.h
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <JXPhotosViewCell.h>

#import <JXPhotosGeneralAsset.h>
#import <JXPhotosGeneralUsage.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPhotosGeneralLayoutCell : JXPhotosViewCell

- (void)refreshUI:(JXPhotosGeneralAsset *)asset thumbImageSize:(CGSize)thumbImageSize usage:(JXPhotosGeneralUsage *)usage;

@property (nonatomic, copy) void (^selClick)(JXPhotosGeneralAsset *asset);

@end

NS_ASSUME_NONNULL_END
