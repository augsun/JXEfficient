//
//  JXTagFlowLayout.h
//  JXEfficient
//
//  Created by augsun on 2/16/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UICollectionView 的 itemCell 不等宽 flowLayout.
 */
@interface JXTagFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat itemHeight; ///< 固定行高
@property (nonatomic, copy) CGFloat (^widthForItem)(NSIndexPath *indexPath); ///< 请求宽度

@end

NS_ASSUME_NONNULL_END
