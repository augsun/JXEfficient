//
//  JXKeysValuesViewCell.h
//  JXEfficient
//
//  Created by augsun on 8/1/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXKeysValuesViewLayout.h"

#import "JXKeysValuesModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 JXEfficient Internal Use Class.
 */
@interface JXKeysValuesViewCell : UITableViewCell

+ (void)countWithModel:(JXKeysValuesModel *)model layout:(JXKeysValuesViewLayout *)layout;
- (void)refreshWithModel:(JXKeysValuesModel *)model layout:(JXKeysValuesViewLayout *)layout lastCell:(BOOL)lastCell;

@end

NS_ASSUME_NONNULL_END
