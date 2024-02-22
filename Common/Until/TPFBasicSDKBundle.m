//
//  TPFBasicSDKBundle.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/10/28.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "TPFBasicSDKBundle.h"

@implementation TPFBasicSDKBundle

+ (NSBundle *)bundle{
    return [self.class bundleWithName:NSStringFromClass(self.class)];
}

@end
