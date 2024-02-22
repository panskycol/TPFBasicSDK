//
//  SYBaseModel.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/25.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYBaseModel.h"
#import "NSString+Dictionary.h"

@implementation SYBaseModel

+ (nullable instancetype)modelWithJSON:(id)json{
    
    return [self yy_modelWithJSON:json];
}

+ (nullable instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    
    return [self yy_modelWithDictionary:dictionary];
}

- (nullable NSString *)modelToJSONString{
    
    return [self yy_modelToJSONString];
}

- (void)modelSetWithDictionary:(NSDictionary *)dict{
    
    [self yy_modelSetWithDictionary:dict];
}

- (nullable NSDictionary *)modelToDictionary{
    
    NSString *json = [self yy_modelToJSONStringWithCustomProperyMapper:NO];
    
    return [NSString converToDictionaryWithJsonString:json];
}

- (BOOL)modelIsEqual:(id)model{
    
    return [self yy_modelIsEqual:model];
}


@end
