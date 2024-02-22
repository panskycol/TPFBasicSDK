//
//  SYDeviceHelper.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/5.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYDBConst.h"

// 用户token
extern NSString * _Nonnull const SYUserTokenKey;

NS_ASSUME_NONNULL_BEGIN

@interface SYDeviceHelper : NSObject

// ===============   原SDK字段   ==================
///服务Host
//@property (nonatomic, copy) NSString *UNIFY_DOMAIN;
/////服务器的命名空间
//@property (nonatomic, copy) NSString *UNIFY_NAMESPACE;
///设备ID
@property (nonatomic, copy) NSString *deviceId;
///设备名字
@property (nonatomic, copy) NSString *deviceName;
///IDFA
@property (nonatomic, copy) NSString *idfa;
///获取ua
@property (nonatomic, copy) NSString *ua;
///系统版本
@property (nonatomic, copy) NSString *opInfo;
///网络状态
@property (nonatomic, copy) NSString *netStatus;
///app版本号
@property (nonatomic, copy) NSString *appVersion;
///项目名字
@property (nonatomic, copy) NSString *projectName;
///获取osInfo
@property (nonatomic, copy) NSString *osInfo;
///越狱
@property (nonatomic, assign) BOOL jail;

+ (instancetype)shareManager;

- (void)getIDFA;

/// 包括游戏热更的版本号
- (NSString *)getAppVersion;

/// 震动
+ (void)vibrate;

+ (NSString *)getUDID;
// ===============   原SDK字段   ==================

///获取该应用在设备上的唯一id （保存在钥匙串，卸载重装不会变）
+ (NSString *)getAppCertID;

///保存应用在设备上的唯一的id （保存在钥匙串，卸载重装不会变）
+ (BOOL)saveAppCertID;

+ (NSString *)getDriverSystemName;

+ (NSString *)getDriverSystemVersion;

///获取设备型号
+ (NSString *)getDriverModel;

+ (void)setDeviceToken:(NSData *)deviceToken;

+ (NSString *)getDriverToken;

+ (NSString *)getDeviceName;

+ (NSString *)getBundleId;

+ (NSString *)getNowTimeTimestamp;


@end

NS_ASSUME_NONNULL_END
