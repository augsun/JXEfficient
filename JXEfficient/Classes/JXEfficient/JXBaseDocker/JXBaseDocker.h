//
//  JXBaseDocker.h
//  JXEfficient
//
//  Created by augsun on 5/17/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 用于组件化项目的组件间通信的 Docker, 对外理解为上层路由寻址, 对内理解为向路由寻址.
 
 @discussion 一个组件持有一个 JXBaseDocker 子类的单例. 1)组件内部持有进行组件内部的功能调用; 2)上层路由持有, 为路由提供内部功能的实现.
 @warning JXBaseDocker 为抽象类, 请使用子类实现<必须>父类方法<接口>.
 */
@interface JXBaseDocker : NSObject

/**
 单例

 @warning 该方法为空实现. 子类必须实现.
 */
+ (nullable instancetype)sharedDocker;

/**
 加载所在组件对应该组件下的 Bundle.
 
 @warning 该方法为空实现. 子类必须实现.

 @return 如果组件还在主工程, 子类返回 nil.
 */
+ (nullable NSBundle *)bundle;

/**
 加载所在组件 Bundle 里的 PDF 图片资源.

 @param name 图片文件名
 */
+ (nullable UIImage *)PDFImageWithNamed:(NSString *)name;

/**
 加载所在组件 Bundle 里的图片资源.

 @param name 图片文件名
 */
+ (nullable UIImage *)imageWithNamed:(NSString *)name;

/**
 加载当前组件下的 xib

 @param aClass UIView 范型
 */
+ (nullable __kindof UIView *)xibView:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
