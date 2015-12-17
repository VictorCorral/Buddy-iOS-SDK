#import "ReceivedMessage.h"

@implementation ReceivedMessage

+(ReceivedMessage*)parseFromDict:(NSDictionary*)dict
{
    ReceivedMessage *message = [ReceivedMessage new];
    
    message.messageID = [dict objectForKey:@"_bId"];
    
    NSDictionary *details = [dict objectForKey:@"aps"];
    if(details!=nil)
    {
        NSString *messageText = [details objectForKey:@"alert"];
        if(message!=nil)
        {
            NSRange match = [messageText rangeOfString:@":"];
            
            if(match.location==NSNotFound || match.location==0)
            {
                message.channel = @"Unknown";
                message.message = messageText;
            }
            else
            {
                message.channel =[messageText substringWithRange:NSMakeRange(0, match.location)];
                if([messageText length]>match.location)
                {
                    message.message = [messageText substringFromIndex:match.location+1];
                }
                else
                {
                    message.message = @"";
                }
            }
        }
    }
    
    return message;

    
}

@end
