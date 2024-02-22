//
//  NSString+MD5.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/26.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MD5)

+ (NSString *)md5String:(NSString *)str;

+ (NSString *)base64EncodedString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
