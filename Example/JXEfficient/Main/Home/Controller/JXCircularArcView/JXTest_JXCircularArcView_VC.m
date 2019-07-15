//
//  JXTest_JXCircularArcView_VC.m
//  JXEfficient_Example
//
//  Created by augsun on 7/15/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXCircularArcView_VC.h"
#import <Masonry/Masonry.h>
#import <JXEfficient/JXEfficient.h>

#import "JXCircularArcView.h"

@interface JXTest_JXCircularArcView_VC ()

@property (nonatomic, strong) JXCircularArcView *arcView;

@end

@implementation JXTest_JXCircularArcView_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rightSubButton_enable = YES;
    
    
    
}

- (void)rightSubButton_click {
    if (!self.arcView) {
        self.arcView = [[JXCircularArcView alloc] init];
        [self.view addSubview:self.arcView];
        [self.arcView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).with.offset(100.0);
            
            // t0
//            make.centerX.mas_equalTo(self.view);
//            make.width.mas_equalTo(300.0);
//            make.height.mas_equalTo(300.0);

            // or t1
            make.left.mas_equalTo(self.view).with.offset(20.0);
            make.right.mas_equalTo(self.view).with.offset(-20.0);
            make.bottom.mas_equalTo(self.view).with.offset(-80.0);
        }];
        self.arcView.backgroundColor = JX_COLOR_RANDOM;
    }

    NSArray <NSDictionary *> * (^randomMigration)(JXCircularArcViewArcPosition) = ^ NSArray <NSDictionary *> * (JXCircularArcViewArcPosition arcPosition) {
        CGFloat tempNum = [JXChowder randomUIntegerFrom:20 to:80] * 1.0;
        return @[
                 @{
                     @"arcMigration": @(tempNum),
                     @"arcPosition": @(arcPosition),
                     },
                 @{
                     @"arcMigration": @(-tempNum),
                     @"arcPosition": @(arcPosition),
                     },
                 ];
    };
    
    //
    NSMutableArray <NSDictionary *> *tempArr = [[NSMutableArray alloc] init];
    [tempArr addObjectsFromArray:randomMigration(JXCircularArcViewArcPositionTop)];
    [tempArr addObjectsFromArray:randomMigration(JXCircularArcViewArcPositionLeft)];
    [tempArr addObjectsFromArray:randomMigration(JXCircularArcViewArcPositionBottom)];
    [tempArr addObjectsFromArray:randomMigration(JXCircularArcViewArcPositionRight)];

    //
    [self testData:tempArr i:0];
}

- (void)testData:(NSArray <NSDictionary *> *)data i:(NSInteger)i {
    if (i >= data.count) {
        
    }
    else {
        self.arcView.arcMigration = jx_floValue(data[i][@"arcMigration"]);
        self.arcView.arcPosition = jx_intValue(data[i][@"arcPosition"]);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self testData:data i:i + 1];
        });
    }
}

@end
