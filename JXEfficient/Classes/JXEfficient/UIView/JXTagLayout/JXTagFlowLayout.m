//
//  JXTagFlowLayout.h
//  JXEfficient
//
//  Created by augsun on 2/16/18.
//

#import "JXTagFlowLayout.h"
#import "UIView+JXCategory.h"

@interface JXTagFlowLayout ()

@property(nonatomic, strong) NSMutableArray <NSMutableArray <NSValue *> *> *frames;
@property(nonatomic, assign) CGFloat contentHeight;

@end

@implementation JXTagFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _frames = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self jx_calculateFrames];
}

- (CGSize)collectionViewContentSize {
    CGFloat width = self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    return CGSizeMake(width, self.contentHeight);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray <UICollectionViewLayoutAttributes *> *tempMArr = [[NSMutableArray alloc] init];
    
    CGPoint offset = self.collectionView.contentOffset;
    
    CGRect visibleRect = CGRectMake(0, offset.y, self.collectionView.jx_width, self.collectionView.jx_height);
    CGFloat visibleT = visibleRect.origin.y;
    CGFloat visibleB = visibleRect.origin.y + visibleRect.size.height;
    
    // section
    for(NSInteger section = 0; section < self.frames.count; section ++) {
        
        UIEdgeInsets sectionInset = [self sectionInsetOfSection:section];
        CGSize headerSize = [self headerReferenceSizeOfSection:section];
        CGSize footerSize = [self footerReferenceSizeOfSection:section];
        
        NSArray <NSValue *> *sectionFrames = self.frames[section];
        
        // item
        for(NSInteger item = 0; item < sectionFrames.count; item ++) {
            CGRect itemFrame = sectionFrames[item].CGRectValue;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            CGFloat itemT = itemFrame.origin.y;
            CGFloat itemB = itemFrame.origin.y + itemFrame.size.height;
            
            if (itemT <= visibleB && itemB >= visibleT) {
                // 第一个 item
                if (item == 0) {
                    // 当前 scetion 的 header
                    CGFloat headerT = itemFrame.origin.y - sectionInset.top - headerSize.height;
                    CGFloat headerB = headerT + headerSize.height;
                    if (headerT <= visibleB && headerB >= visibleT) {
                        [tempMArr addObject:[self headerAtt:[NSIndexPath indexPathForRow:0 inSection:section] y:headerT]];
                    }
                    
                    // 上一个 section 的 footer
                    if (section > 0) {
                        CGSize footerSize_pre = [self footerReferenceSizeOfSection:section - 1];
                        
                        CGFloat footerT_pre = headerT - footerSize_pre.height;
                        CGFloat footerB_pre = headerT;
                        if (footerT_pre <= visibleB && footerB_pre >= visibleT) {
                            [tempMArr addObject:[self footerAtt:[NSIndexPath indexPathForRow:0 inSection:section - 1] y:footerT_pre]];
                        }
                    }
                }
                
                //
                UICollectionViewLayoutAttributes *cellAttrs = [[self layoutAttributesForItemAtIndexPath:indexPath] copy];
                cellAttrs.frame = itemFrame;
                [tempMArr addObject:cellAttrs];
                
                // 最后一个 item
                if (item == sectionFrames.count - 1) {
                    // 当前 section 的 footer
                    CGFloat footerT = itemFrame.origin.y + itemFrame.size.height + sectionInset.bottom;
                    CGFloat footerB = footerT + footerSize.height;
                    if (footerT <= visibleB && footerB >= visibleT) {
                        [tempMArr addObject:[self footerAtt:[NSIndexPath indexPathForRow:0 inSection:section] y:footerT]];
                    }
                    
                    // 下一个 section 的 header
                    if (section + 1 < self.frames.count) {
                        CGSize headerSize_next = [self headerReferenceSizeOfSection:section + 1];
                        
                        CGFloat headerT_next = footerB;
                        CGFloat headerB_next = headerT_next + headerSize_next.height;
                        if (headerT_next <= visibleB && headerB_next >= visibleT) {
                            [tempMArr addObject:[self headerAtt:[NSIndexPath indexPathForRow:0 inSection:section + 1] y:headerT_next]];
                        }
                    }
                }
            }
        }
    }
    
    return tempMArr;
}

- (UICollectionViewLayoutAttributes *)headerAtt:(NSIndexPath *)indexPath y:(CGFloat)y {
    UICollectionViewLayoutAttributes *Att = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    Att = [Att copy];
    CGRect frame = Att.frame;
    frame.origin.y = y;
    Att.frame = frame;
    return Att;
}

- (UICollectionViewLayoutAttributes *)footerAtt:(NSIndexPath *)indexPath y:(CGFloat)y {
    UICollectionViewLayoutAttributes *Att = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
    Att = [Att copy];
    CGRect frame = Att.frame;
    frame.origin.y = y;
    Att.frame = frame;
    return Att;
}

- (void)jx_calculateFrames {
    if(self.frames.count > 0) {
        return;
    }
    
    UIEdgeInsets coll_inset = self.collectionView.contentInset;
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    
    CGFloat y = 0.0;
    
    // section
    for(NSInteger section = 0; section < numberOfSections; section ++) {
        
        UIEdgeInsets sectionInset = [self sectionInsetOfSection:section];
        CGSize headerSize = [self headerReferenceSizeOfSection:section];
        CGSize footerSize = [self footerReferenceSizeOfSection:section];
        
        // 当前 section 里 items 布局的初始 x y
        CGFloat x = coll_inset.left + sectionInset.left;
        y += headerSize.height + sectionInset.top;
        
        CGFloat maxX = self.collectionView.frame.size.width - coll_inset.right - sectionInset.right;
        
        // item
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *tempMArr = [[NSMutableArray alloc] init];
        for(NSInteger item = 0; item < numberOfItems; item ++) {
            // 每个 循环结束后 x 都指向下个 item 将会出现的位置 (该位置会在下一个循环进行判断是否换行)
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            CGFloat itemW = 0.1;
            if (self.widthForItem) {
                itemW = self.widthForItem(indexPath);
            }
            CGFloat itemX = x;
            CGFloat itemY = y;
            
            CGFloat itemRight = itemX + itemW;
            
            // 换行
            if (itemRight > maxX) {
                x = coll_inset.left + sectionInset.left;
                y += self.itemHeight + self.minimumLineSpacing;
                
                itemX = x;
                itemY = y;
            }
            
            x += itemW + self.minimumInteritemSpacing;
            
            CGRect rect = CGRectMake(itemX, itemY, itemW, self.itemHeight);
            
            [tempMArr addObject:[NSValue valueWithCGRect:rect]];
        }
        [self.frames addObject:tempMArr];
        
        y = y + self.itemHeight + footerSize.height + sectionInset.bottom;
    }
    
    self.contentHeight = y;
}

- (UIEdgeInsets)sectionInsetOfSection:(NSInteger)section {
    UIEdgeInsets sectionInset = self.sectionInset;
    BOOL ret = [self.collectionView.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)];
    if (ret) {
        id obj = self.collectionView.delegate;
        if (obj) {
            if ([obj respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                sectionInset = [obj collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
            }
        }
    }
    return sectionInset;
}

- (CGSize)headerReferenceSizeOfSection:(NSInteger)section {
    CGSize size = self.headerReferenceSize;
    BOOL ret = [self.collectionView.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)];
    if (ret) {
        id obj = self.collectionView.delegate;
        if (obj) {
            if ([obj respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                size = [obj collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
            }
        }
    }
    return size;
}

- (CGSize)footerReferenceSizeOfSection:(NSInteger)section {
    CGSize size = self.footerReferenceSize;
    BOOL ret = [self.collectionView.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)];
    if (ret) {
        id obj = self.collectionView.delegate;
        if (obj) {
            if ([obj respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
                size = [obj collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
            }
        }
    }
    return size;
}

@end
