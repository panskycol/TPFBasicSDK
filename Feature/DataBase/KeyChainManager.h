//
//  KeyChainManager.h
//  TPServiceSDK
//
//  Created by 尚游苹果 on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainManager : NSObject

 ///存储 UUID

+(void)saveUUID:(NSString *)UUID;

///读取UUID
+(NSString *)readUUID;

///删除数据
+(void)deleteUUID;

@end

NS_ASSUME_NONNULL_END
