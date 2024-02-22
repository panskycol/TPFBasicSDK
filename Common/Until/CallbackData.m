//
//  CallbackData.m
//  TPFBasicSDK
//
//  Created by 尚游苹果 on 2021/3/29.
//

#import "CallbackData.h"
#import "NSDictionary+String.h"

@implementation CallbackData
///发送通用回调
+ (void)sendCallback:(NSInteger)errCode errMsg:(NSString *)errMsg extra:(NSDictionary *)extra success:(void (^)(NSString *))callback{
    NSDictionary *result = @{
        @"ErrorCode" : @(errCode),
        @"ErrorMsg" : errMsg,
        @"Extra" : extra
    };
    NSString *content = [result converToString];
    
    if (callback) callback(content);
}

///发送扩展事件类型回调
+ (void)sendCallback:(NSInteger)errCode errMsg:(NSString *)errMsg extra:(NSDictionary *)extra commonEventKey:(NSString *)eventKey success:(void (^)(NSString *))callback{
    NSDictionary *result = @{
        @"ErrorCode" : @(errCode),
        @"ErrorMsg" : errMsg,
        @"Extra" : extra,
        @"CommonEventKey" : eventKey
    };
    NSString *content = [result converToString];
    
    if (callback) callback(content);
}
@end
