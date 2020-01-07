//
//  JXKeysValuesView.m
//  JXEfficient
//
//  Created by augsun on 8/1/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXKeysValuesView.h"
#import "UITableView+JXCategory.h"
#import "JXChowder.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"

#import "JXKeysValuesViewCell.h"

static NSString *const kCellID = @"kCellID";

@interface JXKeysValuesView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray <NSLayoutConstraint *> *tableView_cons; ///< [T, L, B, R]

@property (nonatomic, copy) NSArray <JXKeysValuesModel *> *keysValues;
@property (nonatomic, strong) JXKeysValuesViewLayout *layout;

@end

@implementation JXKeysValuesView

+ (CGFloat)countForKeysValues:(NSArray<JXKeysValuesModel *> *)keysValues layout:(JXKeysValuesViewLayout *)layout {
    CGFloat h = 0.0;
    for (JXKeysValuesModel *modelEnum in keysValues) {
        [JXKeysValuesViewCell countWithModel:modelEnum layout:layout];
        h += modelEnum.row_h;
    }
    h += layout.contentEdges.top + layout.contentEdges.bottom;
    return h;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self JXKeysValuesView_moreInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self JXKeysValuesView_moreInit];
    }
    return self;
}

- (void)JXKeysValuesView_moreInit {
    self.backgroundColor = [UIColor whiteColor];
    
    //
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView_cons = [self.tableView jx_con_edgeEqual:self];
    [NSLayoutConstraint activateConstraints:self.tableView_cons];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:[JXKeysValuesViewCell class] forCellReuseIdentifier:kCellID];
}

- (void)refreshWithKeysValues:(NSArray<JXKeysValuesModel *> *)keysValues layout:(JXKeysValuesViewLayout *)layout {
    self.keysValues = keysValues;
    
    if (layout.backgroundColorForDebug) {
        self.backgroundColor = JX_COLOR_RANDOM;
    }
    
    //
    if (self.layout != layout) {
        self.layout = layout;
        self.tableView_cons[0].constant = layout.contentEdges.top;
        self.tableView_cons[1].constant = layout.contentEdges.left;
        self.tableView_cons[2].constant = -layout.contentEdges.bottom;
        self.tableView_cons[3].constant = -layout.contentEdges.right;
    }

    //
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keysValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXKeysValuesModel *model = self.keysValues[indexPath.row];
    JXKeysValuesViewCell *cell = TABLEVIEW_DEQUEUE(kCellID);
    [cell refreshWithModel:model layout:self.layout lastCell:indexPath.row == self.keysValues.count - 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXKeysValuesModel *model = self.keysValues[indexPath.row];
    return model.row_h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JXKeysValuesModel *model = self.keysValues[indexPath.row];
    JX_BLOCK_EXEC(self.didSelectRow, indexPath.row, model);
}

@end
