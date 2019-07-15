//
//  JXCircularArcView.m
//  JXEfficient
//
//  Created by augsun on 7/15/19.
//

#import "JXCircularArcView.h"
#import "UIView+JXCategory.h"

@interface JXCircularArcView ()

@end

@implementation JXCircularArcView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self JXCircularArcView_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self JXCircularArcView_moreInit];
    }
    return self;
}

- (void)JXCircularArcView_moreInit {
    _position = JXCircularArcViewArcPositionBottom;
    _radian = 15.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.jx_width > 0.0 && self.jx_height > 0.0) {
        [self drawArc];
    }
}

- (void)setPosition:(JXCircularArcViewArcPosition)position {
    _position = position;
    [self drawArc];
}

- (void)setRadian:(CGFloat)radian {
    _radian = radian;
    [self drawArc];
}

- (void)drawArc {
    CGFloat t_width = self.jx_width;
    CGFloat t_height = self.jx_height;
    CGFloat height = fabs(self.radian);
    CGFloat x = 0;
    CGFloat y = 0;
    
    // 计算圆弧的最大高度
    CGFloat _maxRadian = 0;
    switch (self.position) {
        case JXCircularArcViewArcPositionBottom:
        case JXCircularArcViewArcPositionTop:
            _maxRadian = MIN(t_height, t_width / 2);
            break;
        case JXCircularArcViewArcPositionLeft:
        case JXCircularArcViewArcPositionRight:
            _maxRadian = MIN(t_height / 2, t_width);
            break;
        default:
            break;
    }
    if(height > _maxRadian){
        NSLog(@"圆弧半径过大.");
        return;
    }
    
    // 计算半径
    CGFloat radius = 0;
    switch (self.position) {
        case JXCircularArcViewArcPositionBottom:
        case JXCircularArcViewArcPositionTop:
        {
            CGFloat c = sqrt(pow(t_width / 2, 2) + pow(height, 2));
            CGFloat sin_bc = height / c;
            radius = c / (sin_bc * 2);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        case JXCircularArcViewArcPositionRight:
        {
            CGFloat c = sqrt(pow(t_height / 2, 2) + pow(height, 2));
            CGFloat sin_bc = height / c;
            radius = c / ( sin_bc * 2);
        } break;
            
        default: break;
    }
    
    // 画圆
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    CGMutablePathRef path = CGPathCreateMutable();
    switch (self.position) {
        case JXCircularArcViewArcPositionBottom:
        {
            if(self.radian > 0){
                CGPathMoveToPoint(path,NULL, t_width,t_height - height);
                CGPathAddArc(path, NULL, t_width / 2, t_height - radius, radius, asin((radius - height) / radius), M_PI - asin((radius - height) / radius), NO);
            }else{
                CGPathMoveToPoint(path,NULL, t_width,t_height);
                CGPathAddArc(path, NULL, t_width / 2, t_height + radius - height, radius, 2 * M_PI - asin((radius - height) / radius), M_PI + asin((radius - height) / radius), YES);
            }
            CGPathAddLineToPoint(path, NULL, x, y);
            CGPathAddLineToPoint(path, NULL, t_width, y);
        } break;
            
        case JXCircularArcViewArcPositionTop:
        {
            if(self.radian > 0){
                CGPathMoveToPoint(path, NULL, t_width, height);
                CGPathAddArc(path,NULL, t_width / 2, radius, radius, 2 * M_PI - asin((radius - height) / radius), M_PI + asin((radius - height) / radius), YES);
            }else{
                CGPathMoveToPoint(path, NULL, t_width, y);
                CGPathAddArc(path,NULL, t_width / 2, height - radius, radius, asin((radius - height) / radius), M_PI - asin((radius - height) / radius), NO);
            }
            CGPathAddLineToPoint(path, NULL, x, t_height);
            CGPathAddLineToPoint(path, NULL, t_width, t_height);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        {
            if(self.radian > 0){
                CGPathMoveToPoint(path, NULL, height, y);
                CGPathAddArc(path, NULL, radius, t_height / 2, radius, M_PI + asin((radius - height) / radius), M_PI - asin((radius - height) / radius), YES);
            }else{
                CGPathMoveToPoint(path, NULL, x, y);
                CGPathAddArc(path, NULL, height - radius, t_height / 2, radius, 2 * M_PI - asin((radius - height) / radius), asin((radius - height) / radius), NO);
            }
            CGPathAddLineToPoint(path, NULL, t_width, t_height);
            CGPathAddLineToPoint(path, NULL, t_width, y);
        } break;
            
        case JXCircularArcViewArcPositionRight:
        {
            if(self.radian > 0){
                CGPathMoveToPoint(path, NULL, t_width - height, y);
                CGPathAddArc(path, NULL, t_width - radius, t_height / 2, radius, 1.5 * M_PI + asin((radius - height) / radius), M_PI / 2 + asin((radius - height) / radius), NO);
            }else{
                CGPathMoveToPoint(path, NULL, t_width, y);
                CGPathAddArc(path, NULL, t_width  + radius - height, t_height / 2, radius, M_PI + asin((radius - height) / radius), M_PI - asin((radius - height) / radius), YES);
            }
            CGPathAddLineToPoint(path, NULL, x, t_height);
            CGPathAddLineToPoint(path, NULL, x, y);
        } break;
            
        default: break;
    }
    
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    self.layer.mask = shapeLayer;
}

@end
