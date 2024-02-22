//
//  CallbackData.h
//  TPFBasicSDK
//
//  Created by 尚游苹果 on 2021/3/29.
//

#import <Foundation/Foundation.h>

@interface CallbackData : NSObject

///发送通用回调
+ (void)sendCallback:(NSInteger)errCode errMsg:(NSString *)errMsg extra:(NSDictionary *)extra success:(void (^)(NSString *))callback;

///发送扩展事件类型回调
+ (void)sendCallback:(NSInteger)errCode errMsg:(NSString *)errMsg extra:(NSDictionary *)extra commonEventKey:(NSString *)eventKey success:(void (^)(NSString *))callback;

@end


