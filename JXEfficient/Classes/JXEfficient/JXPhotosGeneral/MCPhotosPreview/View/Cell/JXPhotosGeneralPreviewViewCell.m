//
//  JXPhotosGeneralPreviewViewCell.m
//  JXEfficient
//
//  Created by augsun on 7/20/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralPreviewViewCell.h"

#import "UIView+JXCategory.h"
#import "JXMacro.h"

static const CGFloat kZoomScaleMax = 4.0;
static const CGFloat kZoomScaleDefault = 1.0;
static const CGFloat kZoomScaleOfTap = 2.5;

const CGFloat JXPhotosGeneralPreviewImageViewAnimationDuration = 0.25;

@interface JXPhotosGeneralPreviewViewCell () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) BOOL imageDownloading;

@property (nonatomic, assign) CGRect pan_oriRectOfImgView;
@property (nonatomic, assign) CGPoint pan_locationInSelfWhenBegin;
@property (nonatomic, assign) BOOL pan_negativeVelocity; // 开始就是上滑 负速度情况

@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

@end

@implementation JXPhotosGeneralPreviewViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        //
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:self.scrollView];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.maximumZoomScale = 3.0;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.delegate = self;
        
        //
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.scrollView addSubview:self.imgView];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.userInteractionEnabled = YES;
        self.imgView.clipsToBounds = YES;
        
        // 单击
        UITapGestureRecognizer *gesSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jx_gesSingleTap:)];
        [self addGestureRecognizer:gesSingleTap];
        
        // 双击
        UITapGestureRecognizer *gesDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jx_gesDoubleTap:)];
        [self addGestureRecognizer:gesDoubleTap];
        gesDoubleTap.numberOfTapsRequired = 2;
        
        [gesSingleTap requireGestureRecognizerToFail:gesDoubleTap];
        
        // 拖动
        self.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(jx_gesPan:)];
        [self addGestureRecognizer:self.panGes];
        self.panGes.delegate = self;
        
    }
    return self;
}

- (void)setAsset:(JXPhotosGeneralAsset *)asset {
    _asset = asset;
    
    self.scrollView.zoomScale = kZoomScaleDefault;
    
    if (asset.largeImage) {
        self.imgView.image = asset.largeImage;
        [self jx_reFrameImageView];
    }
    else {
        self.imgView.image = nil;
        BOOL is_async = NO; // 下面 requestImageForAsset 方法由于可能存在同步回调, 防止二次异步回调时无法刷新二次回调的 result 图片.
        [[PHImageManager defaultManager] requestImageForAsset:asset.phAsset
                                                   targetSize:CGSizeMake(asset.phAsset.pixelWidth, asset.phAsset.pixelHeight)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:asset.imageRequestOptions
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             asset.largeImage = result;
             asset.largeImageInfo = info;
             
             if (self.asset == asset || !is_async) {
                 self.imgView.image = result;
                 [self jx_reFrameImageView];
             }
         }];
        is_async = YES;
    }
}

- (void)jx_reFrameImageView {
    CGFloat wImage = self.imgView.image.size.width;
    CGFloat hImage = self.imgView.image.size.height;
    
    self.scrollView.zoomScale = 1.0;
    
    if (wImage > 0 && hImage > 0) {
        CGFloat rImage = wImage / hImage;
        CGFloat rSelf = self.jx_width / self.jx_height;
        
        CGRect imageViewFrame = CGRectZero;
        if (rImage < rSelf) {
            imageViewFrame = CGRectMake(0.0, 0, self.jx_width, self.jx_width / rImage);
        }
        else {
            imageViewFrame = CGRectMake(0, (self.jx_height - self.jx_width / rImage) / 2, self.jx_width, self.jx_width / rImage);
        }
        self.scrollView.contentSize = imageViewFrame.size;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.maximumZoomScale = self.asset.largeImage ? kZoomScaleMax : 1.0;
        
        self.imgView.frame = imageViewFrame;
    }
    else {
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 只捕获 pan 手势情况
    if (gestureRecognizer == self.panGes) {
        CGPoint velocity = [self.panGes velocityInView:self.panGes.view];
        // 垂直速率 > 水平速率 的情况
        if (velocity.y > 0) {
            CGFloat x_and_more = 3 * fabs(velocity.x); // 手指滑向与水平线的向下角度大于 arctan(3) ≈ 72° <主要目的防止和左右切换图片的滑动混淆>
            if (velocity.y > x_and_more && self.scrollView.contentOffset.y <= 0) {
                return YES;
            }
            else {
                return NO;
            }
        }
        else {
            return NO;
        }
    }
    else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGes) {
        // 以下手势优先
        BOOL otherIsLongPress = [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]];
        BOOL otherIsScrollViewPinch = [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]];
        if (otherIsLongPress || otherIsScrollViewPinch) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return NO;
    }
}

- (void)jx_gesPan:(UIPanGestureRecognizer *)pan {
    self.backgroundColor = [UIColor clearColor];
    UIGestureRecognizerState state = pan.state;
    
    // 相对起始偏移
    CGPoint point = [pan translationInView:self];
    CGFloat pointX = point.x;
    CGFloat pointY = point.y;
    
    // 速率
    CGPoint velocity = [pan velocityInView:self];
    
    // 开始
    if (state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [pan velocityInView:self];
        if (velocity.y <= 0) {
            self.pan_negativeVelocity = YES;
        }
        
        self.pan_oriRectOfImgView = self.imgView.frame;
        self.pan_locationInSelfWhenBegin = [pan locationInView:pan.view];
        
        JX_BLOCK_EXEC(self.dragBegan);
    }
    // 进行中
    else if (state == UIGestureRecognizerStateChanged) {
        if (self.pan_negativeVelocity) {
            return;
        }
        
        CGFloat sMax = 1.0;
        CGFloat sMin = 0.3;
        
        CGFloat sCount = 0.0; // 缩放
        if (pointY <= 0.0) {
            sCount = sMax;
        }
        else {
            // 保留底部 0.1(百分比 10%) 最小不变
            CGFloat sReal = sMax - pointY / (JX_SCREEN_H - JX_SCREEN_H * (0.1));
            if (sReal > sMin) {
                sCount = sReal;
            }
            else if (sReal > sMax) {
                sCount = sMax;
            }
            else {
                sCount = sMin;
            }
        }
        
        // 偏移百分比
        CGFloat percent = (1.0 - sCount) / (sMax - sMin);
        JX_BLOCK_EXEC(self.dragChanged, percent, NO);
        
        //
        CGFloat x = 0.0, y = 0.0, w = 0.0, h = 0.0;
        if (self.scrollView.zoomScale == 1.0) {
            x = self.pan_oriRectOfImgView.origin.x + pointX + self.pan_locationInSelfWhenBegin.x * (1.0 - sCount);
            y = self.pan_oriRectOfImgView.origin.y + pointY + (self.pan_locationInSelfWhenBegin.y - self.pan_oriRectOfImgView.origin.y) * (1.0 - sCount);
            w = self.pan_oriRectOfImgView.size.width * sCount;
            h = self.pan_oriRectOfImgView.size.height * sCount;
        }
        else {
            x = self.pan_oriRectOfImgView.origin.x + pointX;
            y = self.pan_oriRectOfImgView.origin.y + pointY;
            w = self.pan_oriRectOfImgView.size.width;
            h = self.pan_oriRectOfImgView.size.height;
        }
        CGRect rectNew = CGRectMake(x, y, w, h);
        self.imgView.frame = rectNew;
        
    }
    // 结束
    else if (state == UIGestureRecognizerStateEnded) {
        BOOL forHidden = NO;
        // 快速下滑速度大于该值 隐藏
        if (velocity.y > 500.0) {
            forHidden = YES;
            [self hideFromDrag:YES];
        }
        else {
            [UIView animateWithDuration:JXPhotosGeneralPreviewImageViewAnimationDuration animations:^{
                self.imgView.frame = self.pan_oriRectOfImgView;
            }];
            
            self.pan_negativeVelocity = NO;
            JX_BLOCK_EXEC(self.dragChanged, 0.0, YES);
        }
        JX_BLOCK_EXEC(self.dragEnded, forHidden);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.imageDownloading) {
        return nil;
    }
    else {
        return self.imgView;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect imageViewFrame = self.imgView.frame;
    if (self.imgView.image.size.width / self.imgView.image.size.height < self.jx_width / self.jx_height) {
        imageViewFrame.origin.x = imageViewFrame.size.width > self.jx_width ? 0.0 : (self.jx_width - imageViewFrame.size.width) / 2.0;
    }
    else {
        imageViewFrame.origin.y = imageViewFrame.size.height > self.jx_height ? 0.0 : (self.jx_height - imageViewFrame.size.height) / 2.0;
    }
    self.imgView.frame = imageViewFrame;
}

- (void)jx_gesSingleTap:(UITapGestureRecognizer *)tap {
    JX_BLOCK_EXEC(self.singleTapAction);
}

- (void)hideFromDrag:(BOOL)fromDrag {
    //    if (self.jxImage.imageViewFrom) {
    if (self.asset.sourceImageView) {
        UIImage *imgTemp = self.asset.sourceImageView.image;
        if (self.asset.largeImage) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.imgView.image = imgTemp;
            });
        }
        
        [UIView animateWithDuration:JXPhotosGeneralPreviewImageViewAnimationDuration animations:^{
            self.imgView.frame = [self.asset.sourceImageView.superview convertRect:self.asset.sourceImageView.frame toView:self.scrollView];
        } completion:^(BOOL finished) {
            if (!self.asset.sourceImageView.image) {
                self.asset.sourceImageView.image = imgTemp;
            }
            JX_BLOCK_EXEC(self.didZoomOutAction);
        }];
    }
    else {
        [UIView animateWithDuration:JXPhotosGeneralPreviewImageViewAnimationDuration animations:^{
            self.imgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            JX_BLOCK_EXEC(self.didZoomOutAction);
        }];
    }
}

- (void)jx_gesDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.imageDownloading) {
        return;
    }
    
    if (self.asset.largeImage) {
        CGPoint touchPoint = [tap locationInView:self.imgView];
        if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        } else {
            CGFloat w = self.jx_width / kZoomScaleOfTap;
            CGFloat h = self.jx_height / kZoomScaleOfTap;
            CGFloat x = touchPoint.x - w / 2.0;
            CGFloat y = touchPoint.y - h / 2.0;
            [self.scrollView setZoomScale:1.0];
            [self.scrollView zoomToRect:CGRectMake(x, y, w, h) animated:YES];
        }
    }
}

@end
