//
//  JXTest_JXPhotos_View.m
//  JXEfficient
//
//  Created by augsun on 7/18/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXTest_JXPhotos_View.h"
#import <Masonry/Masonry.h>
#import <JXEfficient/JXEfficient.h>

#import "JXPhotosView.h"

#import "JXTest_JXPhotos_Cell.h"

@interface JXTest_JXPhotos_View ()

@property (nonatomic, strong) JXPhotosView *photosView;

@end

@implementation JXTest_JXPhotos_View

- (instancetype)init
{
    self = [super init];
    if (self) {
        _photosView = [[JXPhotosView alloc] init];
        [self addSubview:self.photosView];
        [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).with.offset(-40.0);
        }];
        self.photosView.nibCellClass = [JXTest_JXPhotos_Cell class];
        self.photosView.refreshCellUsingBlock = ^(__kindof JXPhotosViewCell * _Nonnull jxCell, __kindof JXPhotosAsset * _Nonnull jxAsset) {
            JXTest_JXPhotos_Cell *cell = (JXTest_JXPhotos_Cell *)jxCell;
            JXTest_JXPhotos_AlbumImageModel *model = (JXTest_JXPhotos_AlbumImageModel *)jxAsset;
            [cell refreshUI:model];
        };
        CGFloat leftW =
        JX_SCREEN_W -
        self.photosView.collectionView.contentInset.left -
        self.photosView.collectionView.contentInset.right -
        self.photosView.sectionInset.left -
        self.photosView.sectionInset.right;
        
        NSInteger count = 4;
        CGFloat w = (leftW - (count - 1) * self.photosView.interitemSpacing) / count;
        CGFloat h = w;
        self.photosView.expectItemSize = CGSizeMake(w, h);
        self.photosView.rollToBottomForFirstTime = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.photosView.lineSpacing = 20.0;
//            self.photosView.interitemSpacing = 30.0;
//            self.photosView.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        });
    }
    return self;
}

- (void)setModels:(NSArray<JXTest_JXPhotos_AlbumImageModel *> *)models {
    _models = models;
    self.photosView.assets = models;
}

JX_DEALLOC_TEST

@end
