//
//  JXBaseWebVCScriptMessageHandler.m
//  JXEfficient
//
//  Created by augsun on 2/22/19.
//

#import "JXBaseWebVCScriptMessageHandler.h"
#import "JXMacro.h"

@implementation JXBaseWebVCScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    JX_BLOCK_EXEC(self.didReceiveScriptMessage, message.name, message.body);
}

@end
