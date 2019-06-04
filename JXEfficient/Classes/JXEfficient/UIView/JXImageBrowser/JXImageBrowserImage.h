//
//  JXImageBrowserImage.h
//  JXEfficient
//
//  Created by CoderSun on 4/21/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXImageBrowserImage : NSObject

@property (nonatomic, strong) NSURL *imageURL; ///< 图片的 URL
@property (nullable, nonatomic, strong) UIImageView *imageViewFrom; ///< 图片的来源 imageView.(可不传)

@end

NS_ASSUME_NONNULL_END
