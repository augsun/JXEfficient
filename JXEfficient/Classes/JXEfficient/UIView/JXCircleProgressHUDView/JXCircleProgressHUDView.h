//
//  JXCircleProgressHUDView.h
//  JXEfficient
//
//  Created by augsun on 1/30/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGSize JXCircleProgressHUDViewRecommendSize;

@interface JXCircleProgressHUDView : UIView

/**
 进度
 
 @warning 必须在主线程设置
 */
@property (nonatomic, assign) CGFloat progress;

/**
 隐藏

 @param animated 动画
 */
- (void)hide:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
