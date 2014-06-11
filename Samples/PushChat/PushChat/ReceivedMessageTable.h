//
//  ReceivedMessageTable.h
//  PushChat
//
//  Created by Nick Ambrose on 6/2/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReceivedMessage;

@interface ReceivedMessageTable : NSObject

@property (nonatomic,strong) NSMutableArray *messages;

-(void) addMessage:(ReceivedMessage*)message;
-(ReceivedMessage*) addMessageFromDict:(NSDictionary*)dict;

-(ReceivedMessage*)itemAtIndex:(NSInteger)index;

-(void) clear;
-(NSInteger) count;


@end
