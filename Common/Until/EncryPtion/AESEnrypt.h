#import <Foundation/Foundation.h>
 
@interface AESEnrypt : NSObject
 
+ (NSString*) AES128Encrypt:(NSString *)plainText;
 
+ (NSString*) AES128Decrypt:(NSString *)encryptText;
 
@end
