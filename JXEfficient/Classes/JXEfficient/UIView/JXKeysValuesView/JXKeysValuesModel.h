//
//  JXKeysValuesModel.h
//  JXEfficient
//
//  Created by augsun on 8/1/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 用于展示的数据, 支持 NSString 和 NSAttributedString.
 */
@interface JXKeysValuesModel : NSObject

@property (nonatomic, copy, nullable) NSString *key; ///< 文本 <key 和 attributedKey 同时设置, 优先 key>
@property (nonatomic, copy, nullable) NSAttributedString *attributedKey; ///< 富文本 <key 和 attributedKey 同时设置, 优先 key>
@property (nonatomic, strong, nullable) UIColor *keyTextColor; ///< 默认 0x333333 <如果设置将忽略 JXKeysValuesViewLayout 中的 keyTextColor>

@property (nonatomic, copy, nullable) NSString *value; ///< 同 key
@property (nonatomic, copy, nullable) NSAttributedString *attributedValue; ///< 同 key
@property (nonatomic, strong, nullable) UIColor *valueTextColor; ///< 同 key





/* ================================================================================================== */
/* ======================== JXEfficient Internal Use Properties And Methods. ======================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Internal Use Properties And Methods.

@property (nonatomic, assign) CGFloat key_w;
@property (nonatomic, assign) CGFloat key_h;

@property (nonatomic, assign) CGFloat value_w;
@property (nonatomic, assign) CGFloat value_h;

@property (nonatomic, assign) CGFloat row_h;

@end

NS_ASSUME_NONNULL_END
