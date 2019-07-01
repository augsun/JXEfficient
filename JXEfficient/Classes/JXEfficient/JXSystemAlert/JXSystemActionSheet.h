//
//  JXSystemActionSheet.h
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXSystemActionSheet : NSObject

+ (void)sheetFromVC:(UIViewController *)vc
      default0Title:(NSString *)title0
      default1Title:(NSString *)title1
             cancel:(NSString *)cancelTitle
   default0Callback:(nullable void(^)(void))default0Callback
   default1Callback:(nullable void(^)(void))default1Callback
     cancelCallback:(nullable void(^)(void))cancelCallback;

@end

NS_ASSUME_NONNULL_END
