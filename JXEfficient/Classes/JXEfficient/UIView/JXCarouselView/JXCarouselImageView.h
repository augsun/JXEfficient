//
//  JXCarouselImageView.h
//  JXEfficient
//
//  Created by augsun on 1/31/19.
//

#import <UIKit/UIKit.h>
#import "JXCarouselModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXCarouselImageView : UIView

@property (nonatomic, readonly) UIImageView *imageView; ///< 图片容器

/* ================================================================================================== */
/* ======================== JXEfficient Internal Use Properties And Methods. ======================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Internal Use Properties And Methods.

@property (nullable, nonatomic, strong) JXCarouselModel *JXCarouselImageView_model; ///< 传空 将清空内部数据
@property (nonatomic, copy, nullable) void (^JXCarouselImageView_loadImage)(NSURL *URL, void (^completed)(UIImage * _Nullable image, NSError * _Nullable error)); ///< 加载图片

@end

NS_ASSUME_NONNULL_END
