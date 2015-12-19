#import <Foundation/Foundation.h>

@interface ReceivedMessage : NSObject

@property (nonatomic,strong) NSString *messageID;
@property (nonatomic,strong) NSString *channel;
@property (nonatomic,strong) NSString *message;

+(ReceivedMessage*)parseFromDict:(NSDictionary*)dict;

@end
