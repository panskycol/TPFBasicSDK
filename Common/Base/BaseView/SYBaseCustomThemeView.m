//
//  SYCustomBaseView.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/14.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYBaseCustomThemeView.h"
#import "NSObject+CurrentViewController.h"
#import <objc/message.h>

@interface SYBaseCustomThemeView ()

@property (nonatomic, copy) NSString *defultModelString;

@property (nonatomic, strong) SYBaseFrameModel *obj;

@property (nonatomic, copy) void(^callback)(id obj);
@end

@implementation SYBaseCustomThemeView

+ (instancetype)alloc{

    NSString *myClassName = NSStringFromClass([self class]);
    NSString *preStr = @"SY";
    NSString *subStr = [myClassName substringFromIndex:preStr.length];
    NSString *newClasseName = [NSString stringWithFormat:@"%@%@%@",preStr,[TPFBasicConfig shareInstance].theme,subStr];
    Class newClass = NSClassFromString(newClasseName);
    if(newClass && ![myClassName isEqualToString:newClasseName]){
        //存在主题类，由对应主题的类来创建instance
        return [newClass alloc];
    }

    return [super alloc];
}

- (void)setDefaultModelClass:(Class)defaultClass callback:(nonnull void (^)(id _Nonnull))callback{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(semaphore,dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
    NSString *classStr = NSStringFromClass(defaultClass);
    if(![NSObject isNullString:classStr]){
        _defultModelString = classStr;
    }
    
    NSString *preStr = @"SY";
    NSString *subStr = [classStr substringFromIndex:preStr.length];
    
    //根据规则获取指定主题的配置model
    NSString *newClasseName = [NSString stringWithFormat:@"%@%@%@",preStr,[TPFBasicConfig shareInstance].theme,subStr];
    Class newClass = NSClassFromString(newClasseName);
    if(newClass){
        _obj = [[newClass alloc] init];
    }else{
        _obj = [[defaultClass alloc] init];
    }

    _callback = callback;
    if(callback){
        callback(_obj);
        dispatch_semaphore_signal(semaphore);
    }
}

- (void)updateFrameWithModel:(SYBaseFrameModel *)frameModel{

    _obj = frameModel;
    
    if(_callback){
        _callback(_obj);
    }
    
    [self layoutSubviews];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[NSObject getCurrentViewController].view endEditing:YES];
}

@end
