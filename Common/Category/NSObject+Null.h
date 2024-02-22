//
//  NSObject+Null.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/4.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Null)

/**
 *  判断字符串是否为空
 *
 *  @param str 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isNullString:(NSString *)str;


/**
 *  判断字典是否为空
 *
 *
 *  @return BOOL
 */
+ (BOOL)isNullDictonary:(NSDictionary *)dict;


/**
 *  判断数组是否为空
 *
 *  @param array 数组对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
