//
//  JXCarouselPageControlView.m
//  JXEfficient
//
//  Created by augsun on 1/31/19.
//

#import "JXCarouselPageControlView.h"
#import "JXCarouselImagePageControlView.h"

#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

static const CGFloat kIndicatorSideMax = 18.0;

typedef NS_ENUM(NSUInteger, JXCarouselPageControlType) {
    JXCarouselPageControlTypeNull,
    JXCarouselPageControlTypeColor,
    JXCarouselPageControlTypeImage,
};

@interface JXCarouselPageControlView ()

@property (nonatomic, assign) JXCarouselPageControlType pageControlType;

@property (nonatomic, strong) UIPageControl *colorPageControl;

@property (nonatomic, strong) JXCarouselImagePageControlView *imagePageControl;
@property (nonatomic, assign) CGSize size_normal;
@property (nonatomic, assign) CGSize size_current;

@property (nonatomic, assign) CGFloat heightNeed;

@end

@implementation JXCarouselPageControlView

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageControlType = JXCarouselPageControlTypeColor;
    }
    return self;
}

- (UIPageControl *)colorPageControl {
    if (!_colorPageControl) {
        _colorPageControl = [[UIPageControl alloc] init];
        [self addSubview:_colorPageControl];
        _colorPageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[_colorPageControl jx_con_edgeEqual:self]];
        if (self.normalIndicatorColor) {
            _colorPageControl.pageIndicatorTintColor = self.normalIndicatorColor;
        }
        if (self.currentIndicatorColor) {
            _colorPageControl.currentPageIndicatorTintColor = self.currentIndicatorColor;
        }
        _colorPageControl.userInteractionEnabled = NO;
        _imagePageControl.hidesForSinglePage = self.hidesForSinglePage;
    }
    return _colorPageControl;
}

- (JXCarouselImagePageControlView *)imagePageControl {
    if (!_imagePageControl) {
        _imagePageControl = [[JXCarouselImagePageControlView alloc] initWithNormalIndicatorImage:self.normalIndicatorImage
                                                                                 normalImageSize:self.size_normal
                                                                           currentIndicatorImage:self.currentIndicatorImage
                                                                                currentImageSize:self.size_current];
        [self addSubview:_imagePageControl];
        _imagePageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[_imagePageControl jx_con_edgeEqual:self]];
        _imagePageControl.userInteractionEnabled = NO;
        _imagePageControl.hidesForSinglePage = self.hidesForSinglePage;
    }
    return _imagePageControl;
}

- (void)setNormalIndicatorColor:(UIColor *)normalIndicatorColor {
    _normalIndicatorColor = normalIndicatorColor;
    if (_colorPageControl) {
        _colorPageControl.pageIndicatorTintColor = normalIndicatorColor;
    }
}

- (void)setCurrentIndicatorColor:(UIColor *)currentIndicatorColor {
    _currentIndicatorColor = currentIndicatorColor;
    if (_colorPageControl) {
        _colorPageControl.currentPageIndicatorTintColor = currentIndicatorColor;
    }
}

- (void)setNormalIndicatorImage:(UIImage *)normalIndicatorImage {
    _normalIndicatorImage = normalIndicatorImage;
    if (self.currentIndicatorImage) {
        [self jx_decideIndicatorImage];
    }
}

- (void)setCurrentIndicatorImage:(UIImage *)currentIndicatorImage {
    _currentIndicatorImage = currentIndicatorImage;
    if (self.normalIndicatorImage) {
        [self jx_decideIndicatorImage];
    }
}

- (void)jx_decideIndicatorImage {
    CGSize size_normal = self.normalIndicatorImage.size;
    CGSize size_current = self.currentIndicatorImage.size;
    
    CGFloat min_side_normal = fmin(size_normal.width, size_normal.height);
    CGFloat min_side_current = fmin(size_current.width, size_current.height);

    if (self.normalIndicatorImage && self.currentIndicatorImage &&
        min_side_normal > 0 && min_side_current > 0) {

        self.size_normal = [self jx_makeSureImageSize:size_normal];
        self.size_current = [self jx_makeSureImageSize:size_current];
        
        self.pageControlType = JXCarouselPageControlTypeImage;
    }
    else {
        self.pageControlType = JXCarouselPageControlTypeColor;
    }
}

- (CGSize)jx_makeSureImageSize:(CGSize)size {
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat rate = width / height;
    if (width > height) {
        if (width > kIndicatorSideMax) {
            width = kIndicatorSideMax;
            height = width / rate;
        }
    }
    else {
        if (height > kIndicatorSideMax) {
            height = kIndicatorSideMax;
            width = height * rate;
        }
    }
    return CGSizeMake(width, height);
}

// 决定 _colorPageControl 和 _imagePageControl 谁显示隐藏
- (void)setPageControlType:(JXCarouselPageControlType)pageControlType {
    _pageControlType = pageControlType;
    
    CGFloat heightNeed = 0.0;
    switch (pageControlType) {
        case JXCarouselPageControlTypeNull: { heightNeed = 0.0; } break;
        case JXCarouselPageControlTypeColor: { heightNeed = 7.0; } break;
        case JXCarouselPageControlTypeImage: { heightNeed = fmax(self.size_normal.height, self.size_current.height); } break;
        default: break;
    }
    self.heightNeed = heightNeed;

    JX_BLOCK_EXEC(self.heightNeedUpdate, self.heightNeed);
    
    [self jx_checkHidesForSinglePage];
}

// 在 hidesForSinglePage == YES 及 pageControlType 类型确定情况下 _colorPageControl 和 _imagePageControl 的显示与隐藏
- (void)jx_checkHidesForSinglePage {
    switch (self.pageControlType) {
        case JXCarouselPageControlTypeNull:
        {
            _colorPageControl.hidden = YES;
            _imagePageControl.hidden = YES;
        } break;

        case JXCarouselPageControlTypeColor:
        {
            if (self.hidesForSinglePage) {
                if (self.numberOfPages <= 1) {
                    _colorPageControl.hidden = YES;
                }
                else {
                    self.colorPageControl.hidden = NO;
                }
            }
            else {
                if (self.numberOfPages == 0) {
                    _colorPageControl.hidden = YES;
                }
                else {
                    self.colorPageControl.hidden = NO;
                }
            }
            
            _imagePageControl.hidesForSinglePage = YES;
        } break;

        case JXCarouselPageControlTypeImage:
        {
            self.imagePageControl.hidesForSinglePage = self.hidesForSinglePage;
        } break;

        default: break;
    }
}

- (void)jx_refreshColorPageControl {
    self.colorPageControl.numberOfPages = self.numberOfPages;
    self.colorPageControl.currentPage = self.currentPage;
}

- (void)jx_refreshImagePageControl {
    self.imagePageControl.numberOfPages = self.numberOfPages;
    self.imagePageControl.currentPage = self.currentPage;
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
    [self jx_checkHidesForSinglePage];
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self jx_checkHidesForSinglePage];
    [self jx_refreshUI];
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    _currentPage = currentPage;
    [self jx_refreshUI];
}

- (void)jx_refreshUI {
    switch (self.pageControlType) {
        case JXCarouselPageControlTypeNull: { } break;
        case JXCarouselPageControlTypeColor: { [self jx_refreshColorPageControl]; } break;
        case JXCarouselPageControlTypeImage: { [self jx_refreshImagePageControl]; } break;
        default: break;
    }
}

@end
