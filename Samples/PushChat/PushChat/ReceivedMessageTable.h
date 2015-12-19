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
