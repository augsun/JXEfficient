//
//  JXEfficient_docker.m
//  JXEfficient
//
//  Created by augsun on 5/17/19.
//

#import "JXEfficient_docker.h"
#import "JXEfficient.h"

@implementation JXEfficient_docker

static JXEfficient_docker *singleton_;
+ (instancetype)sharedDocker {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton_ = [[self alloc] init];
    });
    return singleton_;
}

+ (NSBundle *)bundle {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:NSStringFromClass([JXEfficient class]) ofType:@"bundle"]];
    return bundle;
}

+ (UIImage *)PDFImageWithNamed:(NSString *)name {
    UIImage *image = [UIImage jx_PDFImageWithNamed:name inBundle:[self bundle]];
    return image;
}

+ (UIImage *)imageWithNamed:(NSString *)name {
    UIImage *image = [UIImage jx_imageWithNamed:name inBundle:[self bundle]];
    return image;
}

@end
