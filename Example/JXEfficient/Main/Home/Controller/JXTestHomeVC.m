//
//  JXViewController.m
//  JXEfficient
//
//  Created by 452720799@qq.com on 12/29/2018.
//  Copyright (c) 2018 452720799@qq.com. All rights reserved.
//

#import "JXTestHomeVC.h"
#import <JXEfficient/JXEfficient.h>
#import <Masonry/Masonry.h>

#import "JXTestHomeCell.h"

//
#import "JXTest_JXCarouselView_VC.h"
#import "JXTest_JXPopupGeneralView_VC.h"

static NSString *const kCellID = @"kCellID";

@interface JXTestHomeVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JXNaviView *naviView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JXTestHomeModel *> *models;

@end

@implementation JXTestHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    JX_WEAK_SELF;
    self.view.backgroundColor = JX_COLOR_SYS_SECTION;
    self.models = [[NSMutableArray alloc] init];
    
    // JXTest_JXPopupGeneralView_VC
    {
        JXTestHomeModel *model = [JXTestHomeModel modelFromVcClass:[JXTest_JXCarouselView_VC class]];
        [self.models addObject:model];
    }
    {
        JXTestHomeModel *model = [JXTestHomeModel modelFromVcClass:[JXTest_JXPopupGeneralView_VC class]];
        [self.models addObject:model];
    }

    // 排序<升>
    [self.models sortUsingComparator:^NSComparisonResult(JXTestHomeModel * _Nonnull obj1, JXTestHomeModel * _Nonnull obj2) {
        return [obj1.title compare:obj2.title];
    }];
    
    // naviView
    self.naviView = [JXNaviView naviView];
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(JX_NAVBAR_H);
    }];
    self.naviView.title = @"Test Page";
    self.naviView.rightButtonTitle = @"Fast Test";
    self.naviView.backButtonHidden = YES;
    self.naviView.bottomLineHidden = NO;
    self.naviView.rightButtonTap = ^{
        JX_STRONG_SELF;
        [self fastTest];
    };
    
    //
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).with.offset(-JX_UNUSE_AREA_OF_BOTTOM);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView jx_regCellNib:[JXTestHomeCell class] identifier:kCellID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - fastTest

- (void)fastTest {
    
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXTestHomeModel *model = self.models[indexPath.row];
    JXTestHomeCell *cell = TABLEVIEW_DEQUEUE(kCellID);
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JXTestHomeModel *model = self.models[indexPath.row];
    UIViewController *vc = [[model.vcClass alloc] init];
    [self jx_pushVC:vc];
}

@end















