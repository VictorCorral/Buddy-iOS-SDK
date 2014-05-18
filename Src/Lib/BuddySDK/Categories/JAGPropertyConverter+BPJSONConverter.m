//
//  JAGPropertyConverter+BPJSONConverter.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/4/14.
//
//

#import "JAGPropertyConverter+BPJSONConverter.h"
#import "BPSize.h"

@implementation JAGPropertyConverter (BPJSONConverter)

+(JAGPropertyConverter *)converter
{
    static JAGPropertyConverter *c;
    if(!c)
    {
        c = [JAGPropertyConverter new];
        
        __weak typeof(self) weakSelf = self;
        c.identifyDict = ^Class(NSDictionary *dict) {
            if ([dict valueForKey:@"lat"]) {
                return [BPCoordinate class];
            } else if ([dict valueForKey:@"h"]) {
                return [BPSize class];
            }
            return [weakSelf class];
        };
        
    }
    return c;
}

@end
