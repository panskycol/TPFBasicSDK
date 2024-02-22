//
//  SYHttpManager.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/3.
//

#import "SYHttpManager.h"

@implementation SYHttpManager

#pragma mark - 网络状态
+ (void)monitorNetWorkStatus:(void (^)(AFNetworkReachabilityStatus))workStatus{
    
    // 启动检测管理器的单例的startMonitoring监测网络状态的变化
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 监测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(workStatus) workStatus(status);
    }];
}

+ (AFNetworkReachabilityStatus)currentNetworkStatus{
    
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

#pragma mark - HTTP GET 请求
+ (NSURLSessionDataTask *)httpGetRequestWithUrl:(NSString *)urlStr
                                         params:(NSDictionary *)params
                                        headers:(NSDictionary *)headers
                                        success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                                        failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure{
    
    // 响应序列的内容类型
    NSArray *contentTypes = [NSArray arrayWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    
    // 执行HTTP请求
    return [self httpGetRequestWithUrl:urlStr params:params headers:headers timeout:30 requestType:JSONRequestType responseType:HTTPResponseType contentTypes:contentTypes success:success failure:failure];
}


+ (NSURLSessionDataTask *)httpGetRequestWithUrl:(NSString *)urlStr
                                         params:(NSDictionary *)params
                                        headers:(NSDictionary *)headers
                                        timeout:(float)timeout
                                    requestType:(RequestType)requestType
                                   responseType:(ResponseType)responseType
                                   contentTypes:(NSArray *)contentTypes
                                        success:(void (^)(NSURLSessionDataTask *, id _Nonnull))success
                                        failure:(void (^)(NSURLSessionDataTask *, NSError * _Nonnull))failure{
    // 空值判断
    if ([NSObject isNullString:urlStr]) {
        NSLog(@"--->HTTP GET请求错误，url为空");
        if (failure) failure(nil, [NSError errorWithDomain:@"HTTP GET请求错误，url为空" code:ERROR_NULL_CODE userInfo:nil]);
        return nil;
    }
    
    // 打印HTTP请求的URL
    [self printHttpWithUrl:urlStr params:params];
    NSLog(@"GET headers:\n%@\n", headers);
    
    // 创建HTTP操作管理对象
    AFHTTPSessionManager *httpManager = [self creatHttpManagerWithRequestType:requestType responseType:responseType contentTypes:contentTypes timeout:timeout];
    
    NSURLSessionDataTask *task = [httpManager GET:urlStr parameters:params headers:headers progress:nil success:success failure:failure];
    
    // 返回请求对象
    return task;
}

#pragma mark - HTTP POST 请求
+ (NSURLSessionDataTask *)httpPostRequestWithUrl:(NSString *)urlStr
                                          params:(NSDictionary *)params
                                         headers:(NSDictionary *)headers
                                         success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                                         failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure{
    
    // 响应序列的内容类型
    NSArray *contentTypes = [NSArray arrayWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    
    // 执行HTTP请求
    return [self httpPostRequestWithUrl:urlStr params:params headers:headers timeout:30 requestType:JSONRequestType responseType:HTTPResponseType contentTypes:contentTypes success:success failure:failure];
}


+ (NSURLSessionDataTask *)httpPostRequestWithUrl:(NSString *)urlStr
                                          params:(NSDictionary *)params
                                         headers:(NSDictionary *)headers
                                         timeout:(float)timeout
                                     requestType:(RequestType)requestType
                                    responseType:(ResponseType)responseType
                                    contentTypes:(NSArray *)contentTypes
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    
    // 空值判断
    if ([NSObject isNullString:urlStr]) {
        NSLog(@"--->HTTP POST请求错误，url为空");
        if (failure) failure(nil, [NSError errorWithDomain:@"HTTP POST请求错误，url为空" code:ERROR_NULL_CODE userInfo:nil]);
        return nil;
    }
    
    // 打印HTTP请求的URL
    [self printHttpWithUrl:urlStr params:params];
    NSLog(@"POST headers:\n%@\n", headers);
    
    // 创建HTTP操作管理对象
    AFHTTPSessionManager *httpManager = [self creatHttpManagerWithRequestType:requestType responseType:responseType contentTypes:contentTypes timeout:timeout];
    
    // 执行HTTP POST请求
    NSURLSessionDataTask *task = [httpManager POST:urlStr parameters:params headers:headers progress:nil success:success failure:failure];
    
    // 返回请求对象
    return task;

    
}


#pragma mark - 工具方法
/// 打印HTTP请求的URL地址
/// @param url    URL地址
/// @param params 参数
+ (void)printHttpWithUrl:(NSString *)url params:(NSDictionary *)params
{
    // 空值判断
    if ([NSObject isNullString:url]) {
        NSLog(@"--->打印URL信息错误，url参数为空");
        return;
    }
    
    // 拼接Http请求地址
    NSString *strUrl = [self getHttUrl:url params:params];
    
    // 打印URL
    NSLog(@"--->URL:\n%@",strUrl);
}


/// 拼接Http请求地址
/// @param url    URL地址
/// @param params 参数
+ (NSString *)getHttUrl:(NSString *)url params:(NSDictionary *)params
{
    // 空值判断
    if ([NSObject isNullString:url]) {
        NSLog(@"--->拼接Http请求地址错误，url参数为空");
        return nil;
    }
    
    // 拼接URL字符串
    NSMutableString *strUrl = [[NSMutableString alloc] initWithString:url];
    
    // 拼接请求参数
    NSMutableString *strParams = [[NSMutableString alloc] init];
    if (![NSObject isNullDictonary:params]) {
        for (NSString *key in [params allKeys]) {
            NSString *value = [params valueForKey:key];
            if ([strParams length] > 0) {
                [strParams appendFormat:@"&"];
            }
            [strParams appendFormat:@"%@=%@", key, value];
        }
    }
    
    // 如果参数不为空，则追加参数信息
    if (strParams.length > 0 ) {
        [strUrl containsString:@"?"] ? [strUrl appendString:@"&"] : [strUrl appendString:@"?"];
        [strUrl appendString:strParams];
    }
    
    return strUrl;
}

/// 创建HTTP操作管理对象
/// @param requestType  请求序列化类型
/// @param responseType 响应序列化类型
/// @param contentTypes 响应序列的内容类型数组
/// @param timeout      超时时间
/// @return NSURLSessionDataTaskManager对象
+ (AFHTTPSessionManager *)creatHttpManagerWithRequestType:(RequestType)requestType responseType:(ResponseType)responseType contentTypes:(NSArray *)contentTypes timeout:(float)timeout
{
    // 构建一个AFHTTP管理器
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    
    // 设置请求序列化格式
    httpManager.requestSerializer = [self requestSerializerWithType:requestType];
    
    // 设置响应序列化格式
    httpManager.responseSerializer = [self responseSerializerWithType:responseType];
    
    // 设置服务器返回的数据格式(如果提示格式不匹配需要进行修改)
    if (![NSObject isNullArray:contentTypes]) {
        // @"application/json", @"text/json", @"text/plain", @"text/html"
        httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypes];
    }
    
    // 设置超时时间
    if (timeout > 0) {
        [httpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        httpManager.requestSerializer.timeoutInterval = timeout;
        [httpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return httpManager;
}


/// 获取请求序列化格式对象
/// @param requestType 请求序列化类型
/// @return 序列化对象
+ (AFHTTPRequestSerializer *)requestSerializerWithType:(RequestType)requestType {
    switch (requestType) {
        case HTTPRequestType:   // 二进制格式
            return [AFHTTPRequestSerializer serializer];
            break;
        case JSONRequestType:   // JSON方式
            return [AFJSONRequestSerializer serializer];
            break;
        case PlistRequestType:  // 集合文件方式
            return [AFPropertyListRequestSerializer serializer];
            break;
        default:                // 二进制格式
            return [AFHTTPRequestSerializer serializer];
            break;
    }
}


/// 获取响应序列化格式对象
/// @param responseType 响应序列化类型
/// @return 序列化对象
+ (AFHTTPResponseSerializer *)responseSerializerWithType:(ResponseType)responseType {
    switch (responseType) {
        case HTTPResponseType:      // 二进制格式
            return [AFHTTPResponseSerializer serializer];
            break;
        case JSONResponseType:      // JSON方式
            return [AFJSONResponseSerializer serializer];
            break;
        case PlistResponseType:     // 集合文件方式
            return [AFPropertyListResponseSerializer serializer];
            break;
        case ImageResponseType:     // 图片方式
            return [AFImageResponseSerializer serializer];
            break;
        case CompoundResponseType:  // 组合方式
            return [AFCompoundResponseSerializer serializer];
            break;
        default:                    // 二进制格式
            return [AFHTTPResponseSerializer serializer];
            break;
    }
}



@end
