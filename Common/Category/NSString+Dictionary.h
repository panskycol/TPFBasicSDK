//
//  NSString+Dictionary.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/19.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Dictionary)

- (NSDictionary *)converToDictionary;

+ (NSDictionary *)converToDictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
