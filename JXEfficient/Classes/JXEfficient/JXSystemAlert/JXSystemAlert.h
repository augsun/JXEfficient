//
//  JXSystemAlert.h
//  JXEfficient
//
//  Created by augsun on 8/27/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXSystemAlert : NSObject

// ====================================================================================================
#pragma mark - UIAlertControllerStyleAlert

/**
                           title
                          message
                 <UIAlertActionStyleDefault>
 */
+ (void)alertFromVC:(UIViewController *)viewController
         alertTitle:(NSString *)alertTitle
       alertMessage:(NSString *)alertMessage
      defaultTtitle:(NSString *)defaultTtitle
     defaultHandler:(void(^)(void))defaultHandler;

/**
                           title
   <UIAlertActionStyleCancel> <UIAlertActionStyleDestructive>
 */
+ (void)alertFromVC:(UIViewController *)viewController
         alertTitle:(NSString *)alertTitle
        cancelTitle:(NSString *)cancelTitle
   destructiveTitle:(NSString *)destructiveTitle
      cancelHandler:(void(^)(void))cancelHandler
 destructiveHandler:(void(^)(void))destructiveHandler;

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
 destructiveHandler:(void(^)(void))destructiveHandler;

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
       rightHandler:(void(^)(void))rightHandler;

// ====================================================================================================
#pragma mark - UIAlertControllerStyleActionSheet

+ (void)sheetFromVC:(UIViewController *)viewController
      default0Title:(NSString *)title0
      default1Title:(NSString *)title1
             cancel:(NSString *)cancelTitle
   default0Callback:(void(^)(void))default0Callback
   default1Callback:(void(^)(void))default1Callback
     cancelCallback:(void(^)(void))cancelCallback;

@end




















