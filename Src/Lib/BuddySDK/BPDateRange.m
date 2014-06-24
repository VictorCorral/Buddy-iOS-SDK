//
//  BPDateRange.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/4/14.
//
//

#import "BPDateRange.h"
#import "NSDate+JSON.h"

@implementation BPDateRange

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%@-%@", [self.start bp_serializeDateToJson], [self.end bp_serializeDateToJson]];
}
@end
