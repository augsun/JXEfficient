//
//  JXCarouselImagePageControlView.m
//  JXEfficient
//
//  Created by augsun on 2/1/19.
//

#import "JXCarouselImagePageControlView.h"
#import "NSLayoutConstraint+JXCategory.h"

static const CGFloat kIndicatorInteritemSpacing = 8.f;

@interface JXCarouselImagePageControlView ()

@property (nonatomic, strong) UIView *bgView; ///< 添加 UIImageView 的背景视图
@property (nonatomic, strong) NSLayoutConstraint *con_bgView_w; ///< 保存 bgView 宽度约束

@property (nonatomic, strong) NSMutableArray <UIImageView *> *imgViews;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *cons_imgViews; ///< 保存 imgViews 里所有 UIImageView 的约束

@property (nonatomic, strong) UIImage *normalIndicatorImage;
@property (nonatomic, strong) UIImage *currentIndicatorImage;

@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *cons_of_imgView_w;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *cons_of_imgView_h;

@property (nonatomic, assign) CGSize normalIndicatorImage_show_size;
@property (nonatomic, assign) CGSize currentImageSize_show_size;

@end

@implementation JXCarouselImagePageControlView

- (instancetype)initWithNormalIndicatorImage:(UIImage *)normalIndicatorImage
                             normalImageSize:(CGSize)normalImageSize
                       currentIndicatorImage:(UIImage *)currentIndicatorImage
                            currentImageSize:(CGSize)currentImageSize
{
    if (self = [super init]) {
        
        self.userInteractionEnabled = NO;
        self.imgViews = [[NSMutableArray alloc] init];
        self.cons_imgViews = [[NSMutableArray alloc] init];
        self.cons_of_imgView_w = [[NSMutableArray alloc] init];
        self.cons_of_imgView_h = [[NSMutableArray alloc] init];
        self.normalIndicatorImage = normalIndicatorImage;
        self.currentIndicatorImage = currentIndicatorImage;
        self.normalIndicatorImage_show_size = normalImageSize;
        self.currentImageSize_show_size = currentImageSize;
        
        // bgView
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        
        CGFloat bgView_h = fmax(self.normalIndicatorImage_show_size.height, self.currentImageSize_show_size.height);
        CGFloat bgView_w_preinstall = 10.0;
        
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.con_bgView_w = [self.bgView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:bgView_w_preinstall];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.bgView jx_con_same:NSLayoutAttributeCenterY equal:self m:1.0 c:0.0],
                                                  [self.bgView jx_con_same:NSLayoutAttributeCenterX equal:self m:1.0 c:0.0],
                                                  self.con_bgView_w,
                                                  [self.bgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:bgView_h],
                                                  ]
         ];
    }
    return self;
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    
    NSInteger count_pre = self.imgViews.count;
    NSInteger count_now = numberOfPages;
    
    if (count_pre != count_now) {
        //
        if (self.cons_imgViews.count > 0) {
            [NSLayoutConstraint deactivateConstraints:self.cons_imgViews];
            [self.cons_imgViews removeAllObjects];
        }
        
        //
        for (UIImageView *viewEnum in self.imgViews) {
            [viewEnum removeFromSuperview];
        }
        
        //
        CGFloat normal_w = self.normalIndicatorImage_show_size.width;
        CGFloat current_w = self.currentImageSize_show_size.width;
        CGFloat gap = kIndicatorInteritemSpacing;
        CGFloat bgView_w_total_w = (count_now * (normal_w + gap) - gap) - normal_w + current_w;
        
        [NSLayoutConstraint deactivateConstraints:@[self.con_bgView_w]];
        self.con_bgView_w = [self.bgView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:bgView_w_total_w];
        [NSLayoutConstraint activateConstraints:@[self.con_bgView_w]];
        
        if (count_pre < count_now) {
            for (NSInteger i = 0; i < count_now - count_pre; i ++) {
                UIImageView *imgView = [[UIImageView alloc] init];
                [self.imgViews addObject:imgView];
            }
        }
        else {
            for (NSInteger i = 0; i < count_pre - count_now; i ++) {
                [self.imgViews removeLastObject];
            }
        }
        
        // 重新约束
        [self.cons_of_imgView_w removeAllObjects];
        for (NSInteger i = 0; i < count_now; i ++) {
            UIImageView *imgView = self.imgViews[i];
            [self.bgView addSubview:imgView];
            
            UIView *leftView = nil;
            NSLayoutAttribute layoutAttribute = NSLayoutAttributeNotAnAttribute;
            CGFloat constant_toL = 0.0;
            if (i == 0) {
                leftView = self.bgView;
                layoutAttribute = NSLayoutAttributeLeft;
                constant_toL = 0.0;
            }
            else {
                leftView = self.imgViews[i - 1];
                layoutAttribute = NSLayoutAttributeRight;
                constant_toL = kIndicatorInteritemSpacing;
            }
            
            CGFloat height = 0.0;
            CGFloat width = 0.0;
            UIImage *image = nil;
            if (i == self.currentPage) {
                height = self.currentImageSize_show_size.height;
                width = self.currentImageSize_show_size.width;
                image = self.currentIndicatorImage;
            }
            else {
                height = self.normalIndicatorImage_show_size.height;
                width = self.normalIndicatorImage_show_size.width;
                image = self.normalIndicatorImage;
            }
            
            imgView.image = image;
            
            imgView.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *con_w = [imgView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:width];
            NSLayoutConstraint *con_h = [imgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:height];
            NSArray <NSLayoutConstraint *> *temp_cons =
            @[
              [imgView jx_con_same:NSLayoutAttributeCenterY equal:self.bgView m:1.0 c:0.0],
              [imgView jx_con_diff:NSLayoutAttributeLeft equal:leftView att2:layoutAttribute m:1.0 c:constant_toL],
              con_h,
              con_w,
              ];
            [NSLayoutConstraint activateConstraints:temp_cons];
            [self.cons_of_imgView_w addObject:con_w];
            [self.cons_of_imgView_h addObject:con_h];
            [self.cons_imgViews addObjectsFromArray:temp_cons];
        }
    }
    else {
        
    }
    
    //
    [self checkHidesForSinglePage];
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    if (self.numberOfPages > 0) {
        if (_currentPage < self.imgViews.count) {
            self.imgViews[_currentPage].image = self.normalIndicatorImage;
            self.cons_of_imgView_w[_currentPage].constant = self.normalIndicatorImage_show_size.width;
            self.cons_of_imgView_h[_currentPage].constant = self.normalIndicatorImage_show_size.height;
        }
        self.imgViews[currentPage].image = self.currentIndicatorImage;
        self.cons_of_imgView_w[currentPage].constant = self.currentImageSize_show_size.width;
        self.cons_of_imgView_h[currentPage].constant = self.currentImageSize_show_size.height;

        _currentPage = currentPage;
    }
    
    //
    [self checkHidesForSinglePage];
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
    [self checkHidesForSinglePage];
}

- (void)checkHidesForSinglePage {
    if (self.hidesForSinglePage) {
        if (self.numberOfPages <= 1) {
            self.hidden = YES;
        }
        else {
            self.hidden = NO;
        }
    }
    else {
        if (self.numberOfPages == 0) {
            self.hidden = YES;
        }
        else {
            self.hidden = NO;
        }
    }
}

@end
