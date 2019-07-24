//
//  JXCircleProgressHUDView.h
//  JXEfficient
//
//  Created by augsun on 1/30/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGSize JXCircleProgressHUDViewRecommendSize;

/**
 JXEfficient Internal Use Class.
 */
@interface JXCircleProgressHUDView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)hide:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
