//
//  SYCustomBaseView.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/14.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYBaseView.h"
//#import "SYBaseFrameModel.h"

@class SYBaseFrameModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYBaseCustomThemeView : SYBaseView

/// 设置默认的frameModel(必须调用)
/// - Parameter defaultClass: 子类对应的frameModel
- (void)setDefaultModelClass:(Class)defaultClass callback:(void(^)(id frameModel))callback;

- (void)updateFrameWithModel:(SYBaseFrameModel *)frameModel;

@end

NS_ASSUME_NONNULL_END
