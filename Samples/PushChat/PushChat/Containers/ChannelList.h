#import <Foundation/Foundation.h>

@class BPUserList;


@interface ChannelList : NSObject

@property (nonatomic,strong) NSMutableDictionary *channels;

-(void) clearChannels;
-(void) addChannel:(BPUserList*)channel;

-(NSUInteger) channelCount;

-(BPUserList*) getChannel:(NSString*)channelID;

@end
