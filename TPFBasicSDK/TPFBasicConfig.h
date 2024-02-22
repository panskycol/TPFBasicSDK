//
//  TPFBasicConfig.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/23.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPFBasicConfig : NSObject

#pragma mark - 配置信息
///APPKEY
@property (nonatomic, copy) NSString *appKey;
///APPID
@property (nonatomic, copy) NSString *appId;
///秘钥
@property (nonatomic, copy) NSString *appSecret;
///渠道ID
@property (nonatomic, copy) NSString *channelId;
///regionIndex
@property (nonatomic, copy) NSString *regionIndex;
///上报事件
@property (nonatomic, copy) NSString *eventAppKey;
///proxy
@property (nonatomic, copy) NSString *proxy;
//数据上报地址
@property (nonatomic, copy) NSString *dataReportUrl;
//游戏版本
@property (nonatomic, copy) NSString *appVersion;
//SDK主题
@property (nonatomic, copy) NSString *theme;
/// 事件回调给unity进行处理
/// method : 事件说明，类似于：OnCommonResult
/// json的内容 ：
/// {
///     "ErrorMsg"         :"success",
///     "ErrorCode"        :"0",
///     "CommonEventKey"   :"xxx",
///     "SdkErrCode"       :"xxx",
///     "SdkErrMsg"        :"xxx",
///     "Extra"            :{}
///}
@property (nonatomic, copy) void(^handleBlock)(NSString *method, NSString *json);

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
