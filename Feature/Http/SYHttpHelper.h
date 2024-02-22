//
//  SYHttpHelper.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/3.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+String.h"
#import "SYHttpManager.h"
#import "NSString+MD5.h"

NS_ASSUME_NONNULL_BEGIN

#define META_ERROR_MSG dataDict[@"meta"][@"errorMessage"]
#define META_ERROR_CODE dataDict[@"meta"][@"errorCode"]
#define META_DATA dataDict[@"data"]
#define HTTP_ERROR_MSG dataDict[@"msg"]

@interface SYHttpHelper : NSObject

#pragma mark - 网络状态
/// 检测网络状态
/// @param workStatus 网络状态实时回调
///
///  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
///  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
///  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 数据
///  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
///
+ (void)monitorNetWorkStatus:(void (^_Nullable)(AFNetworkReachabilityStatus status))workStatus;


/// 获取当前连接网络的状态
+ (AFNetworkReachabilityStatus)currentNetworkStatus;

#pragma mark - HTTP GET 请求

/// GET 请求 （默认30s超时）
+ (void)getRequestWithUrl:(NSString *_Nonnull)urlStr
                   params:(NSDictionary *_Nullable)params
                  headers:(NSDictionary *_Nullable)headers
                  success:(void (^)(NSDictionary *dataDict, int code))success
                  failure:(void (^)(NSDictionary *dataDict, int code))failure;


/// GET 请求 （默认30s超时）
/// @param interval 时间间隔
/// @param retryTimes 重试次数
+ (void)getRequestWithUrl:(NSString *_Nonnull)urlStr
                   params:(NSDictionary *_Nullable)params
                  headers:(NSDictionary *_Nullable)headers
            retryInterval:(NSInteger)interval
               retryTimes:(NSInteger)retryTimes
                  success:(void (^)(NSDictionary *dataDict, int code))success
                  failure:(void (^)(NSDictionary *dataDict, int code))failure;


#pragma mark - HTTP POST 请求

/// POST 请求 （默认30s超时）
+ (void)postRequestWithUrl:(NSString *_Nonnull)urlStr
                    params:(NSDictionary *_Nullable)params
                   headers:(NSDictionary *_Nullable)headers
                   success:(void (^)(NSDictionary *dataDict, int code))success
                   failure:(void (^)(NSDictionary *dataDict, int code))failure;


/// POST 请求 （默认30s超时）
/// @param interval 时间间隔
/// @param retryTimes 重试次数
+ (void)postRequestWithUrl:(NSString *_Nonnull)urlStr
                    params:(NSDictionary *_Nullable)params
                   headers:(NSDictionary *_Nullable)headers
             retryInterval:(NSInteger)interval
                retryTimes:(NSInteger)retryTimes
                   success:(void (^)(NSDictionary *dataDict, int code))success
                   failure:(void (^)(NSDictionary *dataDict, int code))failure;


///json格式的转发只检查sign
+ (void)postCheckSignSrcService:(NSString *)src
                          msgId:(NSString *)msgId
                         params:(NSDictionary *)params
                        success:(void (^)(NSDictionary *response, int code))success
                        failure:(void (^)(NSDictionary *dataDict, int code))failure;

@end

NS_ASSUME_NONNULL_END
