//
//  SYUserDefaultStore.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/11/2.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYUserDefaultStore : NSObject


/**
 *  添加UserDefaults信息
 *
 *  @param key   关键字标示
 *  @param value 值数据
 */
+ (void)addUserDefaultsWithKey:(NSString *)key value:(id)value;


/**
 *  记录曾经登录过的user信息
 */
+ (void)addUserInfoDefaultsWithId:(NSString *)userid userInfo:(NSDictionary *)userInfo;


/**
 *  添加user登录信息
 */
+ (NSDictionary *)readUserInfoDefaultsWithId:(NSString *)userid;


/**
 *  移除UserDefaults信息
 *
 *  @param key 关键字标示
 */
+ (void)removeUserDefaultsWithKey:(NSString *)key;


/**
 *  读取UserDefaults信息
 *
 *  @param key 关键字标示
 *
 *  @return 值数据
 */
+ (id)readUserDefaultsWithKey:(NSString *)key;

/**
 *  读取UserDefaults信息
 *
 *  @param key 关键字标示
 *
 *  @return 值数据
 */
+ (BOOL)readBoolUserDefaultsWithKey:(NSString *)key;

/**
 *  添加UserDefaults信息
 *
 *  @param uid   用户id
 *  @param key   关键字标示
 *  @param value 值数据
 */
+ (void)addUserDefaultsForUid:(NSString *)uid withKey:(NSString *)key value:(id)value;

/**
 *  移除UserDefaults信息
 *
 *  @param uid   用户id
 *  @param key 关键字标示
 */
+ (void)removeUserDefaultsForUid:(NSString *)uid withKey:(NSString *)key;

/**
 *  读取UserDefaults信息
 *
 *  @param uid   用户id
 *  @param key 关键字标示
 *
 *  @return 值数据
 */
+ (id)readUserDefaultsForUid:(NSString *)uid withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
