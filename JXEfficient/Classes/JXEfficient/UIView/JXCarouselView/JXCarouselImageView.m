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

- (void)setJXCarouselImageView_model:(JXCarouselModel *)JXCarouselImageView_model {
    _JXCarouselImageView_model = JXCarouselImageView_model;
    
    // 清空数据
    if (JXCarouselImageView_model == nil) {
        self.imageView.image = nil;
        return;
    }
    
    // 下载成功
    if (JXCarouselImageView_model.largeImage) {
        self.imageView.image = JXCarouselImageView_model.largeImage;
    }
    // 下载中
    else if (JXCarouselImageView_model.imageDownloading) {
        self.imageView.image = nil;
        return;
    }
    // 下载失败或未开始下载
    else {
        self.imageView.image = nil;
        JXCarouselImageView_model.imageDownloading = YES;
        if (self.JXCarouselImageView_loadImage) {
            self.JXCarouselImageView_loadImage(JXCarouselImageView_model.URL, ^(UIImage * _Nullable image, NSError * _Nullable error) {
                JXCarouselImageView_model.imageDownloading = NO;
                if (image) {
                    JXCarouselImageView_model.largeImage = image;
                    self.imageView.image = JXCarouselImageView_model.largeImage;
                }
                else {
                    JXCarouselImageView_model.loadImageFailure = YES;
                }
            });
        }
    }
}

@end
