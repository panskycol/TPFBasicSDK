//
//  SYDialogView.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/1.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/////**************************** TOAST提示  ****************************///////
@interface SYDialogView : NSObject

/**
 *  显示DialogView, 1.5秒后自动消失
 *
 *  @param message 消息内容
 */
+(void)showDialog:(NSString*)message;

/**
 *  显示DialogView, 2秒后自动消失
 *
 *  @param message 消息内容
 */
+ (void)showDialog:(NSString*)message rootView:(UIView *)rootView;

/**
 *  显示DialogView
 *
 *  @param message     消息内容
 *  @param autoDismiss 是否自动消失
 */
+(void)showDialog:(NSString*)message autoDismiss:(BOOL)autoDismiss;

/**
 *  显示DialogView
 *
 *  @param message     消息内容
 *  @param autoDismissTime 多少秒自动消失
 */
+(void)showDialog:(NSString*)message autoDismissTime:(CGFloat)autoDismissTime;

/**
 *  销毁DialogView
 */
+(void)dismissDialog;

@end

NS_ASSUME_NONNULL_END
