//
//  BPIdentityValue.m
//  BuddySDK
//
//  Created by Erik.Kerber on 5/1/14.
//
//

#import "BPIdentityValue.h"

@implementation BPIdentityValue

- (instancetype)initBuddyWithResponse:(id)response
{
    if (!response) return nil;
    
    self = [super init];
    if(self)
    {
        [[JAGPropertyConverter bp_converter] setPropertiesOf:self fromDictionary:response];
    }
    return self;
}

@end
