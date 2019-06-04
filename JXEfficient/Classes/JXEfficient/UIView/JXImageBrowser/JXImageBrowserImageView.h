//
//  JXImageBrowserImageView.h
//  JXEfficient
//
//  Created by CoderSun on 4/21/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXImageBrowserImage.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat JXImageBrowserImageViewAnimationDuration;

/**
 JXEfficient Internal Use Class.
 */
@interface JXImageBrowserImageView : UIView

@property (nonatomic, strong) JXImageBrowserImage *jxImage;

@property (nonatomic, strong) UIImage *largeImage;
@property (nonatomic, assign) BOOL firstGrace;

- (void)hide; ///< 从外部进行隐藏 比如二维码识别到了以后进行隐藏

@property (nonatomic, copy) void (^loadImage)(NSURL *URL, void (^progress)(NSInteger receivedSize, NSInteger expectedSize), void (^completed)(UIImage * _Nullable image, NSError * _Nullable error));

@property (nonatomic, copy) void (^didDrag)(CGFloat percent, BOOL needAnimation); ///< percent 为偏移百分比

@property (nonatomic, copy) void (^singleTapAction)(JXImageBrowserImageView *imageBrowserImageView);
@property (nonatomic, copy) void (^didZoomOutAction)(JXImageBrowserImageView *imageBrowserImageView);
@property (nonatomic, copy) void (^longPressAction)(JXImageBrowserImageView *imageBrowserImageView);

@end

NS_ASSUME_NONNULL_END
