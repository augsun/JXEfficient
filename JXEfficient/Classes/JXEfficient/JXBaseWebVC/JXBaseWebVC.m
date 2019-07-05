//
//  JXBaseWebVC.m
//  JXEfficient
//
//  Created by augsun on 2/21/19.
//

#import "JXBaseWebVC.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"
#import "JXInline.h"
#import "UIView+JXToastAndProgressHUD.h"
#import "UIViewController+JXCategory.h"
#import "JXChowder.h"
#import "JXSystemAlert.h"

#import "JXBaseWebVCScriptMessageHandler.h"

// 观察 WKWebView 的 keyPath
static NSString *const obr_title = @"title";

// 原生与H5交互的方法
static NSString *const js_closeWebPage = @"closeWebPage"; ///< 关闭页面

@interface JXBaseWebVC ()

@property (nonatomic, strong) JXBaseWebVCScriptMessageHandler *scriptMessageHandler;
@property (nonatomic, strong) NSMutableArray <NSString *> *scriptMessageHandlerNames;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, assign) BOOL webDidLoaded;
@property (nonatomic, assign) BOOL autoRefresh;

@property (nonatomic, strong) NSMutableArray <NSString *> *alertMessages;

@property (nonatomic, assign) BOOL loginVCPresented; // 已经弹出了登录页面, 防止 h5 重复调用.

@property (nonatomic, assign) BOOL didLoadedWebview;

@end

@implementation JXBaseWebVC

- (instancetype)init {
    self = [super init];
    if (self) {
        
        //
        if (@available(iOS 11.0, *)) {
            [UIScrollView appearanceWhenContainedInInstancesOfClasses:@[[self class]]].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //
        _autoRefresh = NO;
        _goBackWebViewPriority = YES;
        _alertMessages = [[NSMutableArray alloc] init];
        _scriptMessageHandlerNames = [[NSMutableArray alloc] init];
        
        //
        WKWebViewConfiguration *cfg = [[WKWebViewConfiguration alloc] init];
        self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:cfg];
        self.webView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.webView jx_con_diff:NSLayoutAttributeTop equal:self.naviView att2:NSLayoutAttributeBottom m:1.0 c:0.0],
                                                  [self.webView jx_con_same:NSLayoutAttributeLeft equal:self.view m:1.0 c:0.0],
                                                  [self.webView jx_con_same:NSLayoutAttributeRight equal:self.view m:1.0 c:0.0],
                                                  [self.webView jx_con_same:NSLayoutAttributeBottom equal:self.view m:1.0 c:-JX_UNUSE_AREA_OF_BOTTOM],
                                                  ]
         ];
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        [self.webView addObserver:self forKeyPath:obr_title options:NSKeyValueObservingOptionNew context:nil];
        
        //
        self.scriptMessageHandler = [[JXBaseWebVCScriptMessageHandler alloc] init];
        JX_WEAK_SELF;
        self.scriptMessageHandler.didReceiveScriptMessage = ^(NSString * _Nonnull name, id  _Nullable body) {
            JX_STRONG_SELF;
            [self didReceiveScriptMessage:name body:body];
        };
        
        //
        [self addScriptMessageHandlerName:js_closeWebPage];
        
    }
    return self;
}

- (void)addScriptMessageHandlerName:(NSString *)name {
    name = jx_strValue(name);
    if (name.length == 0 || [self.scriptMessageHandlerNames containsObject:name]) {
        return;
    }
    [self.scriptMessageHandlerNames addObject:name];
    [self.webView.configuration.userContentController addScriptMessageHandler:self.scriptMessageHandler name:name];
}

// ====================================================================================================

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.naviView = [JXNaviView naviView];
    [self.view addSubview:self.naviView];
    self.naviView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.naviView jx_con_same:NSLayoutAttributeTop equal:self.view m:1.0 c:0.0],
                                              [self.naviView jx_con_same:NSLayoutAttributeLeft equal:self.view m:1.0 c:0.0],
                                              [self.naviView jx_con_same:NSLayoutAttributeRight equal:self.view m:1.0 c:0.0],
                                              [self.naviView jx_con_same:NSLayoutAttributeHeight equal:nil m:1.0 c:0.0],
                                              ]
     ];
    JX_WEAK_SELF;
    [self.naviView setBackClick:^{
        JX_STRONG_SELF;
        [self leftBtnClick];
    }];
    
    //
    [self.view addSubview:self.webView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)dealloc {
    for (NSString *nameEnum in self.scriptMessageHandlerNames) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:nameEnum];
    }
    [self.webView removeObserver:self forKeyPath:obr_title];
}

// ====================================================================================================
#pragma mark -

- (void)titleDidChange:(NSString *)title {
    
}

- (void)loadWithURLString:(NSString *)URLString {
    [self.view jx_showProgressHUD:@"加载中" animation:NO];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *req = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:req];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:obr_title] && object == self.webView) {
        NSString *title = jx_strValue([change objectForKey:NSKeyValueChangeNewKey]);
        if (title.length > 0) {
            self.naviView.title = title;
            [self titleDidChange:title];
        }
    }
}

#pragma mark 返回按钮事件捕捉
- (void)leftBtnClick {
    if (self.webView.canGoBack && self.goBackWebViewPriority) {
        [self.webView goBack];
    }
    else {
        [self jx_popVC];
    }
}

#pragma mark 返回手势捕捉
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] && self.webView.canGoBack && self.goBackWebViewPriority) {
        [self.webView goBack];
        return NO;
    }
    return YES;
}

#pragma mark 收到 js 调用
- (void)didReceiveScriptMessage:(NSString *)name body:(id)body {
    __unused NSDictionary *bodyDic = jx_dicValue(body);
    
    // 关闭页面
    if ([name isEqualToString:js_closeWebPage]) {
        [self jx_popVC];
    }
    
    // 子类继续实现
}

#pragma mark <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.webDidLoaded = NO;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view jx_hideProgressHUD:YES];
    self.webDidLoaded = YES;
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    self.URL = webView.URL;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error {
    [self.view jx_hideProgressHUD:YES];
    [self.view jx_showToast:[JXChowder msgForNetError:error defaultMsg:@"加载失败"] animated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //
    if (![navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
        !decisionHandler ? : decisionHandler(WKNavigationResponsePolicyAllow);
        return;
    }
    
    //
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSInteger statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
        !decisionHandler ? : decisionHandler(WKNavigationResponsePolicyAllow);
    }
    else {
        !decisionHandler ? : decisionHandler(WKNavigationResponsePolicyCancel);
    }
}

#pragma mark <WKUIDelegate>
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (message.length > 0) {
        [self.alertMessages addObject:message];
        [self showAlert];
    }
    !completionHandler ? : completionHandler();
}

#pragma mark 显示 Alert
- (void)showAlert {
    NSString *message = self.alertMessages.firstObject;
    if (!message) {
        return ;
    }
    [JXSystemAlert alertFromVC:self title:nil message:message defaultTitle:@"确定" defaultHandler:^{
        [self.alertMessages removeObject:message];
        [self showAlert];
    }];
}

@end
