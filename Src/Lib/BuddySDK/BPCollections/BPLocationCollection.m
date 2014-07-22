//
//  BPCheckinCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "BuddyCollection+Private.h"
#import "BPLocationCollection.h"
#import "BPClient.h"
#import "BPLocation.h"

@implementation BPLocationCollection

- (instancetype)initWithClient:(id<BPRestProviderOld>)client{
    self = [super initWithClient:client];
    if(self){
        self.type = [BPLocation class];
    }
    return self;
}


- (void)addLocation:(BPLocation *)location
           callback:(BuddyCompletionCallback)callback
{
    [location savetoServerWithClient:self.client callback:callback];
}

- (void)getLocation:(NSString *)locationId callback:(BuddyObjectCallback)callback
{
    [self getItem:locationId callback:callback];
}

- (void)searchLocation:(BPSearchLocation *)searchLocations callback:(BPSearchCallback)callback
{
    id parameters = [searchLocations parametersFromDirtyProperties];
    
    [self search:parameters callback:callback];
}

@end
