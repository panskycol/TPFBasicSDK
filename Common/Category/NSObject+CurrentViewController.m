//
//  NSObject+CurrentViewController.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/10/19.
//

#import "NSObject+CurrentViewController.h"

@implementation NSObject (CurrentViewController)

+ (UIViewController *)getCurrentViewController{
    
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

@end
