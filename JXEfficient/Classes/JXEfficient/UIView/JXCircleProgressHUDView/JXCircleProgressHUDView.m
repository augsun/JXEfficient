//
//  JXCircleProgressHUDView.m
//  JXEfficient
//
//  Created by augsun on 1/30/19.
//

#import "JXCircleProgressHUDView.h"

const CGSize JXCircleProgressHUDViewRecommendSize = {78.0, 78.0};

static const CGFloat kProgressShapWidth = 4.0;
static const CGFloat kProgressShapRadius = 15.0;
static const CGFloat kProgressShapStrokeEndDefault = 0.01;

@interface JXCircleProgressHUDView ()

@property (nonatomic, strong) CALayer *layerHUD;
@property (nonatomic, strong) CAShapeLayer *layerCircle;

@end

@implementation JXCircleProgressHUDView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layerHUD = [CALayer layer];
        [self.layer addSublayer:self.layerHUD];
        self.layerHUD.cornerRadius = 10.0;
        self.layerHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8f].CGColor;
        
        CGRect rectCircle = CGRectMake((JXCircleProgressHUDViewRecommendSize.width - kProgressShapRadius * 2) / 2,
                                       (JXCircleProgressHUDViewRecommendSize.height - kProgressShapRadius * 2) / 2,
                                       kProgressShapRadius * 2,
                                       kProgressShapRadius * 2);
        
        //
        CAShapeLayer *circleLayerBg = [CAShapeLayer layer];
        [self.layerHUD addSublayer:circleLayerBg];
        [circleLayerBg setPath:[UIBezierPath bezierPathWithRoundedRect:rectCircle cornerRadius:kProgressShapRadius].CGPath];
        [circleLayerBg setStrokeColor:[[UIColor alloc] initWithWhite:1.0 alpha:.1f].CGColor];
        [circleLayerBg setLineWidth:kProgressShapWidth];
        [circleLayerBg setFillColor:nil];
        [circleLayerBg setStrokeEnd:1.0];
        
        //
        self.layerCircle = [CAShapeLayer layer];
        [self.layerHUD addSublayer:self.layerCircle];
        self.layerCircle.path = [UIBezierPath bezierPathWithRoundedRect:rectCircle cornerRadius:kProgressShapRadius].CGPath;
        self.layerCircle.strokeColor = [[UIColor alloc] initWithWhite:1.0 alpha:1.0].CGColor;
        self.layerCircle.lineWidth = kProgressShapWidth;
        self.layerCircle.fillColor = nil;
        self.layerCircle.strokeEnd = kProgressShapStrokeEndDefault;
        
        self.layerCircle.lineJoin = kCALineJoinRound;
        self.layerCircle.lineCap = kCALineCapRound;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layerHUD.frame = self.bounds;
    
}

- (void)setProgress:(CGFloat)progress {
    
    if (progress < kProgressShapStrokeEndDefault) { progress = kProgressShapStrokeEndDefault; }
    else if (progress > 1.0) { progress = 1.0; }
    
    if (_progress > progress) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.layerCircle.strokeEnd = progress;
    }];
    
    _progress = progress;
}

- (void)hide:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeScale(0.5, 0.5);
            self.alpha = 0.0;
        }];
    }
    else {
        [self removeFromSuperview];
    }
}

@end










