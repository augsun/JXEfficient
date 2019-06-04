//
//  JXChowder.h
//  JXEfficient
//
//  Created by augsun on 2/22/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 无法具体归集的其它一些功能.
 */
@interface JXChowder : NSObject

/**
 获取网络请求返回 error 类型的字符串提示

 @param error 网络请求 error
 @param defaultMsg 默认提示
 @return 明确提示
 
 @discussion 无网络或网络超时有明确的 error.code 非这类错误返回默认提示
 */
+ (NSString *)msgForNetError:(nullable NSError *)error defaultMsg:(NSString *)defaultMsg;

/**
 随机布尔值

 @return 随机的布尔值
 */
+ (BOOL)randomBool;

/**
 随机无符号整型

 @param from 始(闭)
 @param to 终(闭)
 @return 随机的无符号整型
 */
+ (NSUInteger)randomUIntegerFrom:(NSUInteger)from to:(NSUInteger)to;

/**
 随机生成字符串

 @param length 长度
 @return 生成的字符串
 */
+ (nullable NSString *)randomStringOfLength:(NSUInteger)length;

/**
 获取设备型号

 @return 设备型号 ("iPhone5,3", "iPad3,5", "iPhone11,6", "x86_64", "i386", ...)
 */
+ (NSString *)deviceModel;

@end

NS_ASSUME_NONNULL_END
