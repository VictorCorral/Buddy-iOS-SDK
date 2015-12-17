#import "ViewChannelListTable.h"

@implementation ViewChannelListTable

-(instancetype)init
{
    {
        self = [super init];
        if (self)
        {
            _table = [[NSMutableArray alloc] init];
        }
        return self;
    }
}

-(void) addItem:(ViewChannelListItem*)item
{
    [self.table addObject:item];
}
-(void) clear
{
    [self.table removeAllObjects];
}

-(NSUInteger) itemCount
{
    return [self.table count];
}

@end
