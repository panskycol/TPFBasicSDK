//
//  NSString+RandomString.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/12/19.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "NSString+RandomString.h"

@implementation NSString (RandomString)

+(NSString *)returnRandomLetterAndNumberWithCount:(NSInteger)count{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:16];
    for (int i = 0; i < count; i++){
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    return result;
}

@end
