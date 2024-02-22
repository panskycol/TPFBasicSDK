//
//  SYNotificationCenter.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/8.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYNotificationCenter.h"

@implementation SYNotificationCenter

/**
 *  发送通知
 *
 *  @param notiName 通知名称
 *  @param object   通知消息体
 */
+ (void)sendNotificationWithName:(nullable NSString *)notiName object:(nullable id)object
{
    // 通知名称不能为空
    if ([NSObject isNullString:notiName]) {
        return;
    }
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:object];
}


// 添加注册通知
+ (void)addNotificationWithObserver:(nullable id)observer selector:(nullable SEL)selector name:(nullable NSString *)notiName object:(nullable id)object
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:notiName object:object];
}


// 移除通知
+ (void)removeNotificationWithObserver:(nullable id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
