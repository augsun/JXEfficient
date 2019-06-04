//
//  JXCarouselImageView.m
//  JXEfficient
//
//  Created by augsun on 1/31/19.
//

#import "JXCarouselImageView.h"
#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

@interface JXCarouselImageView ()

@end

@implementation JXCarouselImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.imageView jx_con_edgeEqual:self]];
        self.imageView.clipsToBounds = YES;
    }
    return self;
}

- (void)setModel:(JXCarouselModel *)model {
    _model = model;
    
    // 清空数据
    if (model == nil) {
        self.imageView.image = nil;
        return;
    }
    
    // 下载成功
    if (model.largeImage) {
        self.imageView.image = model.largeImage;
    }
    // 下载中
    else if (model.imageDownloading) {
        self.imageView.image = nil;
        return;
    }
    // 下载失败或未开始下载
    else {
        self.imageView.image = nil;
        model.imageDownloading = YES;
        self.loadImage(model.URL, ^(UIImage * _Nullable image, NSError * _Nullable error) {
            model.imageDownloading = NO;
            if (image) {
                model.largeImage = image;
                self.imageView.image = model.largeImage;
            }
            else {
                model.loadImageFailure = YES;
            }
        });
    }
}

@end
