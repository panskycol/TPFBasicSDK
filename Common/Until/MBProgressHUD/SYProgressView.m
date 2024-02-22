//
//  SYProgressView.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/2.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYProgressView.h"
#import "MBProgressHUD.h"

@interface SYProgressView ()

@property (nonatomic, weak) MBProgressHUD *hudView;

@end

@implementation SYProgressView

+ (instancetype)shareInstance{
    static SYProgressView *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[SYProgressView alloc] init];
    });
    return obj;
}

+ (void)showProgressView{
    
    UIView *view = [self getCurrentViewController].view;
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [SYProgressView shareInstance].hudView = hudView;
    hudView.contentColor = [UIColor whiteColor];
    hudView.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hudView.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
}

/**
 *  显示MBProgressHUD和提示信息
 *
 *  @param message 提示信息
 *  @param canTouchBottomView 转圈期间下面的View是否还能操作
 */
+ (void)showProgressViewWithMessage:(NSString *)message
                    canTouchBottomView:(BOOL)canTouchBottomView {
    UIView *view = [self getCurrentViewController].view;
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [SYProgressView shareInstance].hudView = hudView;
    hudView.contentColor = [UIColor whiteColor];
    hudView.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hudView.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    hudView.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    hudView.label.textColor = [UIColor whiteColor];
    if (![NSString isNullString:message]) {
        hudView.label.text = message;
    }
    if (canTouchBottomView) {
        hudView.userInteractionEnabled = NO;
    }
}


/**
 *  显示MBProgressHUD和提示信息
 *
 *  @param message 提示信息
 */
+ (void)showProgressViewWithMessage:(NSString *)message
{
    UIView *window = [self getCurrentViewController].view;
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [SYProgressView shareInstance].hudView = hudView;
    hudView.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hudView.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    hudView.contentColor = [UIColor whiteColor];
    hudView.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    hudView.label.textColor = [UIColor whiteColor];
    if (![NSString isNullString:message]) {
        hudView.label.text = message;
    }
}

// 销毁progressView
+ (void)dismissProgressView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SYProgressView shareInstance].hudView hideAnimated:NO];
    });
}


/**
 *  显示MBProgressHUD和提示信息
 *
 *  @param message 提示信息
 */
+ (void)showProgressViewWithContentMessage:(NSString *)message withView:(UIView *)view
{
    if (!view) {
        return;
    }
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hudView.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hudView.contentColor = [UIColor whiteColor];
    hudView.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    hudView.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    hudView.label.textColor = [UIColor whiteColor];
    if (![NSString isNullString:message]) {
        hudView.label.text = message;
    }
}

// 销毁progressView
+ (void)dismissProgressViewWithView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 关闭网络请求状态
        if (!view) {
            return;
        }
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
}


@end
