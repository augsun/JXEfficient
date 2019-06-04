//
//  JXTagsGeneralView.h
//  JXEfficient_Example
//
//  Created by augsun on 5/2/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import "JXTagsView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 较通常场景使用的 JXTagsView, 主要只显示系统字体的 tagName 和 indicator, 无需自定义其 tagCell 的情况可以快速接入使用.
 其属性:
 forRemainSpacingLayoutType = JXTagsViewForRemainSpacingLayoutTypeWeightedAverage; 总宽度小于边界时 用加权方式进行布局
 使用时, 建议将父类设置 forceZoomOutLayoutWhenBeyondSpacingUsingWeightedAverage = YES;
 */
@interface JXTagsGeneralView : JXTagsView

@property (nonatomic, strong) UIColor *normalColor; ///< 正常状态下标签文字颜色, 默认 0x666666
@property (nonatomic, strong) UIColor *selectedColor; ///< 选中状态下标签文字颜色, 默认 0x333333
@property (nonatomic, strong) UIFont *normalFont; ///< 正常状态下标签字体, 默认 14.0pt 的系统字体 <计算宽度时 取 normalFont selectedFont 中的大数>
@property (nonatomic, strong) UIFont *selectedFont; ///< 选中状态下标签字体, 默认 14.0pt 的系统字体 <计算宽度时 取 normalFont selectedFont 中的大数>

/**
 传入字符串数组即可 不需要设置父类的 tagModels.
 @warning 数组里不能有非字符串对象. 如果有, 会进行尝试转换, 转换失败会默认显示为 "Non string". 如果字符串为空字符串 @"", 则显示为 "Empty string". tagNames 如果改变, 会改变 tagIndex, 上层需调用 -selectTagIndex:animated: 重新指定.
 */
@property (nonatomic, copy) NSArray <NSString *> *tagNames;

@end

NS_ASSUME_NONNULL_END
