#import <Foundation/Foundation.h>

@class ViewChannelListItem;

@interface ViewChannelListTable : NSObject

@property (nonatomic,strong) NSMutableArray *table;

-(void) addItem:(ViewChannelListItem*)item;
-(void) clear;

-(NSUInteger) itemCount;

@end
