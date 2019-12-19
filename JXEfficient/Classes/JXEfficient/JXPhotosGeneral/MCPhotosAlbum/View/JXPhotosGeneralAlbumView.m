//
//  JXPhotosGeneralView.m
//  JXEfficient
//
//  Created by augsun on 7/19/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXPhotosGeneralAlbumView.h"

#import "NSLayoutConstraint+JXCategory.h"
#import "UITableView+JXCategory.h"
#import "JXMacro.h"

#import "JXPhotosGeneralAlbumViewCell.h"

static NSString *const kCellID = @"kCellID";

@interface JXPhotosGeneralAlbumView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JXPhotosGeneralAlbumView

- (instancetype)init {
    self = [super init];
    if (self) {
        // naviBar
        _naviBar = [[JXNavigationBar alloc] init];
        [self addSubview:self.naviBar];
        self.naviBar.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.naviBar jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:0.0],
                                                  [self.naviBar jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.naviBar jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [self.naviBar jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:JX_NAVBAR_H],
                                                  ]];
        [self.naviBar.titleItem setTitle:@"照片" color:nil font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium]];
        [self.naviBar.rightItem setTitle:@"取消" color:nil font:[UIFont systemFontOfSize:16.0]];
        self.naviBar.bottomLineView.hidden = NO;
        self.naviBar.rightSpacing = 8.0;
        
        // tableView
        self.tableView = [[UITableView alloc] init];
        [self addSubview:self.tableView];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.tableView jx_con_diff:NSLayoutAttributeTop equal:self.naviBar att2:NSLayoutAttributeBottom m:1.0 c:0.0],
                                                  [self.tableView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:0.0],
                                                  [self.tableView jx_con_same:NSLayoutAttributeRight equal:self m:1.0 c:0.0],
                                                  [self.tableView jx_con_same:NSLayoutAttributeBottom equal:self m:1.0 c:0.0],
                                                  ]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = JX_COLOR_HEX(0xf5f5f5);
        self.tableView.estimatedRowHeight = 0.f;
        self.tableView.estimatedSectionHeaderHeight = 0.f;
        self.tableView.estimatedSectionFooterHeight = 0.f;
        [self.tableView registerClass:[JXPhotosGeneralAlbumViewCell class] forCellReuseIdentifier:kCellID];
        self.tableView.rowHeight = JXPhotosGeneralViewAlbumCellThumbImageViewSize.height;
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.separatorColor = JX_COLOR_HEX(0xdedede);
    }
    return self;
}

- (void)setAssetCollections:(NSArray<JXPhotosGeneralAlbumAssetCollection *> *)assetCollections {
    _assetCollections = assetCollections;
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXPhotosGeneralAlbumAssetCollection *assetCollection = self.assetCollections[indexPath.row];
    JXPhotosGeneralAlbumViewCell *cell = TABLEVIEW_DEQUEUE(kCellID);
    cell.assetCollection = assetCollection;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JXPhotosGeneralAlbumAssetCollection *assetCollection = self.assetCollections[indexPath.row];
    JX_BLOCK_EXEC(self.didSelectAssetCollection, assetCollection);
}

@end
