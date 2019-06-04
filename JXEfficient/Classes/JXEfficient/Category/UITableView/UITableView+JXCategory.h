//
//  UITableView+JXCategory.h
//  JXEfficient
//
//  Created by augsun on 3/7/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// dequeue cell
#define TABLEVIEW_DEQUEUE(identifier) [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath]

// dequeue headerFooter
#define TABLEVIEW_DEQUEUE_HEADER_FOOTER(identifier) [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier]

@interface UITableView (JXCategory)

/**
 快速注册 xib 创建的 cell
 
 @param cellClass xib 对对应的 Class
 @param identifier 要注册的 identifier
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
 快速注册 xib 创建的 headerFooter.

 @param cellClass xib 对对应的 Class
 @param identifier 要注册的 identifier
 */
- (void)jx_regHeaderFooterNib:(Class)cellClass identifier:(NSString *)identifier;

/**
 快速注册 xib 创建的 headerFooter.
 
 @param cellClass xib 对对应的 Class
 @param identifier 要注册的 identifier
 @param bundle xib 所在指定 bundle, 如果 nil, 取 main bundle.
 */
- (void)jx_regHeaderFooterNib:(Class)cellClass identifier:(NSString *)identifier bundle:(nullable NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
