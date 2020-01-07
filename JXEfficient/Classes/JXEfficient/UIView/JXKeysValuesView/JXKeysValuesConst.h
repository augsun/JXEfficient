//
//  JXKeysValuesConst.h
//  JXEfficient
//
//  Created by augsun on 8/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** key value 中高度较小的那个在布局时的贴近方式*/
typedef NS_ENUM(NSUInteger, JXKeysValuesCloseTo) {
    JXKeysValuesCloseToTop = 1, ///< 靠上
    JXKeysValuesCloseToCenterY, ///< 垂直居中
    JXKeysValuesCloseToBottom, ///< 靠下
};

@interface JXKeysValuesConst : NSObject

@end

NS_ASSUME_NONNULL_END
