//
//  JXNaviView.h
//  JXEfficient
//
//  Created by augsun on 8/28/17.
//  Copyright © 2017 CoderSun. All rights reserved.
//

#import "JXNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

/**
 JXNaviView 是对 JXNavigationBar 的简单包装.
 建议使用 JXNavigationBar 或继承 JXNavigationBar 进行二次封装.
 */
@interface JXNaviView : JXNavigationBar

+ (instancetype)naviView; ///< 便利初始化器

@property (nonatomic, assign) BOOL bgColorStyle; ///< 背景样式 def. NO (标题按钮控件置白色) <YES 时 内部文字控件反白, NO 时 内部文字控件为 defaultStyleTitleColor 颜色>

@property (nonatomic, assign) BOOL backButtonHidden; ///< 返回按钮 def. NO <默认显示返回按钮>
@property (nullable, nonatomic, copy) void (^backClick)(void);

@property (nullable, nonatomic, copy) NSString *title; ///< 标题def. nil, 设置为 nil 隐藏

@property (nonatomic, assign) BOOL bottomLineHidden; ///< 底部线 def. YES <默认隐藏>
@property (nonatomic, strong) UIColor *bottomLineColor;

@property (nullable, nonatomic, copy) NSString *leftButtonTitle; ///< 标题按钮
@property (nullable, nonatomic, strong) UIImage *leftButtonImage; ///< 图片按钮
@property (nullable, nonatomic, copy) void (^leftButtonTap)(void); ///< 事件回调
@property (nonatomic, assign) BOOL leftButtonHidden; ///< 是否隐藏按钮

@property (nullable, nonatomic, copy) NSString *rightButtonTitle; ///< 标题按钮
@property (nullable, nonatomic, strong) UIImage *rightButtonImage; ///< 图片按钮
@property (nullable, nonatomic, copy) void (^rightButtonTap)(void); ///< 事件回调
@property (nonatomic, assign) BOOL rightButtonHidden; ///< 是否隐藏按钮

@property (nullable, nonatomic, copy) NSString *rightSubButtonTitle; ///< 右二按钮 同上
@property (nullable, nonatomic, strong) UIImage *rightSubButtonImage; ///< 图片按钮
@property (nullable, nonatomic, copy) void (^rightSubButtonTap)(void); ///< 事件回调
@property (nonatomic, assign) BOOL rightSubButtonHidden; ///< 是否隐藏按钮

@end

NS_ASSUME_NONNULL_END










