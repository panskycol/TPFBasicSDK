//
//  NSDictionary+String.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/26.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "NSDictionary+String.h"
#import "NSObject+Null.h"

@implementation NSDictionary (String)

- (NSString *)converToString
{
    return [NSDictionary converToStringWithDictionary:self];
}


+ (NSString *)converToStringWithDictionary:(NSDictionary *)dict
{
    // 空值判断
    if ([NSObject isNullDictonary:dict]) {
        NSLog(@"--->字典转字符串失败，字典对象为空");
        return nil;
    }
    
    // 将字典转换为NSData, 并打印错误消息
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if(error) {
        NSLog(@"--->字典转字符串失败：%@",error);
    }
    
    // 将NSData转字符串
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n  " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" : " withString:@":"];

    return jsonStr;
}


@end
