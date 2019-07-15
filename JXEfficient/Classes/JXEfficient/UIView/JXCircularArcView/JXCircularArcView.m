//
//  JXCircularArcView.m
//  JXEfficient
//
//  Created by augsun on 7/15/19.
//

#import "JXCircularArcView.h"
#import "UIView+JXCategory.h"

static const JXCircularArcViewArcPosition k_arcPosition_default = JXCircularArcViewArcPositionBottom; ///< 默认 圆弧位置
static const CGFloat k_arcMigration_default = 15.0; ///< 默认 弧偏移

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
    [self JXCircularArcView_drawArc];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [self JXCircularArcView_drawArc];
}

- (void)setArcPosition:(JXCircularArcViewArcPosition)arcPosition {
    if (arcPosition != JXCircularArcViewArcPositionTop &&
        arcPosition != JXCircularArcViewArcPositionLeft &&
        arcPosition != JXCircularArcViewArcPositionBottom &&
        arcPosition != JXCircularArcViewArcPositionRight) {
        NSLog(@"JXCircularArcView 的 arcPosition 设置误, 将默认设置为 JXCircularArcViewArcPositionBottom.");
        arcPosition = JXCircularArcViewArcPositionBottom;
    }
    _arcPosition = arcPosition;
    [self JXCircularArcView_drawArc];
}

- (void)setArcMigration:(CGFloat)arcMigration {
    _arcMigration = arcMigration;
    [self JXCircularArcView_drawArc];
}

- (void)JXCircularArcView_drawArc {
    if (!self.window) {
        return;
    }

    CGFloat migration = fabs(self.arcMigration);
    if (migration == 0.0) {
        if (self.maskLayer) {
            [self.maskLayer removeFromSuperlayer];
            self.maskLayer = nil;
        }
        return;
    }

    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat t_width = self.jx_width;
    CGFloat t_height = self.jx_height;
    
    // 计算圆弧的最大高度
    CGFloat _maxRadian = 0;
    switch (self.arcPosition) {
        case JXCircularArcViewArcPositionBottom:
        case JXCircularArcViewArcPositionTop:
        {
            _maxRadian = MIN(t_height, t_width / 2);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        case JXCircularArcViewArcPositionRight:
        {
            _maxRadian = MIN(t_height / 2, t_width);
        } break;
            
        default: break;
    }
    if(migration > _maxRadian){
        NSLog(@"JXCircularArcView 的 arcMigration 圆弧半径过大, 自动设置为最大半径.");
        migration = _maxRadian;
    }
    
    // 计算半径
    CGFloat radius = 0;
    switch (self.arcPosition) {
        case JXCircularArcViewArcPositionBottom:
        case JXCircularArcViewArcPositionTop:
        {
            CGFloat c = sqrt(pow(t_width / 2, 2) + pow(migration, 2));
            CGFloat sin_bc = migration / c;
            radius = c / (sin_bc * 2);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        case JXCircularArcViewArcPositionRight:
        {
            CGFloat c = sqrt(pow(t_height / 2, 2) + pow(migration, 2));
            CGFloat sin_bc = migration / c;
            radius = c / ( sin_bc * 2);
        } break;
            
        default: break;
    }
    
    // 画圆
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    CGMutablePathRef path = CGPathCreateMutable();
    switch (self.arcPosition) {
        case JXCircularArcViewArcPositionBottom:
        {
            if(self.arcMigration > 0) {
                CGPathMoveToPoint(path, NULL, t_width,t_height - migration);
                CGPathAddArc(path, NULL, t_width / 2, t_height - radius, radius, asin((radius - migration) / radius), M_PI - asin((radius - migration) / radius), NO);
            }
            else {
                CGPathMoveToPoint(path, NULL, t_width,t_height);
                CGPathAddArc(path, NULL, t_width / 2, t_height + radius - migration, radius, 2 * M_PI - asin((radius - migration) / radius), M_PI + asin((radius - migration) / radius), YES);
            }
            CGPathAddLineToPoint(path, NULL, x, y);
            CGPathAddLineToPoint(path, NULL, t_width, y);
        } break;
            
        case JXCircularArcViewArcPositionTop:
        {
            if(self.arcMigration > 0) {
                CGPathMoveToPoint(path, NULL, t_width, migration);
                CGPathAddArc(path,NULL, t_width / 2, radius, radius, 2 * M_PI - asin((radius - migration) / radius), M_PI + asin((radius - migration) / radius), YES);
            }
            else {
                CGPathMoveToPoint(path, NULL, t_width, y);
                CGPathAddArc(path,NULL, t_width / 2, migration - radius, radius, asin((radius - migration) / radius), M_PI - asin((radius - migration) / radius), NO);
            }
            CGPathAddLineToPoint(path, NULL, x, t_height);
            CGPathAddLineToPoint(path, NULL, t_width, t_height);
        } break;
            
        case JXCircularArcViewArcPositionLeft:
        {
            if(self.arcMigration > 0) {
                CGPathMoveToPoint(path, NULL, migration, y);
                CGPathAddArc(path, NULL, radius, t_height / 2, radius, M_PI + asin((radius - migration) / radius), M_PI - asin((radius - migration) / radius), YES);
            }
            else {
                CGPathMoveToPoint(path, NULL, x, y);
                CGPathAddArc(path, NULL, migration - radius, t_height / 2, radius, 2 * M_PI - asin((radius - migration) / radius), asin((radius - migration) / radius), NO);
            }
            CGPathAddLineToPoint(path, NULL, t_width, t_height);
            CGPathAddLineToPoint(path, NULL, t_width, y);
        } break;
            
        case JXCircularArcViewArcPositionRight:
        {
            if(self.arcMigration > 0) {
                CGPathMoveToPoint(path, NULL, t_width - migration, y);
                CGPathAddArc(path, NULL, t_width - radius, t_height / 2, radius, 1.5 * M_PI + asin((radius - migration) / radius), M_PI / 2 + asin((radius - migration) / radius), NO);
            }
            else {
                CGPathMoveToPoint(path, NULL, t_width, y);
                CGPathAddArc(path, NULL, t_width  + radius - migration, t_height / 2, radius, M_PI + asin((radius - migration) / radius), M_PI - asin((radius - migration) / radius), YES);
            }
            CGPathAddLineToPoint(path, NULL, x, t_height);
            CGPathAddLineToPoint(path, NULL, x, y);
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
