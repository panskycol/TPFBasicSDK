//
//  NSArray+String.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/10/28.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "NSArray+String.h"

@implementation NSArray (String)

- (NSString *)convertToJsonString{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}

@end
