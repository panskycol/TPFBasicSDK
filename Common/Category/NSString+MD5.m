//
//  NSString+MD5.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/26.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (MD5)

///字符串转为MD5
+ (NSString *)md5String:(NSString *)str{
    const char *string = str.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

///转为base64
+ (NSString *)base64EncodedString:(NSString *)str{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    const char *bytes = str.UTF8String;
    CC_MD5(bytes, (CC_LONG)strlen(bytes), result);
    NSData *data = [NSData dataWithBytes: result length:CC_MD5_DIGEST_LENGTH];
    NSString *string = [data base64EncodedStringWithOptions:0];//base64编码;
    return string;
}

+ (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

@end
