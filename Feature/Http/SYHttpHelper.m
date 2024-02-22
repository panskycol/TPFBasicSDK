//
//  SYHttpHelper.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/3.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYHttpHelper.h"
#import <TPFBasicSDK/TPFBasicSDK.h>

@implementation SYHttpHelper

+ (void)monitorNetWorkStatus:(void (^)(AFNetworkReachabilityStatus))workStatus{
    
    [SYHttpManager monitorNetWorkStatus:workStatus];
}

+ (AFNetworkReachabilityStatus)currentNetworkStatus{
    
    return [SYHttpManager currentNetworkStatus];
}

#pragma mark - GET
+ (void)getRequestWithUrl:(NSString *)urlStr
                   params:(NSDictionary *)params
                  headers:(NSDictionary *)headers
                  success:(void (^)(NSDictionary * _Nonnull, int))success
                  failure:(void (^)(NSDictionary * _Nonnull, int))failure{
    
    [SYHttpManager httpGetRequestWithUrl:urlStr params:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [self dealWithSuccessResultWithResponse:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSString *errorMsg = error.userInfo[@"NSLocalizedDescription"];
        if([NSObject isNullString:errorMsg]){
            errorMsg = @"";
        }
        NSLog(@"--->GET请求失败，error:%@;\n request:%@;\n response:%@", error, task.originalRequest, task.response);
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@(error.code), @"code", errorMsg, @"msg", nil];
        if (failure) failure(dataDict, (int)error.code);
    }];
}

+ (void)getRequestWithUrl:(NSString *)urlStr
                   params:(NSDictionary *)params
                  headers:(NSDictionary *)headers
            retryInterval:(NSInteger)interval
               retryTimes:(NSInteger)retryTimes
                  success:(void (^)(NSDictionary * _Nonnull, int))success
                  failure:(void (^)(NSDictionary * _Nonnull, int))failure{
    
    [SYHttpManager httpGetRequestWithUrl:urlStr params:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [self dealWithSuccessResultWithResponse:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (retryTimes > 0) {
            NSLog(@"--->GET请求失败, 网络错误, 3秒后重新尝试");
            // 如果重试次数大于0, 则在3秒后重试
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getRequestWithUrl:urlStr params:params headers:headers retryInterval:interval retryTimes:retryTimes-1 success:success failure:failure];
            });
        }else{
            NSString *errorMsg = error.userInfo[@"NSLocalizedDescription"];
            if([NSObject isNullString:errorMsg]){
                errorMsg = @"";
            }
            NSLog(@"--->GET请求失败，error:%@;\n request:%@;\n response:%@", error, task.originalRequest, task.response);
            NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@(error.code), @"code", errorMsg, @"msg", nil];
            if (failure) failure(dataDict, (int)error.code);
        }
    }];
}


#pragma mark - POST
+ (void)postRequestWithUrl:(NSString *)urlStr
                    params:(NSDictionary *)params
                   headers:(NSDictionary *)headers
                   success:(void (^)(NSDictionary * _Nonnull, int))success
                   failure:(void (^)(NSDictionary * _Nonnull, int))failure{
    
    [SYHttpManager httpPostRequestWithUrl:urlStr params:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [self dealWithSuccessResultWithResponse:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSString *errorMsg = error.userInfo[@"NSLocalizedDescription"];
        if([NSObject isNullString:errorMsg]){
            errorMsg = @"";
        }
        NSLog(@"--->POST请求失败，error:%@;\n request:%@;\n response:%@", error, task.originalRequest, task.response);
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@(error.code), @"code", errorMsg, @"msg", nil];
        if (failure) failure(dataDict, (int)error.code);
    }];
}

+ (void)postRequestWithUrl:(NSString *)urlStr
                    params:(NSDictionary *)params
                   headers:(NSDictionary *)headers
             retryInterval:(NSInteger)interval
                retryTimes:(NSInteger)retryTimes
                   success:(void (^)(NSDictionary * _Nonnull, int))success
                   failure:(void (^)(NSDictionary * _Nonnull, int))failure{
    
    [SYHttpManager httpPostRequestWithUrl:urlStr params:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [self dealWithSuccessResultWithResponse:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (retryTimes > 0) {
            NSLog(@"--->POST请求失败, 网络错误, 3秒后重新尝试");
            
            // 如果重试次数大于0, 则在3秒后重试
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self postRequestWithUrl:urlStr params:params headers:headers retryInterval:interval retryTimes:retryTimes-1 success:success failure:failure];
            });
        }else{
            NSString *errorMsg = error.userInfo[@"NSLocalizedDescription"];
            if([NSObject isNullString:errorMsg]){
                errorMsg = @"";
            }
            NSLog(@"--->POST请求失败，error:%@;\n request:%@;\n response:%@", error, task.originalRequest, task.response);
            NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@(error.code), @"code", errorMsg, @"msg", nil];
            if (failure) failure(dataDict, (int)error.code);
        }
    }];
}

///json格式的转发只检查sign
+ (void)postCheckSignSrcService:(NSString *)src
                          msgId:(NSString *)msgId
                         params:(NSDictionary *)params
                        success:(void (^)(NSDictionary *response, int code))success
                        failure:(nonnull void (^)(NSDictionary * _Nonnull, int))failure{
    
    NSDictionary *body = @{
        @"srcService" : src,
        @"msgId" : msgId,
        @"msgContent" : @[params].convertToJsonString,
    };
    NSString *bodyJsonStr = body.converToString;
    NSString *contentMd5 = [NSString base64EncodedString:bodyJsonStr];
    
    NSString *headSign = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                          [TPFBasicConfig shareInstance].appId,
                          msgId,
                          contentMd5,
                          [TPFBasicConfig shareInstance].appSecret];
    headSign = [NSString md5String:headSign];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    headers[@"X-Tpf-App-Id"] = [TPFBasicConfig shareInstance].appId;
    headers[@"X-Tpf-Signature"] = headSign;
    NSString *url = [NSString stringWithFormat:@"%@%@",[TPFBasicConfig shareInstance].proxy,BASIC_CHANNEL_AUTH];
    
    [self postRequestWithUrl:url params:body headers:headers success:^(NSDictionary * _Nonnull dataDict, int code) {
        
        if(success){
            NSDictionary *msgContent = [dataDict[@"msgContent"] converToDictionary];
            success(msgContent,code);
        }
        
    } failure:^(NSDictionary * _Nonnull dataDict, int code) {
       
        if(failure){
            failure(dataDict, code);
        }
    }];
}

#pragma mark - 公共方法
/// 处理成功响应
+ (void)dealWithSuccessResultWithResponse:(NSData *)responseObject success:(void (^)(NSDictionary * _Nonnull, int))success failure:(void (^)(NSDictionary * _Nonnull, int))failure{
    
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    
    // 这里只查找到二级的结构，不进行递归查找, 出现超过二级的code，使用的地方自行解决
    NSString *resultCode = [self getResultCode:response];
    int code = MAXFLOAT;
    if(![NSObject isNullString:resultCode]){
        code = resultCode.intValue;
    }

    // 数据解析失败，或者数据为空，请求失败
    if ([NSObject isNullDictonary:response]) {
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@(code), @"code", @"未知错误", @"msg", nil];
        if (failure) failure(dataDict, code);
        return;
    }
    
    if (code < 0) {
        if (failure) failure(response, code);
        return;
    }
    
    if (success) {
        success(response, code);
    }
}


/// 获取字符串里面的状态码
/// @param response 响应字典
+ (NSString *)getResultCode:(NSDictionary *)response{
    
    __block NSString *code = [self getCodeString:response];
    if (code) {
        return code;
    }
    
    // 遍历
    [response enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    
        if([obj isKindOfClass:[NSDictionary class]]){
            
            code = [self getCodeString:obj];
        }
        
        if (code) {
            *stop = YES;
        }
    }];
    
    return code;
}

+ (NSString *)getCodeString:(NSDictionary *)info{
    NSString *code = [[info objectForKey:@"errorCode"] description];
    if (!code) {
        code = [[info objectForKey:@"ErrorCode"] description];
    }
    if (!code) {
        code = [[info objectForKey:@"errCode"] description];
    }
    if (!code) {
        code = [[info objectForKey:@"retcode"] description];
    }
    if (!code) {
        code = [[info objectForKey:@"code"] description];
    }
    return code;
}

@end
