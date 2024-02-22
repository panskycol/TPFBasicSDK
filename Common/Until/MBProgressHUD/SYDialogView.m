//
//  SYDialogView.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/1.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYDialogView.h"
#import "MBProgressHUD.h"

@interface  SYDialogView ()

@property (nonatomic, weak) MBProgressHUD *hud;

@end

@implementation SYDialogView

+ (instancetype)shareInstance{
    static SYDialogView *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[SYDialogView alloc] init];
    });
    return obj;
}

+ (void)showDialog:(NSString *)message{
    UIView *view = [self getCurrentViewController].view;
    if(!view){
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0.f, 0);
    [SYDialogView shareInstance].hud = hud;
    [hud hideAnimated:YES afterDelay:1.5f];
}


+ (void)showDialog:(NSString *)message rootView:(UIView *)rootView{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:rootView animated:YES];
    [SYDialogView shareInstance].hud = hud;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0.f, 0);

    [hud hideAnimated:YES afterDelay:1.5f];
}

+ (void)showDialog:(NSString *)message autoDismiss:(BOOL)autoDismiss{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
    [SYDialogView shareInstance].hud = hud;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0.f, 0);

    [hud hideAnimated:autoDismiss afterDelay:1.5f];
}

+ (void)showDialog:(NSString *)message autoDismissTime:(CGFloat)autoDismissTime{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
    [SYDialogView shareInstance].hud = hud;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0.f, 0);

    [hud hideAnimated:YES afterDelay:autoDismissTime];
}

+ (void)dismissDialog{
    
    [[SYDialogView shareInstance].hud hideAnimated:NO];
}

@end
