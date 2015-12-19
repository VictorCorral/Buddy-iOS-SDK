#import "NSDate+JSON.h"

@implementation NSDate (JSON)

- (NSString *)bp_serializeDateToJson;
{
    return [NSString stringWithFormat:@"/Date(%lld)/",
     (long long)([self timeIntervalSince1970] * 1000)];
}

@end
