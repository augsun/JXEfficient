//
//  JXSystemAlert.h
//  JXEfficient
//
//  Created by augsun on 8/27/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXSystemAlert : NSObject

#pragma mark - UIAlertControllerStyleAlert
#pragma mark 单个

/**
 <title message Cancel>
 */
+ (void)alertFromVC:(UIViewController *)vc
              title:(nullable NSString *)title
            message:(nullable NSString *)message
        cancelTitle:(nullable NSString *)cancelTitle
      cancelHandler:(nullable void (^)(void))cancelHandler;

/**
 <title message Default>
 */
+ (void)alertFromVC:(UIViewController *)vc
              title:(nullable NSString *)title
            message:(nullable NSString *)message
       defaultTitle:(nullable NSString *)defaultTitle
     defaultHandler:(nullable void (^)(void))defaultHandler;

/**
 <title message Destructive>
 */
+ (void)alertFromVC:(UIViewController *)vc
              title:(nullable NSString *)title
            message:(nullable NSString *)message
   destructiveTitle:(nullable NSString *)destructiveTitle
 destructiveHandler:(nullable void (^)(void))destructiveHandler;

#pragma mark 双个

/**
 <title message Cancel, Default>
 */
+ (void)alertFromVC:(UIViewController *)vc
              title:(nullable NSString *)title
            message:(nullable NSString *)message
        cancelTitle:(nullable NSString *)cancelTitle
       defaultTitle:(nullable NSString *)defaultTitle
      cancelHandler:(nullable void (^)(void))cancelHandler
     defaultHandler:(nullable void (^)(void))defaultHandler;

/**
 <title message Cancel, Destructive>
 */
+ (void)alertFromVC:(UIViewController *)vc
              title:(nullable NSString *)title
            message:(nullable NSString *)message
        cancelTitle:(nullable NSString *)cancelTitle
   destructiveTitle:(nullable NSString *)destructiveTitle
      cancelHandler:(nullable void (^)(void))cancelHandler
 destructiveHandler:(nullable void (^)(void))destructiveHandler;

/**
 <title message Default, Default>
 */
+ (void)alertFromVC:(UIViewController *)vc
              title:(nullable NSString *)title
            message:(nullable NSString *)message
   leftDefaultTitle:(nullable NSString *)leftDefaultTitle
  rightDefaultTitle:(nullable NSString *)rightDefaultTitle
 leftDefaultHandler:(nullable void (^)(void))leftDefaultHandler
rightDefaultHandler:(nullable void (^)(void))rightDefaultHandler;

+ (void)sheetFromVC:(UIViewController *)vc
      default0Title:(NSString *)title0
      default1Title:(NSString *)title1
             cancel:(NSString *)cancelTitle
   default0Callback:(nullable void(^)(void))default0Callback
   default1Callback:(nullable void(^)(void))default1Callback
     cancelCallback:(nullable void(^)(void))cancelCallback;

@end

/**
 以下方法将废弃
 */
@interface JXSystemAlert (Deprecated)

/**
                           title
                          message
                 <UIAlertActionStyleDefault>
 */
+ (void)alertFromVC:(UIViewController *)viewController
         alertTitle:(NSString *)alertTitle
       alertMessage:(NSString *)alertMessage
      defaultTtitle:(NSString *)defaultTtitle
     defaultHandler:(void(^)(void))defaultHandler __deprecated_msg("即将废弃, 请使用 JXSystemAlert 下对应的新方法 <title message Default>.");

/**
                           title
   <UIAlertActionStyleCancel> <UIAlertActionStyleDestructive>
 */
+ (void)alertFromVC:(UIViewController *)viewController
         alertTitle:(NSString *)alertTitle
        cancelTitle:(NSString *)cancelTitle
   destructiveTitle:(NSString *)destructiveTitle
      cancelHandler:(void(^)(void))cancelHandler
 destructiveHandler:(void(^)(void))destructiveHandler __deprecated_msg(("即将废弃, 请使用 JXSystemAlert 下对应的新方法 <title message(set nil) Cancel, Destructive>."));

/**
                           title
                          message
   <UIAlertActionStyleCancel> <UIAlertActionStyleDestructive>
 */
+ (void)alertFromVC:(UIViewController *)viewController
         alertTitle:(NSString *)alertTitle
       alertMessage:(NSString *)alertMessage
        cancelTitle:(NSString *)cancelTitle
   destructiveTitle:(NSString *)destructiveTitle
      cancelHandler:(void(^)(void))cancelHandler
 destructiveHandler:(void(^)(void))destructiveHandler __deprecated_msg(("即将废弃, 请使用 JXSystemAlert 下对应的新方法 <title message Cancel, Destructive>."));

/**
                           title
                          message
   <UIAlertActionStyleDefault> <UIAlertActionStyleDefault>
 
 */
+ (void)alertFromVC:(UIViewController *)viewController
         alertTitle:(NSString *)alertTitle
       alertMessage:(NSString *)alertMessage
  defaultTtitleLeft:(NSString *)defaultTtitleLeft
 defaultTtitleRight:(NSString *)defaultTtitleRight
        leftHandler:(void(^)(void))leftHandler
       rightHandler:(void(^)(void))rightHandler __deprecated_msg(("即将废弃, 请使用 JXSystemAlert 下对应的新方法 <title message Default, Default>."));

@end

NS_ASSUME_NONNULL_END




















