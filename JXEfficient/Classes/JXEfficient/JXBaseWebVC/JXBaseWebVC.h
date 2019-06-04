//
//  JXBaseWebVC.h
//  JXEfficient
//
//  Created by augsun on 2/21/19.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "JXNaviView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXBaseWebVC : UIViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) JXNaviView *naviView; ///< 导航条
@property (nonatomic, strong) WKWebView *webView; ///< webView

@property (nonatomic, assign) BOOL goBackWebViewPriority; ///< 导航条点击返回是否优先返回 webView def. YES

- (void)loadWithURLString:(NSString *)URLString;

- (void)titleDidChange:(NSString *)title; ///< 由子类重写, 不允许直接调用

- (void)addScriptMessageHandlerName:(NSString *)name; ///< 添加 H5 调用原生的方法
- (void)didReceiveScriptMessage:(NSString *)name body:(id)body NS_REQUIRES_SUPER; ///< 由子类重写, 不允许直接调用

// <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation NS_REQUIRES_SUPER;
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation NS_REQUIRES_SUPER;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation NS_REQUIRES_SUPER;
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error NS_REQUIRES_SUPER;
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
