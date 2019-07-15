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
@property (nonatomic, assign) CGSize previousSelfSize;

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
    self.autoresizingMask = UIViewAutoresizingNone;
    _arcPosition = k_arcPosition_default;
    _arcMigration = k_arcMigration_default;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL rightWH = self.jx_width > 0.0 && self.jx_height > 0.0;
    if (rightWH) {
        BOOL newWH = self.jx_width != self.previousSelfSize.width || self.jx_height != self.previousSelfSize.height;
        if (newWH) {
            self.previousSelfSize = self.jx_size;
            [self JXCircularArcView_drawArc];
        }
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
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
            NSLog(@"JXCircularArcView 的 arcPosition 设置误, 将默认设置为 JXCircularArcViewArcPositionBottom.");
            arcPosition = JXCircularArcViewArcPositionBottom;
        }
        [self JXCircularArcView_drawArc];
    }
}

- (void)setArcMigration:(CGFloat)arcMigration {
    if (_arcMigration != arcMigration) {
        _arcMigration = arcMigration;
        [self JXCircularArcView_drawArc];
    }
}

- (void)JXCircularArcView_drawArc {
    if (!self.window) {
        return;
    }
    
    CGFloat m_fabs = fabs(self.arcMigration);
    CGFloat m = self.arcMigration;
    if (m_fabs == 0.0) {
        if (self.maskLayer) {
            [self.maskLayer removeFromSuperlayer];
            self.maskLayer = nil;
        }
        return;
    }

    CGFloat w = self.jx_width;
    CGFloat h = self.jx_height;
    
    // 计算圆弧的最大偏移
    CGFloat _maxRadian = 0;
    switch (self.arcPosition) {
        case JXCircularArcViewArcPositionBottom:
        case JXCircularArcViewArcPositionTop:
        {
            _maxRadian = MIN(h, w / 2);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        case JXCircularArcViewArcPositionRight:
        {
            _maxRadian = MIN(h / 2, w);
        } break;
            
        default: break;
    }
    if(m_fabs > _maxRadian){
        NSLog(@"JXCircularArcView 的 arcMigration 圆弧半径 %lf 过大, 自动设置为最大半径 %lf.", m_fabs, _maxRadian);
        m_fabs = _maxRadian;
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
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    CGMutablePathRef path = CGPathCreateMutable();
    switch (self.arcPosition) {
        case JXCircularArcViewArcPositionBottom:
        {
            if(m > 0) {
                CGPathMoveToPoint(path, NULL, w, h - m);
                CGPathAddArc(path, NULL, w / 2, h - r, r, asin((r - m) / r), M_PI - asin((r - m) / r), NO);
            }
            else {
                CGPathMoveToPoint(path, NULL, w, h);
                CGPathAddArc(path, NULL, w / 2, h + r + m, r, 2 * M_PI - asin((r + m) / r), M_PI + asin((r + m) / r), YES);
            }
            CGPathAddLineToPoint(path, NULL, 0.0, 0.0);
            CGPathAddLineToPoint(path, NULL, w, 0.0);
        } break;
            
        case JXCircularArcViewArcPositionTop:
        {
            if(m > 0) {
                CGPathMoveToPoint(path, NULL, w, m);
                CGPathAddArc(path,NULL, w / 2, r, r, 2 * M_PI - asin((r - m) / r), M_PI + asin((r - m) / r), YES);
            }
            else {
                CGPathMoveToPoint(path, NULL, w, 0.0);
                CGPathAddArc(path,NULL, w / 2, -m - r, r, asin((r + m) / r), M_PI - asin((r + m) / r), NO);
            }
            CGPathAddLineToPoint(path, NULL, 0.0, h);
            CGPathAddLineToPoint(path, NULL, w, h);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        {
            if(m > 0) {
                CGPathMoveToPoint(path, NULL, m, 0.0);
                CGPathAddArc(path, NULL, r, h / 2, r, M_PI + acos((r - m) / r), M_PI / 2 + asin((r - m) / r), YES);
            }
            else {
                CGPathMoveToPoint(path, NULL, 0.0, 0.0);
                CGPathAddArc(path, NULL, -m - r, h / 2, r, - acos((r + m) / r), acos((r + m) / r) + 0, NO);
            }
            CGPathAddLineToPoint(path, NULL, w, h);
            CGPathAddLineToPoint(path, NULL, w, 0.0);
        } break;
            
        case JXCircularArcViewArcPositionRight:
        {
            if(m > 0) {
                CGPathMoveToPoint(path, NULL, w - m, 0.0);
                CGPathAddArc(path, NULL, w - r, h / 2, r, 1.5 * M_PI + asin((r - m) / r), M_PI / 2 + asin((r - m) / r), NO);
            }
            else {
                CGPathMoveToPoint(path, NULL, w, 0.0);
                CGPathAddArc(path, NULL, w + r + m, h / 2, r, M_PI + acos((r + m) / r), M_PI - acos((r + m) / r), YES);
            }
            CGPathAddLineToPoint(path, NULL, 0.0, h);
            CGPathAddLineToPoint(path, NULL, 0.0, 0.0);
        } break;
            
        default: break;
    }
    
    CGPathCloseSubpath(path);
    [maskLayer setPath:path];
    CFRelease(path);
    self.layer.mask = maskLayer;
    
    self.maskLayer = maskLayer;
}

@end
