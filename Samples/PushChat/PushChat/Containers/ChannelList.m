#import <BuddySDK/Buddy.h>

#import "ChannelList.h"

@implementation ChannelList


-(instancetype)init
{
    {
        self = [super init];
        if (self)
        {
            _channels = [[NSMutableDictionary alloc] init];
        }
        return self;
    }
}

-(void) clearChannels
{
    [self.channels removeAllObjects];
}
-(void) addChannel:(BPUserList*)channel
{
    [self.channels setObject:channel forKey:channel.id];
    
}

-(NSUInteger) channelCount
{
    return [self.channels count];
}

-(BPUserList*) getChannel:(NSString*)channelID
{
    return [self.channels objectForKey:channelID];
}

@end
