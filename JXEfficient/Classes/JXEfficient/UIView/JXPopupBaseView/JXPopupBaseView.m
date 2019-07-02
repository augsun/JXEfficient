//
//  JXPopupBaseView.m
//  JXEfficient
//
//  Created by augsun on 2/23/19.
//

#import "JXPopupBaseView.h"
#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

@interface JXPopupBaseView ()

@end

@implementation JXPopupBaseView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self jx_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self jx_moreInit];
    }
    return self;
}

- (void)jx_moreInit {
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *bgBtn = [[UIButton alloc] init];
    [self addSubview:bgBtn];
    bgBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[bgBtn jx_con_edgeEqual:self]];
    [bgBtn addTarget:self action:@selector(jx_btnBgClick) forControlEvents:UIControlEventTouchUpInside];
    [self sendSubviewToBack:bgBtn];
}

- (void)jx_btnBgClick {
    JX_BLOCK_EXEC(self.backgroundTap);
}

- (void)show:(BOOL)animated change:(void (^)(void))change completion:(void (^)(void))completion {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[self jx_con_edgeEqual:win]];

    if (animated) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
            JX_BLOCK_EXEC(change);
        } completion:^(BOOL finished) {
            JX_BLOCK_EXEC(completion);
        }];
    }
    else {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
        JX_BLOCK_EXEC(change);
        JX_BLOCK_EXEC(completion);
    }
}

- (void)hide:(BOOL)animated change:(void (^)(void))change completion:(void (^)(void))completion {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundColor = [UIColor clearColor];
            JX_BLOCK_EXEC(change);
        } completion:^(BOOL finished) {
            JX_BLOCK_EXEC(completion);
            [self removeFromSuperview];
        }];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
        JX_BLOCK_EXEC(change);
        JX_BLOCK_EXEC(completion);
        [self removeFromSuperview];
    }
}

JX_DEALLOC_TEST

@end
