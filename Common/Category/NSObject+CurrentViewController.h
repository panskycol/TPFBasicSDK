//
//  NSObject+CurrentViewController.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/10/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CurrentViewController)

//获取当前控制器
+(UIViewController *)getCurrentViewController;

@end

NS_ASSUME_NONNULL_END
