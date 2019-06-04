//
//  JXFlowViewItemModel.h
//  JXEfficient
//
//  Created by augsun on 9/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 该类只持有显示相关的属性 上层继承子类不应该持有业务属性*/ 
@interface JXFlowViewItemModel : NSObject

@property (nonatomic, assign) NSString *itemTitle;
@property (nonatomic, assign) CGFloat itemWidth;

@end

NS_ASSUME_NONNULL_END
