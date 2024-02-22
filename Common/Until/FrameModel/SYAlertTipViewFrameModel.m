//
//  SYAlertTipViewFrameModel.m
//  TPFAccountSDK
//
//  Created by 呼啦 on 2022/11/17.
//

#import "SYAlertTipViewFrameModel.h"

@implementation SYAlertTipViewFrameModel

- (instancetype)init{
    
    self = [super init];
    if(self){
        [self initMASConstraint];
    }
    return self;
}

- (void)initMASConstraint{
    
    self.boxViewMASConstraintBlock = ^MASConstraintMaker *(MASConstraintMaker *make,UIView *superView, UIView *topView, UIView *leftView, UIView *bottomView, UIView *rightView) {
        make.width.equalTo(@280);
        make.center.equalTo(superView);
        return make;
    };
    
    self.contentViewMASConstraintBlock = ^MASConstraintMaker *(MASConstraintMaker *make,UIView *superView, UIView *topView, UIView *leftView, UIView *bottomView, UIView *rightView) {
        make.top.equalTo(superView).offset(30);
        make.left.equalTo(superView).offset(30);
        make.right.equalTo(superView).offset(-30);
        make.bottom.equalTo(bottomView.mas_top).offset(-20);
        return make;
    };
    
    self.confirmBtnMASConstraintBlock = ^MASConstraintMaker *(MASConstraintMaker *make,UIView *superView, UIView *topView, UIView *leftView, UIView *bottomView, UIView *rightView) {
        make.left.equalTo(topView);
        make.right.equalTo(topView);
        make.height.equalTo(@38);
        make.bottom.equalTo(superView).offset(-20);
        return make;
    };
}

@end
