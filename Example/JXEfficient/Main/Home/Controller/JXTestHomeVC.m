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
#import "JXTest_JXPhotosGeneral_VC.h"
#import "JXTest_JXTagsGeneralView_VC.h"
#import "JXTest_JXPhotos_VC.h"
#import "JXTest_JXNaviView_VC.h"
#import "JXTest_JXCircularArcView_VC.h"
#import "JXTest_JXCarouselView_VC.h"
#import "JXTest_JXPopupGeneralView_VC.h"

#import <Photos/Photos.h>
#import "JXPhotos.h"

static NSString *const kCellID = @"kCellID";

@interface JXTestHomeVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JXNaviView *naviView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JXTestHomeModel *> *models;

@property (nonatomic, strong) PHImageRequestOptions *options;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;

@end

@implementation JXTestHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    JX_WEAK_SELF;
    self.view.backgroundColor = JX_COLOR_SYS_SECTION;
    self.models = [[NSMutableArray alloc] init];
    
    void (^addTestVC)(Class) = ^ (Class aClass) {
        JXTestHomeModel *model = [JXTestHomeModel modelFromVcClass:aClass];
        [self.models addObject:model];
    };
    
    //
    addTestVC([JXTest_JXPhotosGeneral_VC class]);
    addTestVC([JXTest_JXTagsGeneralView_VC class]);
    addTestVC([JXTest_JXPhotos_VC class]);
    addTestVC([JXTest_JXNaviView_VC class]);
    addTestVC([JXTest_JXCarouselView_VC class]);
    addTestVC([JXTest_JXCircularArcView_VC class]);
    addTestVC([JXTest_JXPopupGeneralView_VC class]);

    // 排序<升>
//    [self.models sortUsingComparator:^NSComparisonResult(JXTestHomeModel * _Nonnull obj1, JXTestHomeModel * _Nonnull obj2) {
//        return [obj1.title compare:obj2.title];
//    }];
    
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

#pragma mark - fastTest

- (void)fastTest {
//    [JXPhotos fetchImageAssetsWithOptions:nil];
    
//    [self getAllPhotosFromAlbum];
}

- (void)getAllPhotosFromAlbum {//配置简单 ，但是参数却是比价多且
    self.options = [[PHImageRequestOptions alloc] init];//请求选项设置
    self.options.resizeMode = PHImageRequestOptionsResizeModeExact;//自定义图片大小的加载模式
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.synchronous = YES;//是否同步加载
    
    //容器类
    self.assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil]; //得到所有图片
    /*
     PHAssetMediaType：
     PHAssetMediaTypeUnknown = 0,//在这个配置下，请求不会返回任何东西
     PHAssetMediaTypeImage   = 1,//图片
     PHAssetMediaTypeVideo   = 2,//视频
     PHAssetMediaTypeAudio   = 3,//音频
     */
//    [self.containView.collectionView reloadData];
}

//- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
//    AlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALBUMCELLID forIndexPath:indexPath];
//    //cell.backgroundColor= [UIColor redColor];
//    CGSize size =CGSizeMake(50,50);//自定义image size变化情况颇为复杂 下面由说到
//
//    //返回一个 PHImageRequestID，在异步请求时可以根据这个ID去取消请求,同步就没办法了..
//    [[PHImageManager defaultManager] requestImageForAsset:self.assets[indexPath.row] targetSize:size contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage*_Nullable result,NSDictionary*_Nullable info) {
//        /*
//         最终产生图片的size是有   imageOptions.resizeMode（即PHImageRequestOptions） 以及 PHImageContentMode  决定的,当然也有我们设定的size
//         优先级而言
//         PHImageRequestOptions > PHImageContentMode
//         */
//        //这个handler 并非在主线程上执行，所以如果有UI的更新操作就得手动添加到主线程中
//        //       dispatch_async(dispatch_get_main_queue(), ^{ //update UI  });
//
//#pragma If -[PHImageRequestOptions isSynchronous] returns NO (or options is nil), resultHandler may be called 1 or more times. .........异步就这个回调会调用1或多次....
//#pragma If -[PHImageRequestOptions isSynchronous] returns YES, resultHandler will be called exactly once同步就1次.
//        //一开始本来打算是利用数据吧所有的相片先存起来的.但是发现同步会卡UI  但是异步又会被回调多次，我的数组都变成double了...只好把任务方法方法cellforItem中
//        cell.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
//        cell.photoImageView.image = result;
//    }];
//    return cell;
//}
/*注意这个info字典   有时这个info甚至为null   慎用
 里面的key是比较奇怪的
 尽量不要用里面的key
 因为这个key 会变动： 当我们最终获取到的图片的size的高／宽  没有一个达到能原有的图片size的高／宽时
 部分key 会消失  如 PHImageFileSandboxExtensionTokenKey , PHImageFileURLKey
 */
/*
 在PHImageContentModeAspectFill 下  图片size 有一个分水岭  {125,125}   {126,126}
 当imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
 时: 设置size 小于{125,125}时，你得到的图片size 将会是设置的1/2
 
 而在PHImageContentModeAspectFit 分水岭  {120,120}   {121,121}
 至于为什么会这样？？？－ －   可能苹果考虑性能吧
 */

@end















