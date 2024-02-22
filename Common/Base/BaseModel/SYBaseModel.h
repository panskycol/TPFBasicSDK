//
//  SYBaseModel.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/25.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYBaseModel : NSObject<YYModel>
/// json转model
+ (nullable instancetype)modelWithJSON:(id)json;

/// 字典转model
+ (nullable instancetype)modelWithDictionary:(NSDictionary *)dictionary;

// 给model赋值
- (void)modelSetWithDictionary:(NSDictionary *)dict;

/// model转json
- (nullable NSString *)modelToJSONString;

/// model转字典
- (nullable NSDictionary *)modelToDictionary;

/// 判断两个model是否相等
- (BOOL)modelIsEqual:(id)model;

@end

NS_ASSUME_NONNULL_END
