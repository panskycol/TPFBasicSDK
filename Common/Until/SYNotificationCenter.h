//
//  SYNotificationCenter.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/8.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYNotificationCenter : NSObject

/**
 *  发送通知
 *
 *  @param notiName 通知名称
 *  @param object   通知消息体
 */
+ (void)sendNotificationWithName:(nullable NSString *)notiName object:(nullable id)object;


// 添加注册通知
+ (void)addNotificationWithObserver:(nullable id)observer selector:(nullable SEL)selector name:(nullable NSString *)notiName object:(nullable id)object;

// 移除通知
+ (void)removeNotificationWithObserver:(nullable id)observer;

@end

NS_ASSUME_NONNULL_END
