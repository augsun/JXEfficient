//
//  JXCarouselImagePageControlView.h
//  JXEfficient
//
//  Created by augsun on 2/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 JXEfficient Internal Use Class.
 */
@interface JXCarouselImagePageControlView : UIView

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger numberOfPages;

@property (nonatomic, assign) BOOL hidesForSinglePage;

/**
 指定初始化器
 */
- (instancetype)initWithNormalIndicatorImage:(UIImage *)normalIndicatorImage
                             normalImageSize:(CGSize)normalImageSize
                       currentIndicatorImage:(UIImage *)currentIndicatorImage
                            currentImageSize:(CGSize)currentImageSize;

@end

NS_ASSUME_NONNULL_END
