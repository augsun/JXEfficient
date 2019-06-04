//
//  JXImageBrowserProgressHUDView.h
//  JXEfficient
//
//  Created by augsun on 1/30/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 JXEfficient Internal Use Class.
 */
@interface JXImageBrowserProgressHUDView : UIView

@property (nonatomic, assign) CGFloat progress;

+ (CGSize)showSize;

@end

NS_ASSUME_NONNULL_END
