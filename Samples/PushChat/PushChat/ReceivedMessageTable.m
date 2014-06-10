//
//  ReceivedMessageTable.m
//  PushChat
//
//  Created by Nick Ambrose on 6/2/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import "ReceivedMessageTable.h"
#import "ReceivedMessage.h"


@implementation ReceivedMessageTable

-(instancetype)init
{
    {
        self = [super init];
        if (self)
        {
            _messages = [[NSMutableArray alloc] init];
        }
        return self;
    }
}

-(void) addMessage:(ReceivedMessage*)message
{
    [self.messages addObject:message];
}

-(ReceivedMessage*) addMessageFromDict:(NSDictionary*)dict
{
    ReceivedMessage * message = [ReceivedMessage parseFromDict:dict];
    if(message!=nil)
    {
        [self addMessage:message];
    }
    return message;
}

-(void) clear
{
    [self.messages removeAllObjects];
}

-(NSInteger) count
{
    return [self.messages count];
}

-(ReceivedMessage*)itemAtIndex:(NSInteger)index
{
    if(index<[self.messages count])
    {
        return [self.messages objectAtIndex:index];
    }
    return nil;
}


@end
