//
//  JXBaseDocker.m
//  JXEfficient
//
//  Created by augsun on 5/17/19.
//

#import "JXBaseDocker.h"
#import "UIImage+JXCategory.h"
#import "UIView+JXCategory.h"

@implementation JXBaseDocker

+ (instancetype)sharedDocker {
    return nil;
}

+ (NSBundle *)bundle {
    return nil;
}

+ (UIImage *)PDFImageWithNamed:(NSString *)name {
    UIImage *image = [UIImage jx_PDFImageWithNamed:name inBundle:[self bundle]];
    return image;
}

+ (UIImage *)imageWithNamed:(NSString *)name {
    UIImage *image = [UIImage jx_imageWithNamed:name inBundle:[self bundle]];
    return image;
}

+ (UIView *)xibView:(Class)aClass {
    __kindof  UIView *view = [aClass jx_createFromXibInBundle:[self bundle]];
    return view;
}

@end
