//
//  SYWKWebView.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/18.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYWKWebView.h"
#import <WebKit/WebKit.h>
#import "YYWeakProxy.h"
#import <TPFBasicSDK/TPFBasicSDK.h>

@interface SYWKWebView ()<WKNavigationDelegate,WKScriptMessageHandler>

@end

@implementation SYWKWebView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperties];
    }
    return self;
}


- (void)initProperties{
    
    self.config = [[WKWebViewConfiguration alloc] init];
    self.userContentController = [[WKUserContentController alloc] init];
    self.config.userContentController = self.userContentController;

    self.wkWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:self.config];
    [self addSubview:self.wkWebView];
 
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    self.clearCache = NO;
    
    //web背景透明
//    self.backgroundColor = [UIColor clearColor];
//    self.opaque = NO;
    
    self.wkWebView.navigationDelegate = self;
//    [self.userContentController addScriptMessageHandler:self name:@"OnCallFunction"];
}

- (void)loadWebViewWithWebUrl:(NSString *)webUrlString params:(NSDictionary *)params{
    
    // 拼接参数
    NSMutableString *paramStr = [NSMutableString string];
    
    for (NSString *key in params.allKeys) {
        [paramStr appendString:[NSString stringWithFormat:@"&%@=%@",key,params[key]]];
    }
    
    if (paramStr.length > 0) {
        if ([webUrlString containsString:@"?"]) {
            _webUrlString = [NSString stringWithFormat:@"%@%@",webUrlString,paramStr];
        }else{
            NSString *subStr = [paramStr substringWithRange:NSMakeRange(1, paramStr.length - 1)];
            _webUrlString = [NSString stringWithFormat:@"%@?%@",webUrlString,subStr];
        }
        
    }else{
        _webUrlString = webUrlString;
    }
    
    // 是否清缓存
    if (_clearCache) {
        [self clearWebCache];
    }
    
    //开始加载
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.wkWebView loadRequest:request];
}


- (void)clearWebCache{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                WKWebsiteDataTypeDiskCache,
                                
                                WKWebsiteDataTypeOfflineWebApplicationCache,
                                
                                WKWebsiteDataTypeMemoryCache,
                                // 打开 local Storage 缓存
//                                WKWebsiteDataTypeLocalStorage,
                                
                                WKWebsiteDataTypeCookies,
                                
                                WKWebsiteDataTypeSessionStorage,
                                
                                WKWebsiteDataTypeIndexedDBDatabases,
                                
                                WKWebsiteDataTypeWebSQLDatabases
                                ]];
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        // Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

- (void)reloadRequest{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.wkWebView loadRequest:request];
}

#pragma mark - WKScriptMessageHandler--js点击事件
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if (_webDelete && [_webDelete respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [_webDelete userContentController:userContentController didReceiveScriptMessage:message];
    }
    
    if (_didReceiveScriptMessage) {
        _didReceiveScriptMessage(message);
    }
}

#pragma mark - WKNavigationDelegate
// 开始加载时
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    if (_webDelete && [_webDelete respondsToSelector:@selector(wkWebView:didStartProvisionalNavigation:)]) {
        [_webDelete wkWebView:webView didStartProvisionalNavigation:navigation];
    }
}

// 内容开始返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}

// 加载结束
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"");
    
    if (_webDelete && [_webDelete respondsToSelector:@selector(wkWebView:didFinishNavigation:)]) {
        [_webDelete wkWebView:webView didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    if (_webDelete && [_webDelete respondsToSelector:@selector(wkWebView:didFailProvisionalNavigation:withError:)]) {
        [_webDelete wkWebView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

// 点击跳转之前
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
        
    decisionHandler(WKNavigationActionPolicyAllow);
}
@end
