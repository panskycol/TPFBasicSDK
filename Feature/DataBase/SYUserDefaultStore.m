//
//  SYUserDefaultStore.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/2.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYUserDefaultStore.h"

@implementation SYUserDefaultStore

/**
 *  添加UserDefaults信息
 *
 *  @param key   关键字标示
 *  @param value 值数据
 */
+ (void)addUserDefaultsWithKey:(NSString *)key value:(id)value
{
    // 空值判断
    if([NSObject isNullString:key] || value == nil){
        NSLog(@"--->添加UserDefaults信息失败，key或value为空");
        return;
    }
    
    // 修添加NSUserDefaults数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+ (void)addUserInfoDefaultsWithId:(NSString *)userid userInfo:(NSDictionary *)userInfo{
        
    [self addUserDefaultsWithKey:userid value:userInfo];
}


+ (NSDictionary *)readUserInfoDefaultsWithId:(NSString *)userid{
    
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:userid];
    if([NSObject isNullDictonary:info]){
        return nil;
    }
    
    return info;
}

/**
 *  移除UserDefaults信息
 *
 *  @param key 关键字标示
 */
+ (void)removeUserDefaultsWithKey:(NSString *)key
{
    // 空值判断
    if ([NSObject isNullString:key]) {
        NSLog(@"--->移除UserDefaults信息失败，key为空");
    }
    
    // 修改NSUserDefaults数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}


/**
 *  读取UserDefaults信息
 *
 *  @param key 关键字标示
 *
 *  @return 值数据
 */
+ (id)readUserDefaultsWithKey:(NSString *)key
{
    // 空值判断
    if ([NSObject isNullString:key]) {
        NSLog(@"--->读取UserDefaults信息失败，key为空");
        return nil;
    }
    
    // 读取NSUserDefaults数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id value = [userDefaults objectForKey:key];
    
    return value;
}

/**
 *  读取UserDefaults信息
 *
 *  @param key 关键字标示
 *
 *  @return 值数据
 */
+ (BOOL)readBoolUserDefaultsWithKey:(NSString *)key
{
    // 空值判断
    if ([NSObject isNullString:key]) {
        NSLog(@"--->读取UserDefaults信息失败，key为空");
        return nil;
    }
    
    // 读取NSUserDefaults数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id value = [userDefaults objectForKey:key];
    
    return [value boolValue];
}


/**
 *  添加UserDefaults信息
 *
 *  @param uid   用户id
 *  @param key   关键字标示
 *  @param value 值数据
 */
+ (void)addUserDefaultsForUid:(NSString *)uid withKey:(NSString *)key value:(id)value {
    // 空值判断
    if([NSObject isNullString:key] || value == nil){
        NSLog(@"--->添加UserDefaults信息失败，key或value为空");
        return;
    }
    
    // 修添加NSUserDefaults数据
    NSUserDefaults *userDefaults;
    if ([NSString isNullString:uid]) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    } else {
        userDefaults = [[NSUserDefaults alloc] initWithSuiteName:uid];
    }
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

/**
 *  移除UserDefaults信息
 *
 *  @param uid   用户id
 *  @param key 关键字标示
 */
+ (void)removeUserDefaultsForUid:(NSString *)uid withKey:(NSString *)key {
    // 空值判断
    if ([NSObject isNullString:key]) {
        NSLog(@"--->移除UserDefaults信息失败，key为空");
    }
    
    // 修改NSUserDefaults数据
    NSUserDefaults *userDefaults;
    if ([NSString isNullString:uid]) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    } else {
        userDefaults = [[NSUserDefaults alloc] initWithSuiteName:uid];
    }
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}


/**
 *  读取UserDefaults信息
 *
 *  @param uid   用户id
 *  @param key 关键字标示
 *
 *  @return 值数据
 */
+ (id)readUserDefaultsForUid:(NSString *)uid withKey:(NSString *)key {
    
    // 空值判断
    if ([NSObject isNullString:key]) {
        NSLog(@"--->读取UserDefaults信息失败，key为空");
        return nil;
    }
    
    // 读取NSUserDefaults数据
    NSUserDefaults *userDefaults;
    if ([NSString isNullString:uid]) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    } else {
        userDefaults = [[NSUserDefaults alloc] initWithSuiteName:uid];
    }
    id value = [userDefaults objectForKey:key];
    
    return value;
}

@end
