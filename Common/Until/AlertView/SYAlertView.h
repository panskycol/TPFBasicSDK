//
//  SYAlertView.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/9/15.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAlertView : UIView

/**
 *  显示AlertView
 *
 *  @param title       标题
 *  @param message     提示信息
 *  @param cancelTitle 取消按钮的标题
 *  @param titlesArray 每个按钮的标题
 *  @param clickBlock  点击按钮的回调
 */
+ (SYAlertView *)showAlertWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
             cancelButtonTitle:(nullable NSString *)cancelTitle
             otherButtonTitles:(nullable NSArray *)titlesArray
                    clickBlock:(nullable void(^)(NSInteger buttonIndex))clickBlock;



/// 添加关键字带颜色的弹窗
/// @param title 标题的Attribute
/// @param message 内容的attribute
/// @param sureHandler 确定回调，目前文案显示的是确定，后续有需求再拓展
/// @param cancelHandler 取消的回调，目前文案显示的是取消，后续有需求再拓展
+ (void)showAlertWithAttributeTitle:(nullable NSAttributedString *)title
                      attributeMessage:(nullable NSAttributedString *)message
                     cancelButtonTitle:(nullable NSString *)cancelTitle
                     otherButtonTitles:(nullable NSArray *)titlesArray
                           sureHandler:(nullable void(^)(NSInteger buttonIndex))sureHandler
                         cancelHandler:(nullable void(^)(void))cancelHandler;


/**
 撤回 ALertView
 */
+ (void)dismissAllAlertViewWithAnimate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
