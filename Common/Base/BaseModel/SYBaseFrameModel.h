//
//  SYBaseFrameModel.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/14.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYBaseModel.h"
#import <UIKit/UIKit.h>
#import <TPFBasicSDK/TPFBasicSDK.h>

/**
 *  构建控件的frame，view布局时会调用该block得到控件的frame
 *  @param  screenSize 屏幕的size，可以通过该size来判断是横屏还是竖屏
 *  @param  superViewSize 该控件的super view的size，可以通过该size，辅助该控件重新布局
 *  @param  frame 控件默认的位置
 *  @return 控件新设置的位置
 */
typedef CGRect(^SYBuildFrameBlock)(CGSize screenSize, CGSize superViewSize, CGRect frame);

typedef CGRect(^SYBuildViewFrameBlock)(CGSize superViewSize,UIView *referenceView, CGRect frame);

typedef MASConstraintMaker*(^SYBuildMASConstraintBlock)(MASConstraintMaker *make,UIView *superView, UIView *topView, UIView *leftView, UIView *bottomView, UIView *rightView);

NS_ASSUME_NONNULL_BEGIN

@interface SYBaseFrameModel : SYBaseModel

@end

NS_ASSUME_NONNULL_END
