//
//  JXBaseWebVCScriptMessageHandler.h
//  JXEfficient
//
//  Created by augsun on 2/22/19.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXBaseWebVCScriptMessageHandler : NSObject <WKScriptMessageHandler>

@property (nonatomic, copy) void (^didReceiveScriptMessage)(NSString *name, id _Nullable body);

@end

NS_ASSUME_NONNULL_END
