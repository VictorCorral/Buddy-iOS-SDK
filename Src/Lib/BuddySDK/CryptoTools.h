#import <Foundation/Foundation.h>

@interface CryptoTools : NSObject

+(NSString*) hmac256ForKey:(NSString*)key andData:(NSString *)data;

@end
