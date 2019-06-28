//
//  JXImageBrowserImageView.m
//  JXEfficient
//
//  Created by CoderSun on 4/21/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXImageBrowserImageView.h"
#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

#import "JXImageBrowserProgressHUDView.h"
#import "JXImageBrowserLoadImageFailureView.h"

static const CGFloat kZoomScaleMax = 4.0;
static const CGFloat kZoomScaleDefault = 1.0;
static const CGFloat kZoomScaleOfTap = 2.5;

const CGFloat JXImageBrowserImageViewAnimationDuration = 0.25;

@interface JXImageBrowserImageView () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) BOOL imageDownloading;
@property (nonatomic, assign) BOOL loadImageFailure;
@property (nonatomic, strong) JXImageBrowserProgressHUDView *progressHUDView;
@property (nonatomic, strong) JXImageBrowserLoadImageFailureView *loadImageFailureView;

@property (nonatomic, assign) CGFloat wSelf;
@property (nonatomic, assign) CGFloat hSelf;

@property (nonatomic, assign) CGRect pan_oriRectOfImgView;
@property (nonatomic, assign) CGPoint pan_locationInSelfWhenBegin;
@property (nonatomic, assign) BOOL pan_negativeVelocity; // 开始就是上滑 负速度情况

@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

@end

@implementation JXImageBrowserImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //
        self.clipsToBounds = YES;
        self.wSelf = self.frame.size.width;
        self.hSelf = self.frame.size.height;
        
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

        // 长按
        UILongPressGestureRecognizer *gesLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jx_gesLongPress:)];
        [self addGestureRecognizer:gesLongPress];
        
        // 拖动
        self.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(jx_gesPan:)];
        [self addGestureRecognizer:self.panGes];
        self.panGes.delegate = self;
        
    }
    return self;
}

- (JXImageBrowserProgressHUDView *)progressHUDView {
    if (!_progressHUDView) {
        CGSize size = [JXImageBrowserProgressHUDView showSize];
        
        _progressHUDView =[[JXImageBrowserProgressHUDView alloc] init];
        [self addSubview:_progressHUDView];
        _progressHUDView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [_progressHUDView jx_con_same:NSLayoutAttributeCenterX equal:self m:1.0 c:0.0],
                                                  [_progressHUDView jx_con_same:NSLayoutAttributeCenterY equal:self m:1.0 c:0.0],
                                                  [_progressHUDView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:size.width],
                                                  [_progressHUDView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:size.height],
                                                  ]];
    }
    return _progressHUDView;
}

- (void)jx_progressHUDViewShow:(BOOL)show progress:(CGFloat)progress {
    if (show) {
        self.progressHUDView.hidden = NO;
        self.progressHUDView.progress = progress;
    }
    else {
        _progressHUDView.hidden = YES;
    }
}

- (JXImageBrowserLoadImageFailureView *)loadImageFailureView {
    if (!_loadImageFailureView) {

        _loadImageFailureView = [[JXImageBrowserLoadImageFailureView alloc] init];
        [self addSubview:_loadImageFailureView];
        _loadImageFailureView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [_loadImageFailureView jx_con_same:NSLayoutAttributeCenterX equal:self m:1.0 c:0.0],
                                                  [_loadImageFailureView jx_con_same:NSLayoutAttributeCenterY equal:self m:1.0 c:0.0],
                                                  [_loadImageFailureView jx_con_same:NSLayoutAttributeTop greaterEqual:self m:1.0 c:0.0],
                                                  [_loadImageFailureView jx_con_same:NSLayoutAttributeLeft greaterEqual:self m:1.0 c:0.0],
                                                  [_loadImageFailureView jx_con_same:NSLayoutAttributeBottom lessEqual:self m:1.0 c:0.0],
                                                  [_loadImageFailureView jx_con_same:NSLayoutAttributeRight lessEqual:self m:1.0 c:0.0],
                                                  ]];
    }
    return _loadImageFailureView;
}

- (void)setLoadImageFailure:(BOOL)loadImageFailure {
    _loadImageFailure = loadImageFailure;
    if (loadImageFailure) {
        self.loadImageFailureView.hidden = NO;
    }
    else {
        _loadImageFailureView.hidden = YES;
    }
}

- (void)setJxImage:(JXImageBrowserImage *)jxImage {
    _jxImage = jxImage;
    
    self.scrollView.zoomScale = kZoomScaleDefault;
    
    // 大图已经下载成功
    if (self.largeImage) {
        [self jx_progressHUDViewShow:NO progress:0.0];
        self.imgView.image = self.largeImage;
        
        [self jx_reFrameImageView];
    }
    // 大图还没下载成功
    else {
        // 大图下载中
        if (self.imageDownloading) {
            return;
        }
        self.imageDownloading = YES;
        self.loadImageFailure = NO;

        self.imgView.image = self.jxImage.imageViewFrom.image;
        [self jx_reFrameImageView];

        // 如果是磁盘缓存 给 0.1 秒时间 再决定是否显示 HUD
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.imageDownloading) {
                [self jx_progressHUDViewShow:YES progress:0.0];
            }
        });
        
        //
        self.loadImage(self.jxImage.imageURL, ^(NSInteger receivedSize, NSInteger expectedSize) {
            CGFloat progress = 1.0 * receivedSize / expectedSize;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self jx_progressHUDViewShow:YES progress:progress];
            });
        }, ^(UIImage * _Nullable image, NSError * _Nullable error) {
            self.imageDownloading = NO;
            [self jx_progressHUDViewShow:NO progress:0.0];
            
            // 设置图片
            if (image) {
                self.largeImage = image;
                
                self.imgView.image = self.largeImage;
                [self jx_reFrameImageView];
            }
            else {
                self.loadImageFailure = YES;
            }
        });
    }
}

- (void)jx_reFrameImageView {
    CGFloat wImage = self.imgView.image.size.width;
    CGFloat hImage = self.imgView.image.size.height;
    
    self.scrollView.zoomScale = 1.0;
    
    if (wImage > 0 && hImage > 0) {
        CGFloat rImage = wImage / hImage;
        CGFloat rSelf = _wSelf / _hSelf;
        
        CGRect imageViewFrame = CGRectZero;
        if (rImage < rSelf) {
            imageViewFrame = CGRectMake(0.0, 0, _wSelf, _wSelf / rImage);
        }
        else {
            imageViewFrame = CGRectMake(0, (_hSelf - _wSelf / rImage) / 2, _wSelf, _wSelf / rImage);
        }
        self.scrollView.contentSize = imageViewFrame.size;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.maximumZoomScale = self.largeImage ? kZoomScaleMax : 1.0;
        
        if (self.firstGrace) {
            self.firstGrace = NO;
            if (self.jxImage.imageViewFrom) {
                self.imgView.frame = [self.jxImage.imageViewFrom convertRect:self.jxImage.imageViewFrom.bounds toView:nil];
                [UIView animateWithDuration:JXImageBrowserImageViewAnimationDuration animations:^{
                    self.imgView.frame = imageViewFrame;
                } completion:^(BOOL finished) {

                }];
            }
            else {
                self.imgView.alpha = 0.0;
                self.imgView.frame = imageViewFrame;
                [UIView animateWithDuration:JXImageBrowserImageViewAnimationDuration animations:^{
                    self.imgView.alpha = 1.0;
                } completion:^(BOOL finished) {

                }];
            }
        }
        else {
            self.imgView.frame = imageViewFrame;
        }
    }
    else {
        if (self.jxImage.imageViewFrom && self.firstGrace) {
            self.firstGrace = NO;
        }
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

// NO 时: gestureRecognizer 不要求 otherGestureRecognizer 失败 <此方法暂时用不到>
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return NO;
//}

// NO 时: otherGestureRecognizer 不要求 gestureRecognizer 失败
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
        JX_BLOCK_EXEC(self.didDrag, percent, NO);
        
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
        // 快速下滑速度大于该值 隐藏
        if (velocity.y > 500.0) {
            [self jx_gesSingleTap:nil];
        }
        else {
            [UIView animateWithDuration:JXImageBrowserImageViewAnimationDuration animations:^{
                self.imgView.frame = self.pan_oriRectOfImgView;
            }];
            
            self.pan_negativeVelocity = NO;
            JX_BLOCK_EXEC(self.didDrag, 0.0, YES);
        }
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
    if (self.imgView.image.size.width / self.imgView.image.size.height < _wSelf / _hSelf) {
        imageViewFrame.origin.x = imageViewFrame.size.width > _wSelf ? 0.0 : (_wSelf - imageViewFrame.size.width) / 2.0;
    }
    else {
        imageViewFrame.origin.y = imageViewFrame.size.height > _hSelf ? 0.0 : (_hSelf - imageViewFrame.size.height) / 2.0;
    }
    self.imgView.frame = imageViewFrame;
}

- (void)hide {
    [self jx_gesSingleTap:nil];
}

- (void)jx_gesSingleTap:(UITapGestureRecognizer *)tap {
    
    JX_BLOCK_EXEC(self.singleTapAction, self);
    
    if (self.jxImage.imageViewFrom) {
        UIImage *imgTemp = self.jxImage.imageViewFrom.image;
        if (self.largeImage) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.imgView.image = imgTemp;
            });
        }
        
        [UIView animateWithDuration:JXImageBrowserImageViewAnimationDuration animations:^{
            self.imgView.frame = [self.jxImage.imageViewFrom.superview convertRect:self.jxImage.imageViewFrom.frame toView:self.scrollView];
            self->_loadImageFailureView.alpha = 0.0;
            self->_progressHUDView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (!self.jxImage.imageViewFrom.image) {
                self.jxImage.imageViewFrom.image = imgTemp;
            }
            JX_BLOCK_EXEC(self.didZoomOutAction, self);
        }];
    }
    else {
        [UIView animateWithDuration:JXImageBrowserImageViewAnimationDuration animations:^{
            self.imgView.alpha = 0.0;
            self->_loadImageFailureView.alpha = 0.0;
            self->_progressHUDView.alpha = 0.0;
        } completion:^(BOOL finished) {
            JX_BLOCK_EXEC(self.didZoomOutAction, self);
        }];
    }
}

- (void)jx_gesDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.imageDownloading) {
        return;
    }

    if (self.largeImage) {
        CGPoint touchPoint = [tap locationInView:self.imgView];
        if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        } else {
            CGFloat w = self.wSelf / kZoomScaleOfTap;
            CGFloat h = self.hSelf / kZoomScaleOfTap;
            CGFloat x = touchPoint.x - w / 2.0;
            CGFloat y = touchPoint.y - h / 2.0;
            [self.scrollView setZoomScale:1.0];
            [self.scrollView zoomToRect:CGRectMake(x, y, w, h) animated:YES];
        }
    }
}

- (void)jx_gesLongPress:(UILongPressGestureRecognizer *)logGesture {
    if (self.imageDownloading) {
        return;
    }
    if (self.largeImage && logGesture.state == UIGestureRecognizerStateBegan) {
        JX_BLOCK_EXEC(self.longPressAction, self);
    }
}

@end










