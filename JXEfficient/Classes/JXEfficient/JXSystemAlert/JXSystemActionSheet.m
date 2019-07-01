//
//  JXSystemActionSheet.m
//  JXEfficient
//
//  Created by augsun on 7/1/19.
//

#import "JXSystemActionSheet.h"
#import "JXMacro.h"

@implementation JXSystemActionSheet

+ (void)sheetFromVC:(UIViewController *)vc
      default0Title:(NSString *)title0
      default1Title:(NSString *)title1
             cancel:(NSString *)cancelTitle
   default0Callback:(void (^)(void))default0Callback
   default1Callback:(void (^)(void))default1Callback
     cancelCallback:(void (^)(void))cancelCallback
{
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:title0
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action)
                              {
                                  JX_BLOCK_EXEC(default0Callback);
                              }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action)
                              {
                                  JX_BLOCK_EXEC(default1Callback);
                              }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       JX_BLOCK_EXEC(cancelCallback);
                                   }];
    
    [alertCtl addAction:action0];
    [alertCtl addAction:action1];
    [alertCtl addAction:actionCancel];
    [vc presentViewController:alertCtl animated:YES completion:nil];
}

@end
