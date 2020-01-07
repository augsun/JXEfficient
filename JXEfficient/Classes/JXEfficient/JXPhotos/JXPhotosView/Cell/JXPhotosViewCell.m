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

@property (nonatomic, assign) PHImageRequestID ID;

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
    [self.contentView addSubview:self.thumbImageView];
    self.thumbImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[self.thumbImageView jx_con_edgeEqual:self.contentView]];
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbImageView.clipsToBounds = YES;
}

- (void)refreshUI:(__kindof JXPhotosAsset *)asset thumbImageSize:(CGSize)thumbImageSize {
    self.asset.sourceImageView = nil;
    _asset = asset;
    self.ID = PHInvalidImageRequestID;

    //
    if (asset.thumbImage) {
        [self refreshUI];
    }
    else {
        self.thumbImageView.image = nil;
        
        self.ID = [[PHImageManager defaultManager] requestImageForAsset:asset.phAsset
                                                   targetSize:thumbImageSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:asset.imageRequestOptions
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             asset.thumbImage = result;
             asset.thumbImageInfo = info;
             
             PHImageRequestID now_ID = [info[PHImageResultRequestIDKey] intValue];
             if (self.ID == now_ID) {
                 [self refreshUI];
             }
         }];
    }
}

- (void)refreshUI {
    self.thumbImageView.image = self.asset.thumbImage;
    self.asset.sourceImageView = self.thumbImageView;
}

@end
