#import <Foundation/Foundation.h>

@class BPClient;

@interface BuddyDevice : NSObject

@property (nonatomic, readonly, strong) BPClient* client;

+ (NSString *)identifier;

+ (NSString *)osVersion;

+ (NSString *)deviceModel;

- (void)pushToken:(NSString*)pushToken;

- (void)initialize:(BPClient*)client;

@end