//
//  JXPhotosGeneralViewAlbumCell.m
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralAlbumViewCell.h"

#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

const CGSize JXPhotosGeneralViewAlbumCellThumbImageViewSize = {60.0, 60.0};

static UIImage *k_arrow_image_ = nil;

@interface JXPhotosGeneralAlbumViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *thumbImgView;
@property (nonatomic, strong) UILabel *albumTitleLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *rightArrowImgView;

@property (nonatomic, assign) CGSize thumbImgViewShowingSize;

@property (nonatomic, assign) PHImageRequestID ID;

@end

@implementation JXPhotosGeneralAlbumViewCell

- (UIImage *)arrowImage {
    if (!k_arrow_image_) {
        k_arrow_image_ = [JXPhotosGeneralAlbumViewCell jx_drawRightAngleArrow:JX_COLOR_HEX(0x999999)];
    }
    return k_arrow_image_;
}

+ (UIImage *)jx_drawRightAngleArrow:(UIColor *)color {
    CGFloat path_w = 1.; // 线宽
    CGFloat path_r = path_w / 2.0; // 线 半径(半宽)
    
    CGFloat w = 8.5; // 布局边缘实际宽度
    CGFloat edge = 0.0; // 4边的边缘向外扩展宽度
    CGPoint a1 = CGPointMake(w - path_r, path_r); // 右上角 起点
    CGFloat a2_y = w - sqrt(2.0) * path_r;
    CGPoint a2 = CGPointMake(sqrt(2.0) * path_r, a2_y); // 左边拐点
    CGPoint a3 = CGPointMake(w - path_r, 2 * a2_y); // 右下角 终点
    
    CGPoint (^add_offset)(CGPoint) = ^ CGPoint (CGPoint point) { // 进行边缘扩展
        return CGPointMake(point.x + edge, point.y + edge);
    };
    a1 = add_offset(a1);
    a2 = add_offset(a2);
    a3 = add_offset(a3);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:a1];
    [path addLineToPoint:a2];
    [path addLineToPoint:a3];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = path_w;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    CGRect rect = CGRectMake(0, 0, w + 2 * edge, 2 * a2_y + 2 * edge); // 边缘扩展后的图片大小
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view.layer addSublayer:shapeLayer];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumbImgViewShowingSize = CGSizeMake(
                                                  JXPhotosGeneralViewAlbumCellThumbImageViewSize.width * JX_SCREEN_SCALE,
                                                  JXPhotosGeneralViewAlbumCellThumbImageViewSize.height * JX_SCREEN_SCALE
                                                  );

        //
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.bgView jx_con_edgeEqual:self.contentView]];
        
        //
        self.thumbImgView = [[UIImageView alloc] init];
        [self.bgView addSubview:self.thumbImgView];
        self.thumbImgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.thumbImgView jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:0.0],
                                                  [self.thumbImgView jx_con_same:NSLayoutAttributeLeft equal:self.bgView m:1.0 c:0.0],
                                                  [self.thumbImgView jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:0.0],
                                                  [self.thumbImgView jx_con_diff:NSLayoutAttributeWidth equal:self.thumbImgView att2:NSLayoutAttributeHeight m:1.0 c:0.0],
                                                  ]];
        self.thumbImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbImgView.clipsToBounds = YES;
        
        //
        self.albumTitleLabel = [[UILabel alloc] init];
        [self.bgView addSubview:self.albumTitleLabel];
        self.albumTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.albumTitleLabel jx_con_diff:NSLayoutAttributeLeft equal:self.thumbImgView att2:NSLayoutAttributeRight m:1.0 c:8.0],
                                                  [self.albumTitleLabel jx_con_same:NSLayoutAttributeCenterY equal:self.thumbImgView m:1.0 c:0.0],
                                                  ]];
        self.albumTitleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        self.albumTitleLabel.textColor = JX_COLOR_HEX(0x333333);
        
        //
        self.rightArrowImgView = [[UIImageView alloc] init];
        [self.bgView addSubview:self.rightArrowImgView];
        self.rightArrowImgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.rightArrowImgView jx_con_same:NSLayoutAttributeRight equal:self.bgView m:1.0 c:-15.0],
                                                  [self.rightArrowImgView jx_con_same:NSLayoutAttributeCenterY equal:self.bgView m:1.0 c:-15.0],
                                                  [self.rightArrowImgView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:8.0],
                                                  [self.rightArrowImgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:15.5],
                                                  ]];
        self.rightArrowImgView.image = [self arrowImage];
        self.rightArrowImgView.transform = CGAffineTransformRotate(self.rightArrowImgView.transform, M_PI);

        //
        self.numberLabel = [[UILabel alloc] init];
        [self.bgView addSubview:self.numberLabel];
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.numberLabel jx_con_diff:NSLayoutAttributeLeft equal:self.albumTitleLabel att2:NSLayoutAttributeRight m:1.0 c:8.0],
                                                  [self.numberLabel jx_con_same:NSLayoutAttributeCenterY equal:self.albumTitleLabel m:1.0 c:0.0],
                                                  [self.numberLabel jx_con_diff:NSLayoutAttributeRight lessEqual:self.rightArrowImgView att2:NSLayoutAttributeLeft m:1.0 c:8.0],
                                                  ]];
        self.numberLabel.textColor = JX_COLOR_HEX(0x999999);
        
    }
    return self;
}

- (void)setAssetCollection:(JXPhotosGeneralAlbumAssetCollection *)assetCollection {
    _assetCollection = assetCollection;
    
    // thumbImage
    if (assetCollection.thumbImage) {
        self.thumbImgView.image = assetCollection.thumbImage;
    }
    else {
        self.thumbImgView.image = nil;
        
        self.ID = [[PHImageManager defaultManager] requestImageForAsset:assetCollection.thumbImageAsset.phAsset
                                                   targetSize:self.thumbImgViewShowingSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:assetCollection.thumbImageRequestOptions
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             assetCollection.thumbImage = result;
             assetCollection.thumbImageInfo = info;

             PHImageRequestID now_ID = [info[PHImageResultRequestIDKey] intValue];
             if (self.ID == now_ID) {
                 self.thumbImgView.image = assetCollection.thumbImage;
             }
         }];
    }
    
    //
    self.albumTitleLabel.text = assetCollection.phAssetCollection.localizedTitle;
    
    //
    self.numberLabel.text = [NSString stringWithFormat:@"（%ld）", assetCollection.assets.count];
}

- (void)dealloc {
    k_arrow_image_ = nil;
}

@end
