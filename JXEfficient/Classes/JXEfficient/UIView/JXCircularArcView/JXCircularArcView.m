//
//  JXCircularArcView.m
//  JXEfficient
//
//  Created by augsun on 7/15/19.
//

#import "JXCircularArcView.h"
#import "UIView+JXCategory.h"

static const JXCircularArcViewArcPosition k_arcPosition_default = JXCircularArcViewArcPositionBottom; ///< 默认 圆弧位置
static const CGFloat k_arcMigration_default = 20.0; ///< 默认 弧偏移

@interface JXCircularArcView ()

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, assign) CGSize previous_selfSize;

@property (nonatomic, assign) JXCircularArcViewArcPosition previous_arcPosition;
@property (nonatomic, assign) CGFloat previous_arcMigration;

@end

@implementation JXCircularArcView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self JXCircularArcView_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self JXCircularArcView_moreInit];
    }
    return self;
}

- (void)JXCircularArcView_moreInit {
    _arcPosition = k_arcPosition_default;
    _arcMigration = k_arcMigration_default;
    
    _previous_arcPosition = k_arcPosition_default;
    _previous_arcMigration = k_arcMigration_default;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL need = NO;
    
    if (self.jx_width <= 0.0 || self.jx_height <= 0.0) {
        return;
    }

    if (self.jx_width != self.previous_selfSize.width || self.jx_height != self.previous_selfSize.height) {
        self.previous_selfSize = self.jx_size;
        need = YES;
    }
    if (self.arcPosition != self.previous_arcPosition) {
        self.previous_arcPosition = self.arcPosition;
        need = YES;
    }
    if (self.arcMigration != self.previous_arcMigration) {
        self.previous_arcMigration = self.arcMigration;
        need = YES;
    }
    
    if (need) {
        [self JXCircularArcView_drawArc];
    }
}

- (void)setArcPosition:(JXCircularArcViewArcPosition)arcPosition {
    if (_arcPosition != arcPosition) {
        _arcPosition = arcPosition;
        
        if (arcPosition != JXCircularArcViewArcPositionTop &&
            arcPosition != JXCircularArcViewArcPositionLeft &&
            arcPosition != JXCircularArcViewArcPositionBottom &&
            arcPosition != JXCircularArcViewArcPositionRight)
        {
#ifdef DEBUG
            NSLog(@"JXCircularArcView 的 arcPosition 设置有误, 将默认设置为 JXCircularArcViewArcPositionBottom.");
#endif
            arcPosition = JXCircularArcViewArcPositionBottom;
        }
        [self setNeedsLayout];
    }
}

- (void)setArcMigration:(CGFloat)arcMigration {
    if (_arcMigration != arcMigration) {
        _arcMigration = arcMigration;
        [self setNeedsLayout];
    }
}

- (void)JXCircularArcView_drawArc {
    if (self.maskLayer) {
        [self.maskLayer removeFromSuperlayer];
        self.maskLayer = nil;
    }
    
    CGFloat m_fabs = fabs(self.arcMigration);
    CGFloat m = self.arcMigration;
    if (m_fabs == 0.0) {
        return;
    }

    CGFloat w = self.jx_width;
    CGFloat h = self.jx_height;
    
    // 是否超出最大可设置的 弧偏移
    CGFloat _max_arcMigration = 0;
    switch (self.arcPosition) {
        case JXCircularArcViewArcPositionBottom:
        case JXCircularArcViewArcPositionTop:
        {
            _max_arcMigration = MIN(h, w / 2);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        case JXCircularArcViewArcPositionRight:
        {
            _max_arcMigration = MIN(h / 2, w);
        } break;
            
        default: break;
    }
    if (m_fabs > _max_arcMigration) {
        CGFloat m_set_to = m > 0.0 ? _max_arcMigration : - _max_arcMigration;
#ifdef DEBUG
        NSString *s = m > 0.0 ? @"大" : @"小";
        NSLog(@"JXCircularArcView 的 arcMigration 弧偏移 %lf 过%@, 自动设置为最%@弧偏移 %lf.", m, s, s, m_set_to);
#endif
        m = m_set_to;
        m_fabs = _max_arcMigration;
    }

    // 计算半径
    CGFloat r = 0;
    switch (self.arcPosition) {
        case JXCircularArcViewArcPositionBottom:
        case JXCircularArcViewArcPositionTop:
        {
            CGFloat c = sqrt(pow(w / 2, 2) + pow(m_fabs, 2));
            CGFloat sin_bc = m_fabs / c;
            r = c / (sin_bc * 2);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        case JXCircularArcViewArcPositionRight:
        {
            CGFloat c = sqrt(pow(h / 2, 2) + pow(m_fabs, 2));
            CGFloat sin_bc = m_fabs / c;
            r = c / (sin_bc * 2);
        } break;
            
        default: break;
    }
    
    //
    self.maskLayer = [[CAShapeLayer alloc] init];
    self.maskLayer.fillColor = [UIColor whiteColor].CGColor;
    CGMutablePathRef path = CGPathCreateMutable();
    switch (self.arcPosition) {
        case JXCircularArcViewArcPositionBottom:
        {
            if(m > 0) {
                CGPathMoveToPoint(path, NULL, w, h - m);
                CGFloat angle = asin((r - m) / r);
                CGPathAddArc(path, NULL, w / 2, h - r, r, angle, M_PI - angle, NO);
            }
            else {
                CGPathMoveToPoint(path, NULL, w, h);
                CGFloat angle = asin((r + m) / r);
                CGPathAddArc(path, NULL, w / 2, h + r + m, r, 2 * M_PI - angle, M_PI + angle, YES);
            }
            CGPathAddLineToPoint(path, NULL, 0.0, 0.0);
            CGPathAddLineToPoint(path, NULL, w, 0.0);
        } break;
            
        case JXCircularArcViewArcPositionTop:
        {
            if(m > 0) {
                CGPathMoveToPoint(path, NULL, w, m);
                CGFloat angle = asin((r - m) / r);
                CGPathAddArc(path,NULL, w / 2, r, r, 2 * M_PI - angle, M_PI + angle, YES);
            }
            else {
                CGPathMoveToPoint(path, NULL, w, 0.0);
                CGFloat angle = asin((r + m) / r);
                CGPathAddArc(path,NULL, w / 2, - m - r, r, angle, M_PI - angle, NO);
            }
            CGPathAddLineToPoint(path, NULL, 0.0, h);
            CGPathAddLineToPoint(path, NULL, w, h);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        {
            if(m > 0) {
                CGPathMoveToPoint(path, NULL, m, 0.0);
                CGFloat angle = acos((r - m) / r);
                CGPathAddArc(path, NULL, r, h / 2, r, M_PI + angle, M_PI - angle, YES);
            }
            else {
                CGPathMoveToPoint(path, NULL, 0.0, 0.0);
                CGFloat angle = acos((r + m) / r);
                CGPathAddArc(path, NULL, - m - r, h / 2, r, - angle, angle, NO);
            }
            CGPathAddLineToPoint(path, NULL, w, h);
            CGPathAddLineToPoint(path, NULL, w, 0.0);
        } break;
            
        case JXCircularArcViewArcPositionRight:
        {
            if(m > 0) {
                CGPathMoveToPoint(path, NULL, w - m, 0.0);
                CGFloat angle = asin((r - m) / r);
                CGPathAddArc(path, NULL, w - r, h / 2, r, 1.5 * M_PI + angle, M_PI / 2 + angle, NO);
            }
            else {
                CGPathMoveToPoint(path, NULL, w, 0.0);
                CGFloat angle = acos((r + m) / r);
                CGPathAddArc(path, NULL, w + r + m, h / 2, r, M_PI + angle, M_PI - angle, YES);
            }
            CGPathAddLineToPoint(path, NULL, 0.0, h);
            CGPathAddLineToPoint(path, NULL, 0.0, 0.0);
        } break;
            
        default: break;
    }
    
    CGPathCloseSubpath(path);
    self.maskLayer.path = path;
    CFRelease(path);
    self.layer.mask = self.maskLayer;
}

@end
