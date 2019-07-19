//
//  JXTestBaseVC.h
//  JXEfficient
//
//  Created by augsun on 7/3/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXEfficient/JXNaviView.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXTestBaseVC : UIViewController

@property (nonatomic, readonly) JXNaviView *naviView;

@property (nonatomic, assign) BOOL leftButton_enable;
@property (nonatomic, assign) BOOL rightButton_enable;
@property (nonatomic, assign) BOOL rightSubButton_enable;

- (void)backButton_click;
- (void)leftButton_click;
- (void)rightButton_click;
- (void)rightSubButton_click;

@end

NS_ASSUME_NONNULL_END
