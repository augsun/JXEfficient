//
//  JXFlowView.m
//  JXEfficient
//
//  Created by augsun on 9/10/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import "JXFlowView.h"
#import "JXInline.h"
#import "UIView+JXCategory.h"
#import "JXMacro.h"
#import "NSLayoutConstraint+JXCategory.h"

@interface JXFlowView ()

@property (nonatomic, strong) NSMutableArray <JXFlowViewItemView *> *itemViews;

@end

@implementation JXFlowView

+ (instancetype)flowView {
    JXFlowView *flowView = [[JXFlowView alloc] init];
    return flowView;
}

- (NSMutableArray<JXFlowViewItemView *> *)itemViews {
    if (!_itemViews) {
        _itemViews = [[NSMutableArray alloc] init];
    }
    return _itemViews;
}

+ (NSArray<NSArray<JXFlowViewItemModel *> *> *)itemModelsFromStrings:(NSArray<NSString *> *)strings withLayout:(JXFlowViewLayout *)layout {
    
    //
    if (strings.count == 0 || !layout) {
        return nil;
    }
    
    // 先全部模型化 计算宽度
    NSMutableArray <JXFlowViewItemModel *> *tempArr = [[NSMutableArray alloc] init];
    for (NSString *stringEnum in strings) {
        NSString *cardName = jx_strValue(stringEnum);
        if (cardName.length > 0) {
            JXFlowViewItemModel *model = [[JXFlowViewItemModel alloc] init];
            model.itemTitle = stringEnum;
            model.itemWidth = [self widthForItemModel:model withLayout:layout];
            [tempArr addObject:model];
        }
    }
    
    // 行列存放
    NSMutableArray <NSArray <JXFlowViewItemModel *> *> *items = [[NSMutableArray alloc] init];
    
    CGFloat leftW = layout.inWidth - layout.kEdgeL - layout.kEdgeR;
    NSMutableArray <JXFlowViewItemModel *> *rows = [[NSMutableArray alloc] init];
    
    for (JXFlowViewItemModel *modelEnum in tempArr) {
        CGFloat addW = modelEnum.itemWidth + (rows.count == 0 ? 0 : layout.kInterGap);
        if (leftW > addW) {
            leftW -= addW;
            [rows addObject:modelEnum];
        }
        else {
            [items addObject:rows];
            rows = [[NSMutableArray alloc] init];
            leftW = layout.inWidth - layout.kEdgeL - layout.kEdgeR - modelEnum.itemWidth;
            [rows addObject:modelEnum];
        }
    }
    
    if (rows.count > 0) {
        [items addObject:rows];
    }
    
    return items;
}

+ (CGFloat)widthForItemModel:(JXFlowViewItemModel *)model withLayout:(JXFlowViewLayout *)layout {
    CGSize size = CGSizeMake(CGFLOAT_MAX, layout.itemHeight);
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: layout.titleFont,
                                 };
    
    CGFloat itemWidth = [model.itemTitle boundingRectWithSize:size
                                                      options:JX_DRAW_OPTION
                                                   attributes:attributes
                                                      context:nil].size.width + 1.f;
    
    itemWidth = itemWidth > layout.itemMaxWidth ? layout.itemMaxWidth : itemWidth;
    CGFloat wItem = layout.kTitleToL + itemWidth + layout.kTitleToR;
    return wItem;
}

+ (CGFloat)heightForItemModels:(NSArray<NSArray<JXFlowViewItemModel *> *> *)itemModels withLayout:(JXFlowViewLayout *)layout {
    if (itemModels.count == 0 || !layout) {
        return 0.f;
    }
    
    CGFloat lines = itemModels.count;
    CGFloat h = layout.kEdgeT + lines * (layout.itemHeight + layout.kLineGap) - layout.kLineGap + layout.kEdgeB;
    return h;
}

- (void)setItemModels:(NSArray<NSArray<JXFlowViewItemModel *> *> *)itemModels {
    _itemModels = itemModels;
    
    CGFloat totalCount = 0;
    for (NSArray <JXFlowViewItemModel *> *rowEnum in itemModels) {
        totalCount += rowEnum.count;
    }

    Class aClass = self.itemNibClass;
    if (!aClass) {
        aClass = [JXFlowViewItemView class];
    }

    if (self.itemViews.count < totalCount) {
        NSInteger add = totalCount - self.itemViews.count;
        for (NSInteger i = 0; i < add; i ++) {
            JXFlowViewItemView *itemView = [aClass jx_createFromXib];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [itemView addGestureRecognizer:tap];
            
            [self addSubview:itemView];
            [self.itemViews addObject:itemView];
        }
    }
    else if (self.itemViews.count > totalCount) {
        for (NSInteger i = totalCount; i < self.itemViews.count; i ++) {
            JXFlowViewItemView *itemView = self.itemViews[i];
            itemView.hidden = YES;
        }
    }
    
    // 布局 及 每个 Item 回调上层刷新 UI
    switch (self.layout.alignment) {
        case JXFlowViewLayoutAlignmentLeft:
            {
                NSInteger index = 0;
                NSInteger row = 0;
                CGFloat x = self.layout.kEdgeL;
                for (NSArray <JXFlowViewItemModel *> *rowEnum in self.itemModels) {
                    for (JXFlowViewItemModel *modelEnum in rowEnum) {
                        JXFlowViewItemView *itemView = self.itemViews[index];
                        
                        // 回调上层刷新 UI
                        JX_BLOCK_EXEC(self.itemViewForIndex, itemView, index);
                        
                        // 布局
                        CGFloat y = row * (self.layout.itemHeight + self.layout.kLineGap);
                        
                        if (!itemView.didSetConstraint) {
                            itemView.translatesAutoresizingMaskIntoConstraints = NO;
                            
                            // L T
                            itemView.conToL = [itemView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:x];
                            itemView.conToT = [itemView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:y];
                            [NSLayoutConstraint activateConstraints:@[itemView.conToL, itemView.conToT]];
                            
                            // W H
                            itemView.conW = [itemView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:modelEnum.itemWidth];
                            itemView.conH = [itemView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:self.layout.itemHeight];
                            [NSLayoutConstraint activateConstraints:@[itemView.conW, itemView.conH]];
                            
                            //
                            itemView.didSetConstraint = YES;
                        }
                        else {
                            itemView.conToL.constant = x;
                            itemView.conToT.constant = y;
                            itemView.conW.constant = modelEnum.itemWidth;
                            itemView.conH.constant = self.layout.itemHeight;
                        }
                        
                        itemView.hidden = NO;
                        
                        x += self.layout.kInterGap + modelEnum.itemWidth;
                        
                        index ++;
                    }
                    
                    row ++;
                    x = self.layout.kEdgeL;
                }
            } break;
            
        case JXFlowViewLayoutAlignmentRight:
            {
                NSInteger index = 0;
                NSInteger row = 0;
                CGFloat x = self.layout.kEdgeL;
                for (NSArray <JXFlowViewItemModel *> *rowEnum in self.itemModels) {
                    NSInteger i = 0; // 所在行的 index
                    
                    // 计算当前行的总宽度
                    CGFloat row_w = 0.0;
                    for (JXFlowViewItemModel *modelEnum in rowEnum) {
                        row_w += modelEnum.itemWidth;
                    }
                    row_w += (rowEnum.count - 1) * self.layout.kInterGap;
                    
                    CGFloat first_item_toL = self.layout.inWidth - self.layout.kEdgeR - row_w;

                    for (JXFlowViewItemModel *modelEnum in rowEnum) {
                        JXFlowViewItemView *itemView = self.itemViews[index];
                        
                        // 回调上层刷新 UI
                        JX_BLOCK_EXEC(self.itemViewForIndex, itemView, index);
                        
                        // 布局
                        CGFloat y = row * (self.layout.itemHeight + self.layout.kLineGap);
                        
                        if (!itemView.didSetConstraint) {
                            itemView.translatesAutoresizingMaskIntoConstraints = NO;
                            
                            // L
                            if (i == 0) {
                                x = first_item_toL;
                            }
                            
                            // T
                            itemView.conToL = [itemView jx_con_same:NSLayoutAttributeLeft equal:self m:1.0 c:x];
                            itemView.conToT = [itemView jx_con_same:NSLayoutAttributeTop equal:self m:1.0 c:y];
                            [NSLayoutConstraint activateConstraints:@[itemView.conToL, itemView.conToT]];
                            
                            // W H
                            itemView.conW = [itemView jx_con_same:NSLayoutAttributeWidth equal:nil m:1.0 c:modelEnum.itemWidth];
                            itemView.conH = [itemView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:self.layout.itemHeight];
                            [NSLayoutConstraint activateConstraints:@[itemView.conW, itemView.conH]];
                            
                            //
                            itemView.didSetConstraint = YES;
                        }
                        else {
                            itemView.conToL.constant = x;
                            itemView.conToT.constant = y;
                            itemView.conW.constant = modelEnum.itemWidth;
                            itemView.conH.constant = self.layout.itemHeight;
                        }
                        
                        itemView.hidden = NO;
                        
                        x += self.layout.kInterGap + modelEnum.itemWidth;
                        
                        index ++;
                        
                        i ++;
                    }
                    
                    row ++;
                    x = self.layout.kEdgeL;
                }
            } break;
            
        default: break;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    if ([view isKindOfClass:[JXFlowViewItemView class]]) {
        JXFlowViewItemView *itemView = (JXFlowViewItemView *)view;
        
        NSInteger index = [self.itemViews indexOfObject:itemView];
        
        if (index != NSNotFound) {
            JX_BLOCK_EXEC(self.didTapItemAtIndex, index);
        }
    }
}

@end











