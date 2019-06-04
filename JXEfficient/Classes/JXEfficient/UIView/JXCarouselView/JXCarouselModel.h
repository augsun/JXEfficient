//
//  JXCarouselModel.h
//  JXEfficient
//
//  Created by augsun on 1/31/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 JXEfficient Internal Use Class.
 */
@interface JXCarouselModel : NSObject

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, assign) NSInteger index;

//
@property (nullable, nonatomic, strong) UIImage *largeImage;
@property (nonatomic, assign) BOOL imageDownloading;
@property (nonatomic, assign) BOOL loadImageFailure;

@end

NS_ASSUME_NONNULL_END
