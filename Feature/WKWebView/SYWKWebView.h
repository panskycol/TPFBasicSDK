//
//  SYWKWebView.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/18.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYWKWebViewDelegate <NSObject>

// 内容开始加载
- (void)wkWebView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;

// 内容加载结束
- (void)wkWebView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

// 加载失败
- (void)wkWebView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;

// js点击事件
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end


@interface SYWKWebView : UIView

// webView 的配置
@property (nonatomic, strong) WKWebViewConfiguration *config;

// 用来注册js事件
@property (nonatomic, strong) WKUserContentController *userContentController;

// 网址
@property (nonatomic, copy, readonly) NSString *webUrlString;

// 显示内容
@property (nonatomic, strong) WKWebView *wkWebView;

// 打开的时候是否需要清除緩存
@property (nonatomic, assign) BOOL clearCache;

@property (nonatomic, weak) id<SYWKWebViewDelegate> webDelete;

// 开始加载网页的回调
@property (nonatomic, copy) void(^didReceiveScriptMessage)(WKScriptMessage *message);

/// 加载，配置网页链接
/// @param webUrlString url
/// @param params 参数
- (void)loadWebViewWithWebUrl:(nonnull NSString *)webUrlString params:(nullable NSDictionary *)params;

/// 清楚缓存
- (void)clearWebCache;

- (void)reloadRequest;
@end

NS_ASSUME_NONNULL_END
