//
//  JXPhotosViewCell.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosViewCell.h"

#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

@interface JXPhotosViewCell ()

@end

@implementation JXPhotosViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self JXPhotosViewCell_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self JXPhotosViewCell_moreInit];
    }
    return self;
}

- (void)JXPhotosViewCell_moreInit {
    self.backgroundColor = JX_COLOR_SYS_IMG_BG;
    
    _thumbImageView = [[UIImageView alloc] init];
    [self addSubview:self.thumbImageView];
    self.thumbImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[self.thumbImageView jx_con_edgeEqual:self]];
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbImageView.clipsToBounds = YES;
    
}

- (void)refreshUI:(__kindof JXPhotosAsset *)asset thumbImageSize:(CGSize)thumbImageSize {
    _asset = asset;
    
    if (asset.thumbImage) {
        self.thumbImageView.image = self.asset.thumbImage;
    }
    else {
        self.thumbImageView.image = nil;
        BOOL is_async = NO; // 下面 requestImageForAsset 方法由于可能存在同步回调, 防止二次异步回调时无法刷新二次回调的 result 图片.
        [[PHImageManager defaultManager] requestImageForAsset:asset.phAsset
                                                   targetSize:thumbImageSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:asset.imageRequestOptions
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             asset.thumbImage = result;
             asset.thumbImageInfo = info;
             
             if (self.asset == asset || !is_async) {
                 self.thumbImageView.image = result;
             }
         }];
        is_async = YES;
    }
}

@end
