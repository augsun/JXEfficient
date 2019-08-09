//
//  JXKeysValuesViewLayout.h
//  JXEfficient
//
//  Created by augsun on 8/1/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXKeysValuesConst.h"

NS_ASSUME_NONNULL_BEGIN

/** key 的布局样式 */
typedef NS_ENUM(NSUInteger, JXKeysValuesViewKeyLayoutType) {
    JXKeysValuesViewKeyLayoutTypePercentKeyWidth = 1, ///< key 占布局总宽度百分比
    JXKeysValuesViewKeyLayoutTypeFixedWidth, ///< key 固定宽度
};

@interface JXKeysValuesViewLayout : NSObject

@property (nonatomic, assign) CGFloat width; ///< JXKeysValuesView 将要用于展示时的宽度 <必须正确及合理设置>
@property (nonatomic, assign) UIEdgeInsets contentEdges; ///< 列表布局的边距. 默认 {0, 0, 0, 0} 

// cell
@property (nonatomic, assign) BOOL showSeparator; ///< 是否显示每行的分割线, 默认 NO
@property (nonatomic, assign) BOOL showLastRowSeparator; ///< 在 showSeparator 为 YES 的情况下, 是否显示最后一行分割线. 默认 YES.
@property (nonatomic, assign) UIEdgeInsets separatorInset; ///< 分割线边距. 默认 {0, 15, 0, 0}, 其中 top 值无效
@property (nonatomic, strong) UIColor *separatorColor; ///< 分割线颜色, 默认 0xDEDEDE

@property (nonatomic, assign) JXKeysValuesViewKeyLayoutType keyLayoutType; ///< key 的布局样式, 默认 JXKeysValuesViewKeyLayoutTypePercentKeyWidth
@property (nonatomic, assign) CGFloat percentOfKeyWidth; ///< JXKeysValuesViewKeyLayoutTypePercentKeyWidth 布局模式下必须有值, 默认 0.2 <包含了 keyContentEdges 和 valueContentEdges 的 left right>

@property (nonatomic, assign) CGFloat minimumRowHeight;

//
@property (nonatomic, assign) CGFloat keyFixedWidth; ///< JXKeysValuesViewKeyLayoutTypeFixedWidth 布局模式下必须有值 <包含了 keyContentEdges 的 left right>
@property (nonatomic, assign) NSInteger keyNumberOfLines; ///< 行数 <目前只支持 1单行 和 0多行, 其它值都将归入多行, 后期扩展>, 默认 0
@property (nonatomic, strong, nullable) UIFont *keyFont; ///< 默认 14.0 系统字体
@property (nonatomic, assign) JXKeysValuesCloseTo keyCloseTo; ///< 默认 JXKeysValuesCloseToCenterY
@property (nonatomic, assign) NSTextAlignment keyTextAlignment; ///< 默认 NSTextAlignmentCenter
@property (nonatomic, strong, nullable) UIColor *keyTextColor; ///< 默认 0x333333
@property (nonatomic, assign) UIEdgeInsets keyContentEdges; ///< key 内部布局的边距. 默认 {4, 4, 4, 4}
@property (nonatomic, assign) CGFloat keyMinimumScaleFactor; ///< 缩放, 默认 0.9 <不建议设置为 1, 苹果系统调整字体后可能会导致显示不全>

@property (nonatomic, assign) CGFloat valueFixedWidth; ///< 可以不设置
@property (nonatomic, assign) NSInteger valueNumberOfLines; ///< 同 key
@property (nonatomic, strong, nullable) UIFont *valueFont; ///< 同 key
@property (nonatomic, assign) JXKeysValuesCloseTo valueCloseTo; ///< 同 key
@property (nonatomic, assign) NSTextAlignment valueTextAlignment; ///< 同 key
@property (nonatomic, strong, nullable) UIColor *valueTextColor; ///< 同 key
@property (nonatomic, assign) UIEdgeInsets valueContentEdges; ///< key 内部布局的边距. 默认 {4, 4, 4, 4}
@property (nonatomic, assign) CGFloat valueMinimumScaleFactor; ///< 同 key

@end

NS_ASSUME_NONNULL_END
