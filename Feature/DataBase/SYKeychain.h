//
//  SYKeychain.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/22.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAMKeychain.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYKeychain : NSObject

+ (void)saveValue:(NSString *)value forkey:(NSString *)key;

+ (void)saveData:(NSData *)data forkey:(NSString *)key;

/// 删value （包括data）
+ (void)deleteValueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
