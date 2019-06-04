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

/* ================================================================================================== */
/* ======================== JXEfficient Internal Use Properties And Methods. ======================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Internal Use Properties And Methods.

@property (nonatomic, readonly) UIImageView *imageView; ///< 图片容器
@property (nullable, nonatomic, strong) JXCarouselModel *model; ///< 传空 将清空内部数据
@property (nonatomic, copy) void (^loadImage)(NSURL *URL, void (^completed)(UIImage * _Nullable image, NSError * _Nullable error)); ///< 加载图片

@end

NS_ASSUME_NONNULL_END
