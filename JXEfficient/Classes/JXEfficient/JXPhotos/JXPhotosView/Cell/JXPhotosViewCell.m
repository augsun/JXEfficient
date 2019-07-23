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

@property (nonatomic, copy) void (^thumbImageSettedTrigger)(void);

@property (nonatomic, copy) NSString *hashKey;

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
    self.hashKey = [NSString stringWithFormat:@"%ld", self.hash];
    self.backgroundColor = JX_COLOR_SYS_IMG_BG;
    
    _thumbImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.thumbImageView];
    self.thumbImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[self.thumbImageView jx_con_edgeEqual:self.contentView]];
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbImageView.clipsToBounds = YES;
    
    //
    JX_WEAK_SELF;
    self.thumbImageSettedTrigger = ^ {
        JX_STRONG_SELF;
        self.thumbImageView.image = self.asset.thumbImage;
    };
    
}

- (void)refreshUI:(__kindof JXPhotosAsset *)asset thumbImageSize:(CGSize)thumbImageSize {
    _asset = asset;
    
    [self.asset addThumbImageSettedTrigger:self.thumbImageSettedTrigger cellHashKey:self.hashKey];
    
    if (asset.thumbImage) {
        self.thumbImageView.image = asset.thumbImage;
    }
    else {
        self.thumbImageView.image = nil;
        [[PHImageManager defaultManager] requestImageForAsset:asset.phAsset
                                                   targetSize:thumbImageSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:asset.imageRequestOptions
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             asset.thumbImage = result;
             asset.thumbImageInfo = info;
         }];
    }
}

@end
