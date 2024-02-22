//
//  SYAlertTipView.h
//  TPFAccountSDK
//
//  Created by 呼啦 on 2022/11/17.
//

#import <UIKit/UIKit.h>
#import "SYBaseCustomThemeView.h"

NS_ASSUME_NONNULL_BEGIN

/// 测试View
@interface SYAlertTipView : SYBaseCustomThemeView

+ (void)showAlertWithTip:(NSString *)tip confirmTitle:(NSString *)title callback:(nullable void(^)(void))callback;

@end

NS_ASSUME_NONNULL_END
