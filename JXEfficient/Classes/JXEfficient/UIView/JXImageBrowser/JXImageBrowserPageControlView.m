//
//  JXImageBrowserPageControlView.m
//  JXEfficient
//
//  Created by augsun on 1/29/19.
//

#import "JXImageBrowserPageControlView.h"
#import "NSLayoutConstraint+JXCategory.h"

@interface JXImageBrowserPageControlView ()

@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIView *borderBgView;

@end

@implementation JXImageBrowserPageControlView

- (instancetype)init {
    self = [super init];
    if (self) {
        // pageLabel
        self.pageLabel = [[UILabel alloc] init];
        [self addSubview:self.pageLabel];
        self.pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.pageLabel jx_con_same:NSLayoutAttributeLeft greaterEqual:self m:1.0 c:8.0],
                                                  [self.pageLabel jx_con_same:NSLayoutAttributeRight lessEqual:self m:1.0 c:-8.0],
                                                  [self.pageLabel jx_con_same:NSLayoutAttributeCenterX equal:self m:1.0 c:0.0],
                                                  [self.pageLabel jx_con_same:NSLayoutAttributeCenterY equal:self m:1.0 c:0.0],
                                                  ]];

        self.pageLabel.textAlignment = NSTextAlignmentCenter;
        self.pageLabel.font = [UIFont systemFontOfSize:16.0];
        self.pageLabel.textColor = [UIColor whiteColor];

        // borderBgView
        self.borderBgView = [[UIView alloc] init];
        [self addSubview:self.borderBgView];
        self.borderBgView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray <NSLayoutConstraint *> *cons = [self.borderBgView jx_con_edgeEqual:self.pageLabel];
        cons[0].constant = -4.0;
        cons[1].constant = -8.0;
        cons[2].constant = 4.0;
        cons[3].constant = 8.0;
        [NSLayoutConstraint activateConstraints:cons];;

        self.borderBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        self.borderBgView.clipsToBounds = YES;
        self.borderBgView.layer.cornerRadius = 6.0;
        
        //
        [self bringSubviewToFront:self.pageLabel];
        
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages >= 0) {
        _numberOfPages = numberOfPages;
        if (numberOfPages <= 0 && self.hidesForSinglePage) {
            self.hidden = YES;
        }
        else {
            self.hidden = NO;
            self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentPage, (long)self.numberOfPages];
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage >= 0) {
        _currentPage = currentPage;
        
        NSInteger currentPage_show = self.numberOfPages > 0 ? currentPage + 1 : 0;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage_show, (long)self.numberOfPages];
    }
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
    if (self.numberOfPages <= 0) {
        self.hidden = YES;
    }
    else {
        self.hidden = NO;
    }
}

@end
