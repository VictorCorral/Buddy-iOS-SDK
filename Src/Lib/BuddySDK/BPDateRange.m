#import "BPDateRange.h"
#import "NSDate+JSON.h"

@implementation BPDateRange

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%@-%@", [self.start bp_serializeDateToJson], [self.end bp_serializeDateToJson]];
}
@end
