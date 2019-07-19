//
//  JXTest_JXCarouselView_CustomView.m
//  JXEfficient
//
//  Created by augsun on 7/5/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXCarouselView_CustomView.h"

#import <Masonry/Masonry.h>

#import <SDWebImage/UIImageView+WebCache.h>

@interface JXTest_JXCarouselView_CustomView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *browseCountLabel;

@end

@implementation JXTest_JXCarouselView_CustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // imgView
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self).with.offset(20.0);
            make.bottom.right.mas_equalTo(self).with.offset(-20.0);
        }];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
        
        // browseCountLabel
        self.browseCountLabel = [[UILabel alloc] init];
        [self addSubview:self.browseCountLabel];
        [self.browseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(8.0);
            make.top.mas_equalTo(self).with.offset(8.0);
        }];
        self.browseCountLabel.font = [UIFont systemFontOfSize:12.0];
        self.browseCountLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.browseCountLabel.textColor = [UIColor whiteColor];
        self.browseCountLabel.numberOfLines = 2;
    }
    return self;
}

- (void)setModel:(JXTest_JXCarouselView_CustomModel *)model {
    _model = model;
    
    //
    [self.imgView sd_setImageWithURL:model.URL placeholderImage:nil options:SDWebImageRetryFailed];
    
    //
    self.browseCountLabel.text = [NSString stringWithFormat:@"  浏览量：%ld\r\n  <For Custom JXCarouselImageView>", model.browseCount];
    
    if (model.showSize.width == 0.0 && model.showSize.height == 0.0) {
        CGSize thatSize = [self.browseCountLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 50.0)];
        model.showSize = CGSizeMake(thatSize.width + 6.0 * 2, thatSize.height + 3.0 * 2);
    }
    [self.browseCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(model.showSize);
    }];
}

@end
