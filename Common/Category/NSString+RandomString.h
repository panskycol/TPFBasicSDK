//
//  NSString+RandomString.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/12/19.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RandomString)

+(NSString *)returnRandomLetterAndNumberWithCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
