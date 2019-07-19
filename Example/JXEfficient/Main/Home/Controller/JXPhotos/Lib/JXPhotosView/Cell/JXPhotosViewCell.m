//
//  JXPhotosViewCell.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosViewCell.h"
#import <JXEfficient/JXEfficient.h>

@interface JXPhotosViewCell ()

@property (nonatomic, strong) JXAsset *asset;
@property (nonatomic, assign) CGSize previous_bestSizeOfThumbImageForCurrentLayout;

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

- (void)refreshUI:(__kindof JXAsset *)asset {
    _asset = asset;
    
    if (asset.image)
    {
        self.thumbImageView.image = self.asset.image;
    }
    else {
        self.thumbImageView.image = nil;
        [[PHImageManager defaultManager] requestImageForAsset:asset.phAsset
                                                   targetSize:asset.thumbImageViewSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:asset.imageRequestOptions
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             asset.image = result;
             asset.info = info;
             if (self.asset == asset) {
                 self.thumbImageView.image = self.asset.image;
             }
         }];
    }
}

@end
