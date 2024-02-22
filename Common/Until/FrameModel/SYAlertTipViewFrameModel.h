//
//  SYAlertTipViewFrameModel.h
//  TPFAccountSDK
//
//  Created by 呼啦 on 2022/11/17.
//

#import "SYBaseFrameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAlertTipViewFrameModel : SYBaseFrameModel

@property (nonatomic, copy) SYBuildMASConstraintBlock boxViewMASConstraintBlock;
@property (nonatomic, copy) SYBuildMASConstraintBlock contentViewMASConstraintBlock;
@property (nonatomic, copy) SYBuildMASConstraintBlock confirmBtnMASConstraintBlock;

@end

NS_ASSUME_NONNULL_END
