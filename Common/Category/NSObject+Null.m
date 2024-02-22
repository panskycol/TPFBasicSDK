//
//  NSObject+Null.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/4.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "NSObject+Null.h"

@implementation NSObject (Null)

+ (BOOL)isNullString:(NSString *)str{
    
    if (str == nil || str == Nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (str.length == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNullDictonary:(NSDictionary *)dict{
    
    if (dict == nil || dict == Nil || dict == NULL) {
        return YES;
    }
    if ([dict isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if (![dict isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if (dict.count == 0)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNullArray:(NSArray *)array{
    
    if (array == nil || array == Nil || array == NULL) {
        return YES;
    }
    if ([array isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (![array isKindOfClass:[NSArray class]]) {
        return YES;
    }
    if (array.count == 0)
    {
        return YES;
    }
    
    return NO;
}

@end
