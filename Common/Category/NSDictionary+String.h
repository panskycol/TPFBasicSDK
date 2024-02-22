//
//  NSDictionary+String.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/26.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (String)

/// 将字典转换为Json字符串
- (NSString *)converToString;

/// 将字典转换为Json字符串
+ (NSString *)converToStringWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
