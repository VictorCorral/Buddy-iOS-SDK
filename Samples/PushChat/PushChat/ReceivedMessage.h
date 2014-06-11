//
//  ReceivedMessage.h
//  PushChat
//
//  Created by Nick Ambrose on 6/2/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceivedMessage : NSObject

@property (nonatomic,strong) NSString *messageID;
@property (nonatomic,strong) NSString *channel;
@property (nonatomic,strong) NSString *message;

+(ReceivedMessage*)parseFromDict:(NSDictionary*)dict;

@end
