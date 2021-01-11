//
//  JXKeysValuesView.h
//  JXEfficient
//
//  Created by augsun on 8/1/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXKeysValuesViewLayout.h>

#import <JXKeysValuesModel.h>

NS_ASSUME_NONNULL_BEGIN

/**
 用于展示 key value 形式的视图.
 */
@interface JXKeysValuesView : UIView

/**
 数据源处理

 @param keysValues 要展示的数据
 @param layout 布局
 @return 返回该数据源下将展示的高度
 
 @warning 传入的 layout 将不允许再被修改, 用于传入 -[JXKeysValuesView refreshWithKeysValues:layout:] 方法, 否则导致布局错乱.
 */
+ (CGFloat)countForKeysValues:(NSArray <JXKeysValuesModel *> *)keysValues layout:(JXKeysValuesViewLayout *)layout;

/**
 刷新

 @param keysValues 要刷新的数据源
 @param layout 处理数据源布局
 
 @discussion 可用于 cell 的子视图一并被复用, 不必担心内部性能问题.
 @warning 传入的 layout 必须与传入 +[JXKeysValuesView countForKeysValues:layout:] 方法的 layout 一致, 否则导致布局错乱.
 */
- (void)refreshWithKeysValues:(NSArray <JXKeysValuesModel *> *)keysValues layout:(JXKeysValuesViewLayout *)layout;

@property (nonatomic, copy, nullable) void (^didSelectRow)(NSInteger row, JXKeysValuesModel *model); ///< 行点击回调

@end

NS_ASSUME_NONNULL_END
