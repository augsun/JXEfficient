//
//  JXImageBrowserLoadImageFailureView.m
//  JXEfficient
//
//  Created by augsun on 1/30/19.
//

#import "JXImageBrowserLoadImageFailureView.h"
#import "NSLayoutConstraint+JXCategory.h"

static const CGFloat kBgViewToLR_min = 30.0;
static const CGFloat kBgViewToT_min = 50.0;
static const CGFloat kBgViewToB_min = 60.0;

static const CGFloat kTipLabelToBgViewLR = 12.0;
static const CGFloat kTipLabelToBgViewB = 12.0;
static const CGFloat kTipLabelToInfoIconImgViewB = 10.0;

@interface JXImageBrowserLoadImageFailureView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *infoIconImgView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation JXImageBrowserLoadImageFailureView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        // bgView
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.bgView jx_con_same:NSLayoutAttributeCenterX equal:self m:1.0 c:0.0],
                                                  [self.bgView jx_con_same:NSLayoutAttributeCenterY equal:self m:1.0 c:0.0],
                                                  [self.bgView jx_con_same:NSLayoutAttributeTop greaterEqual:self m:1.0 c:kBgViewToT_min],
                                                  [self.bgView jx_con_same:NSLayoutAttributeLeft greaterEqual:self m:1.0 c:kBgViewToLR_min],
                                                  [self.bgView jx_con_same:NSLayoutAttributeBottom lessEqual:self m:1.0 c:-kBgViewToB_min],
                                                  [self.bgView jx_con_same:NSLayoutAttributeRight lessEqual:self m:1.0 c:-kBgViewToLR_min],
                                                  ]];

        self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8f];
        self.bgView.layer.cornerRadius = 10.0;
        self.bgView.clipsToBounds = YES;
        
        // infoIconImgView
        CGFloat infoButton_w = 30.0;
        CGFloat infoButton_h = 30.0;
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
        UIImage *tempImg = [tempBtn.currentImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        self.infoIconImgView = [[UIImageView alloc] init];
        self.infoIconImgView.tintColor = [UIColor whiteColor];
        self.infoIconImgView.image = tempImg;
        [self.bgView addSubview:self.infoIconImgView];
        self.infoIconImgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.infoIconImgView jx_con_same:NSLayoutAttributeTop equal:self.bgView m:1.0 c:15.0],
                                                  [self.infoIconImgView jx_con_same:NSLayoutAttributeCenterX equal:self.bgView m:1.0 c:0.0],
                                                  [self.infoIconImgView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:infoButton_w],
                                                  [self.infoIconImgView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:infoButton_h],
                                                  ]];

        // tipLabel
        self.tipLabel = [[UILabel alloc] init];
        [self.bgView addSubview:self.tipLabel];
        self.tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.tipLabel jx_con_diff:NSLayoutAttributeTop equal:self.infoIconImgView att2:NSLayoutAttributeBottom m:1.0 c:kTipLabelToInfoIconImgViewB],
                                                  [self.tipLabel jx_con_same:NSLayoutAttributeLeft equal:self.bgView m:1.0 c:kTipLabelToBgViewLR],
                                                  [self.tipLabel jx_con_same:NSLayoutAttributeBottom equal:self.bgView m:1.0 c:-kTipLabelToBgViewB],
                                                  [self.tipLabel jx_con_same:NSLayoutAttributeRight equal:self.bgView m:1.0 c:-kTipLabelToBgViewLR],
                                                  ]];

        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.font = [UIFont systemFontOfSize:15.0];
        self.tipLabel.text = @"加载失败，请重试！";
    }
    return self;
}

@end










