//
//  SYHttpManager.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/3.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "NSObject+Null.h"
#import "SYHttpMacro.h"

NS_ASSUME_NONNULL_BEGIN

// 请求序列化格式
typedef enum : NSUInteger {
    JSONRequestType  = 0,      // JSON方式 (尚游后台，不设置的话为默认格式)
    HTTPRequestType  = 1,      // 二进制格式
    PlistRequestType = 2,      // 集合文件方式
} RequestType;


// 响应序列化格式
typedef enum : NSUInteger {
    JSONResponseType     = 0,  // JSON方式
    HTTPResponseType     = 1,  // 二进制格式  (尚游后台，不设置的话为默认格式)
    PlistResponseType    = 2,  // 集合文件方式
    ImageResponseType    = 3,  // 图片方式
    CompoundResponseType = 4,  // 组合方式
} ResponseType;


@interface SYHttpManager : NSObject

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
/// @param urlStr 请求URL
/// @param params 请求参数
/// @param headers 头部字段
/// @param success 成功回调
/// @param failure 失败回调
+ (NSURLSessionDataTask *)httpGetRequestWithUrl:(NSString *_Nonnull)urlStr
                                         params:(NSDictionary *_Nullable)params
                                        headers:(NSDictionary *_Nullable)headers
                                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


///  HTTP GET网络请求（定制化GET请求）
///
///  @param urlStr       URL字符串
///  @param params       参数字典
///  @param timeout      超时时间
///  @param requestType  请求序列化类型
///  @param responseType 响应序列化类型
///  @param contentTypes 响应序列的内容类型数组
///  @param success      成功回调
///  @param failure      失败回调
///
///  @return NSURLSessionDataTask对象
+ (NSURLSessionDataTask *)httpGetRequestWithUrl:(NSString *_Nonnull)urlStr
                                         params:(NSDictionary *_Nullable)params
                                        headers:(NSDictionary *_Nullable)headers
                                        timeout:(float)timeout
                                    requestType:(RequestType)requestType
                                   responseType:(ResponseType)responseType
                                   contentTypes:(NSArray *_Nullable)contentTypes
                                        success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - HTTP POST 请求
/// POST 请求 （默认30s超时）
/// @param urlStr 请求URL
/// @param params 请求参数
/// @param headers 头部字段
/// @param success 成功回调
/// @param failure 失败回调
+ (NSURLSessionDataTask *)httpPostRequestWithUrl:(NSString *_Nonnull)urlStr
                                          params:(NSDictionary *_Nullable)params
                                         headers:(NSDictionary *_Nullable)headers
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


///  HTTP POST网络请求（定制化GET请求）
///
///  @param urlStr       URL字符串
///  @param params       参数字典
///  @param timeout      超时时间
///  @param requestType  请求序列化类型
///  @param responseType 响应序列化类型
///  @param contentTypes 响应序列的内容类型数组
///  @param success      成功回调
///  @param failure      失败回调
///
///  @return NSURLSessionDataTask对象
+ (NSURLSessionDataTask *)httpPostRequestWithUrl:(NSString *_Nonnull)urlStr
                                          params:(NSDictionary *_Nullable)params
                                         headers:(NSDictionary *_Nullable)headers
                                         timeout:(float)timeout
                                     requestType:(RequestType)requestType
                                    responseType:(ResponseType)responseType
                                    contentTypes:(NSArray *_Nullable)contentTypes
                                         success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 数据上传

#pragma mark - 数据下载

@end

NS_ASSUME_NONNULL_END
