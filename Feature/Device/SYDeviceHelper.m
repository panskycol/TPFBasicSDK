//
//  SYDeviceHelper.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/5.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYDeviceHelper.h"
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "SAMKeychain.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "KeyChainManager.h"
#import "AFNetworking.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SYHttpHelper.h"
#import <WebKit/WebKit.h>

NSString * const SYUserTokenKey = @"userTokenKey";

@interface SYDeviceHelper ()

@property(nonatomic, strong) WKWebView *webView; // 强引用一下

@end

@implementation SYDeviceHelper

+ (instancetype)shareManager{
    
    static SYDeviceHelper *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[SYDeviceHelper alloc] init];
        [device initProperties];
    });
    return device;
}

+ (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)getIDFA{
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (ATTrackingManagerAuthorizationStatusAuthorized == status) {
                self.idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            }
        }];
    }else{
        if ([ASIdentifierManager.sharedManager isAdvertisingTrackingEnabled]) {
            self.idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
    }
}

+ (NSString *)getUDID{

    NSString *udid = [KeyChainManager readUUID];
    if (udid == nil) {
        NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [KeyChainManager saveUUID:deviceUUID];
        udid = [KeyChainManager readUUID];
    }
    return udid;
}


- (void)initProperties{
//    self.UNIFY_DOMAIN = [BasicConfig shareManager].PROXY;
//    self.UNIFY_NAMESPACE = [BasicConfig shareManager].REGION_INDEX;
    self.idfa = @"";
    self.deviceName = [SYDeviceHelper getDeviceName];
    self.jail = [self getJailBreak];
    self.opInfo = [NSString stringWithFormat:@"%@%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    self.osInfo = [UIDevice currentDevice].model == nil ? @"" :  [UIDevice currentDevice].model;
    self.deviceId = [SYDeviceHelper getUDID];
    [self getInternetStatus];
    [self getAppVersion];
    [self getua];
}

#pragma mark - 获取JailBreak
- (BOOL)getJailBreak{
    if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"cydia://"]])return YES;
    
    NSArray *jailArr = @[@"/Applications/Cydia.app",
                         @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                         @"/bin/bash",
                         @"/usr/sbin/sshd",
                         @"/etc/apt"];
    
    for (NSString *item in jailArr) {
        if ([NSFileManager.defaultManager fileExistsAtPath:item]) {
            return YES;
        }
    }
    
    if ([NSFileManager.defaultManager fileExistsAtPath:@"/User/Applications/"]) {
        return YES;
    }
    
    if (getenv("DYLD_INSERT_LIBRARIES") != nil) {
        return  YES;
    }
    return NO;
}

#pragma mark - 获取网络状态
- (void)getInternetStatus{
    [SYHttpManager monitorNetWorkStatus:^(AFNetworkReachabilityStatus status) {
        NSString *net = @"无网络";
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                net = @"WIFI";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                net = @"蜂窝数据";
                break;
            case AFNetworkReachabilityStatusUnknown:
                net = @"未识别的网络";
            default:
                break;
        }
        self.netStatus = net;
    }];
}

#pragma mark - 获取ua
-(void)getua{

    NSString *tpfUA=[[NSUserDefaults standardUserDefaults] objectForKey:@"TpfUA"];
    if (tpfUA.length>0) {
        self.ua=tpfUA;
        return;
    }
    /*获取系统的UA */
    self.webView=[[WKWebView alloc] initWithFrame:CGRectZero];
    [self.webView evaluateJavaScript:@"window.navigator.userAgent" completionHandler:^(id result, NSError *error){
        if(error==nil&& result!=nil){
            NSLog(@"ua-----%@",result);
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"TpfUA"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.ua=[NSString stringWithFormat:@"%@",result];
        }else{
            self.ua=@"";
        }
        self.webView=nil;
    }];
}

// =====  上面为原SDK字段，这种设备标识符不能改，必须按以前的规则，不然后台数据统计会乱  =========

/**
 获取IDFV

 @return IDFV
 */
+ (NSString *)getIDFV {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/**
 *  获取设备系统名称
 *
 *  @return 系统名称
 */
+ (NSString *)getDriverSystemName
{
    return [[UIDevice currentDevice] systemName];
}

/**
 *  获取用户设置的设备名称
 *
 *  @return 设备名称
 */
+ (NSString *)getDeviceName
{
    return [[UIDevice currentDevice] name];
}

/**
 *  获取设备系统版本
 *
 *  @return 系统版本
 */
+ (NSString *)getDriverSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

/**
 *  获取设备型号
 *
 *  @return 设备型号
 */
+ (NSString *)getDriverModel
{
    return [[UIDevice currentDevice] model];
}

/**
 *  获取设备Token
 *
 *  @return 设备Token
 */
+ (NSString *)getDriverToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SYUserTokenKey];
}

+ (void)setDeviceToken:(NSData *)deviceToken{
    
    NSMutableString *deviceTokenString = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    NSInteger iCount = deviceToken.length;
    for (int i = 0; i < iCount; i++) {
        [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:SYUserTokenKey];
}


+ (NSString *)getAppCertID{
    
    NSString *bundleid = [NSString stringWithFormat:@"%@.%@",[self getBundleId],SYKeyCommonDBKeyChainCompanyFlag];
    NSString *md5Bundleid = [self MD5ForLower32Bate:bundleid];
    NSString *md5service = [self MD5ForLower32Bate:SYKeyCommonDBKeyChainServiceName];
    NSString *certId = [SAMKeychain passwordForService:md5service account:md5Bundleid];
    
    if (!certId) {
        [self saveAppCertID];
        certId = [SAMKeychain passwordForService:md5service account:md5Bundleid];
    }
    
    return certId;
}

/**
 *  获取APP版本号（带点分割）
 *
 *  @return 返回版本号字符串
 */
- (NSString *)getAppVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    self.projectName = infoDic[@"CFBundleDisplayName"];
    
    _appVersion = infoDic[@"CFBundleShortVersionString"];

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *path = [NSString stringWithFormat:@"%@/SYResRoot/version.json",documentPath];
//    NSLog(@"externalPath-----%@",path);

    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSString *bundlePath=[[NSBundle mainBundle] bundlePath];
//        NSLog(@"bundlePath-----%@",bundlePath);
        path =[NSString stringWithFormat:@"%@/Data/Raw/SYResRoot/version.json",bundlePath];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
//        NSLog(@"version.json not exist---%@",path);
        return _appVersion;
    }
    NSData *data= [[NSData alloc] initWithContentsOfFile:path];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSLog(@"appversion-------%@",dic);
    NSString *resVersion = dic[@"ResVersion"];
    
    _appVersion=[NSString stringWithFormat:@"%@.%@",_appVersion,resVersion];
    
    return _appVersion;
}

- (NSString *)appVersion{
    
    return [self getAppVersion];
}


+ (NSString *)getBundleId
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}


- (NSString *)deviceId{
    _deviceId = [SYDeviceHelper getUDID];
    return _deviceId;
}

+ (BOOL)saveAppCertID{
    
    NSString *bundleid = [NSString stringWithFormat:@"%@.%@",[self getBundleId],SYKeyCommonDBKeyChainCompanyFlag];
    NSString *md5Bundleid = [self MD5ForLower32Bate:bundleid];
    NSString *md5service = [self MD5ForLower32Bate:SYKeyCommonDBKeyChainServiceName];
    NSString *certId = [SAMKeychain passwordForService:md5service account:md5Bundleid];
    
    if (!certId) {
        
        NSString *token = [self getDriverToken];
        NSString *appV = [[SYDeviceHelper shareManager] getAppVersion];
        NSString *osV = [self getDriverSystemVersion];
        NSString *osN = [self getDriverSystemName];
        NSString *device = [self getDriverModel];
        NSString *deviceN = [self getDeviceName];
        
        int randomNum = arc4random() % 100 + arc4random() % 500 + arc4random() % 1000;
        // 毫秒时间戳 + 一个随机数 + 设备各种信息
        NSString *timeStamp = [NSString stringWithFormat:@"%@.%d.%@.%@.%@.%@.%@.%@",[self getNowTimeTimestamp],randomNum,token,appV,osV,osN,device,deviceN];
        NSString *md5TimeStamp = [self MD5ForLower32Bate:timeStamp];
        
        BOOL success = [SAMKeychain setPassword:md5TimeStamp forService:md5service account:md5Bundleid];
        if (!success) {
            return NO;
        }
    }
    
    return YES;
}

// 毫秒基本
+(NSString *)getNowTimeTimestamp{    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}


+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

@end
