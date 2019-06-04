//
//  JXTagsViewItemModel.h
//  JXEfficient
//
//  Created by augsun on 2/27/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 JXTagsView 的显示模型数据, 上层业务对应的模型应继承自该类.
 @discusstion 属性 tagWidth 为必须设置的属性, 建议 indicatorWidth 一并设置.
 */
@interface JXTagsViewTagModel : NSObject

/* ============================== 以下属性 上层先计算好 ============================== */
/**
 tag 的宽度
 
 @discussion 上层业务决定指示条的宽度
 @warning 必须设置 且不能 <= 0.0
 */
@property (nonatomic, assign) CGFloat tagWidth;

/**
 指示条宽度
 
 @discussion 上层业务根据具体场景决定指示条所依据的宽度, 若不设置, 则使用 JXTagsView 内置固定宽度指示条.
 */
@property (nonatomic, assign) CGFloat indicatorWidth;

/* ============================== 上层读取 ============================== */
/**
 是否当前选中 上层不可修改
 */
@property (nonatomic, assign) BOOL selected;





/* ================================================================================================== */
/* ======================== JXEfficient Internal Use Properties And Methods. ======================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Internal Use Properties And Methods.

@property (nonatomic, assign) CGFloat tagWidth_showing;         ///< 显示中的实际宽度
@property (nonatomic, assign) CGFloat tag_toL;                  ///< 左边距距离左边
@property (nonatomic, assign) CGFloat center_x;                 ///< 中心位置距离左边
@property (nonatomic, assign) CGFloat indicatorWidth_showing;   ///< 实际显示中的 指示器宽度

@end

NS_ASSUME_NONNULL_END
