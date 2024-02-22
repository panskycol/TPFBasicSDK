//
//  NSString+Dictionary.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/19.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "NSString+Dictionary.h"
#import "NSObject+Null.h"
#import "NSString+Dictionary.h"

@implementation NSString (Dictionary)

- (NSDictionary *)converToDictionary
{
    return [NSString converToDictionaryWithJsonString:self];
}

+ (NSDictionary *)converToDictionaryWithJsonString:(NSString *)jsonString
{
    if ([NSObject isNullString:jsonString]) {
        NSLog(@"--->Json字符串转字典失败，Json字符串为空");
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 将NSData转换为字典, 并打印错误消息
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"--->Json字符串转字典失败：%@",error);
    }
    
    return jsonDict;
}


@end
