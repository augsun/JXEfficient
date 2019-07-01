//
//  JXPopupGeneralView.m
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import "JXPopupGeneralView.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

@interface JXPopupGeneralView ()

@end

@implementation JXPopupGeneralView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self JXPopupGeneralView_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self JXPopupGeneralView_moreInit];
    }
    return self;
}

- (void)JXPopupGeneralView_moreInit {
    //
    _titleLabel = [[UILabel alloc] init];
    [self.titleView addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray <NSLayoutConstraint *> *cons = [self.titleLabel jx_con_edgeEqual:self.titleView];
    [NSLayoutConstraint activateConstraints:cons];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.titleLabel.textColor = JX_COLOR_GRAY(51);
    
    //
    
}

@end
