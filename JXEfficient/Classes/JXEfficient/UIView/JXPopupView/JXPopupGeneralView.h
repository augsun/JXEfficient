//
//  JXPopupGeneralView.h
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import "JXPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPopupGeneralView : JXPopupView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *contentLabel;
@property (nonatomic, readonly) UILabel *button0Label;
@property (nonatomic, readonly) UILabel *button1Label;

@property (nonatomic, copy) void (^button0Click)(void);
@property (nonatomic, copy) void (^button1Click)(void);

@end

NS_ASSUME_NONNULL_END
