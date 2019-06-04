//
//  UICollectionView+JXCategory.m
//  JXEfficient
//
//  Created by augsun on 9/28/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import "UICollectionView+JXCategory.h"

@implementation UICollectionView (JXCategory)

- (void)jx_regCellNib:(Class)cellClass identifier:(NSString *)identifier {
    [self jx_regCellNib:cellClass identifier:identifier bundle:nil];
}

- (void)jx_regCellNib:(Class)cellClass identifier:(NSString *)identifier bundle:(NSBundle *)bundle {
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:bundle];
    [self registerNib:cellNib forCellWithReuseIdentifier:identifier];
}

- (void)jx_regSectionHeaderNib:(Class)headerClass identifier:(NSString *)identifier {
    [self jx_regSectionHeaderNib:headerClass identifier:identifier bundle:nil];
}

- (void)jx_regSectionHeaderNib:(Class)headerClass identifier:(NSString *)identifier bundle:(NSBundle *)bundle {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([headerClass class]) bundle:bundle];
    [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)jx_regSectionFooterNib:(Class)footerClass identifier:(NSString *)identifier {
    [self jx_regSectionFooterNib:footerClass identifier:identifier bundle:nil];
}

- (void)jx_regSectionFooterNib:(Class)footerClass identifier:(NSString *)identifier bundle:(NSBundle *)bundle {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([footerClass class]) bundle:bundle];
    [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

@end










