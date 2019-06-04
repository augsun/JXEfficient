//
//  UICollectionView+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 9/28/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// dequeue cell
#define COLLECTIONVIEW_DEQUEUE(identifier) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath]

// dequeue sectionHeader
#define COLLECTIONVIEW_DEQUEUE_HEADER(identifier) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath]

// dequeue sectionFooter
#define COLLECTIONVIEW_DEQUEUE_FOOTER(identifier) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath]

@interface UICollectionView (JXCategory)

/**
 快速注册 xib 创建的 cell.

 @param cellClass xib 对对应的 Class
 @param identifier 要注册的 identifier
 @discussion 在 main bundle 下取 xib.
 */
- (void)jx_regCellNib:(Class)cellClass identifier:(NSString *)identifier;

/**
 快速注册 xib 创建的 cell
 
 @param cellClass xib 对对应的 Class
 @param identifier 要注册的 identifier
 @param bundle xib 所在指定 bundle, 如果 nil, 取 main bundle.
 */
- (void)jx_regCellNib:(Class)cellClass identifier:(NSString *)identifier bundle:(nullable NSBundle *)bundle;

/**
 快速注册 xib 创建的 sectionHeader

 @param headerClass xib 对对应的 Class
 @param identifier 要注册的 identifier
 @discussion 在 main bundle 下取 xib.
 */
- (void)jx_regSectionHeaderNib:(Class)headerClass identifier:(NSString *)identifier;

/**
 快速注册 xib 创建的 sectionHeader
 
 @param headerClass xib 对对应的 Class
 @param identifier 要注册的 identifier
 @param bundle xib 所在指定 bundle, 如果 nil, 取 main bundle.
 */
- (void)jx_regSectionHeaderNib:(Class)headerClass identifier:(NSString *)identifier bundle:(nullable NSBundle *)bundle;

/**
 快速注册 xib 创建的 sectionFooter

 @param footerClass xib 对对应的 Class
 @param identifier 要注册的 identifier
 @discussion 在 main bundle 下取 xib.
 */
- (void)jx_regSectionFooterNib:(Class)footerClass identifier:(NSString *)identifier;

/**
 快速注册 xib 创建的 sectionFooter
 
 @param footerClass xib 对对应的 Class
 @param identifier 要注册的 identifier
 @param bundle xib 所在指定 bundle, 如果 nil, 取 main bundle.
 */
- (void)jx_regSectionFooterNib:(Class)footerClass identifier:(NSString *)identifier bundle:(nullable NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
