//
//  JXPhotosGeneralPreviewBottomTagCell.m
//  JXEfficient
//
//  Created by augsun on 7/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralPreviewBottomTagCell.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

@interface JXPhotosGeneralPreviewBottomTagCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) PHImageRequestID ID;

@end

@implementation JXPhotosGeneralPreviewBottomTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // bgView
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.bgView jx_con_edgeEqual:self.contentView]];
        self.bgView.clipsToBounds = YES;
        self.bgView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgView.layer.borderWidth = 0.0;
        self.bgView.layer.borderColor = JX_COLOR_RGB( 254, 105, 75).CGColor;
        
        // thumbImageView
        self.thumbImageView = [[UIImageView alloc] init];
        [self.bgView addSubview:self.thumbImageView];
        self.thumbImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.thumbImageView jx_con_edgeEqual:self.bgView]];
        self.thumbImageView.clipsToBounds = YES;
        self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        // coverView
        self.coverView = [[UIView alloc] init];
        [self.bgView addSubview:self.coverView];
        self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.coverView jx_con_edgeEqual:self.bgView]];
        self.coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)setModel:(JXPhotosGeneralPreviewBottomTagModel *)model {
    _model = model;
    self.ID = PHInvalidImageRequestID;
    
    // 是否当前显示
    if (model.isCurrentShowing) {
        self.bgView.layer.borderWidth = 2.0;
    }
    else {
        self.bgView.layer.borderWidth = 0.0;
    }
    
    // 是否用户选择的
    if (model.asset.selected) {
        self.coverView.hidden = YES;
    }
    else {
        self.coverView.hidden = NO;
    }
    
    //
    if (model.thumbImage) {
        self.thumbImageView.image = self.model.thumbImage;
    }
    else {
        self.thumbImageView.image = nil;
        self.ID = [[PHImageManager defaultManager] requestImageForAsset:model.asset.phAsset
                                                             targetSize:CGSizeMake(60.0 * JX_SCREEN_SCALE, 60.0 * JX_SCREEN_SCALE)
                                                            contentMode:PHImageContentModeAspectFill
                                                                options:model.asset.imageRequestOptions
                                                          resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
        {
            model.thumbImage = result;
            
            PHImageRequestID now_ID = [info[PHImageResultRequestIDKey] intValue];
            if (self.ID == now_ID) {
                self.thumbImageView.image = self.model.thumbImage;
            }
        }];
    }
}

@end
