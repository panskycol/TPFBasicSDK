//
//  SYProgressView.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/2.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYProgressView : NSObject

/**
 *  显示MBProgressHUD
 */
+ (void)showProgressView;

/**
 *  显示MBProgressHUD和提示信息
 *
 *  @param message 提示信息
 */
+ (void)showProgressViewWithMessage:(NSString *)message;

/**
 *  显示MBProgressHUD和提示信息
 *
 *  @param message 提示信息
 *  @param canTouchBottomView 转圈期间下面的View是否还能操作
 */
+ (void)showProgressViewWithMessage:(NSString *)message
                    canTouchBottomView:(BOOL)canTouchBottomView;

// 销毁progressView
+ (void)dismissProgressView;

/**
 *  显示MBProgressHUD和提示信息
 *
 *  @param message 提示信息
 */
+ (void)showProgressViewWithContentMessage:(NSString *)message withView:(UIView *)view;


// 销毁progressView
+ (void)dismissProgressViewWithView:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
