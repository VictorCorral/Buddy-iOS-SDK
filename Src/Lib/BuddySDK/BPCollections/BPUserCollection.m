//
//  BPUserCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/20/14.
//
//

#import "BPUserCollection.h"
#import "BuddyCollection+Private.h"
#import "NSArray+BPSugar.h"

@implementation BPUserCollection

-(instancetype)initWithClient:(id<BPRestProvider>)client
{
    self = [super initWithClient:client];
    if(self){
        self.type = [BPUser class];
    }
    return self;
}

- (void)getUser:(NSString *)userId callback:(BuddyObjectCallback)callback
{
    [self getItem:userId callback:callback];
}

- (void)searchUsers:(BPSearchUsers *)searchUsers callback:(BPSearchCallback)callback
{
    id parameters = [searchUsers parametersFromDirtyProperties];
    
    [self search:parameters callback:callback];
}

- (void)getUserIdForIdentityProvider:(NSString *)identityProvider identityProviderId:(NSString *)identityProviderId callback:(BuddyIdCallback)callback
{
    NSDictionary *parameters = @{@"identityProviderName": identityProvider};
        
    NSString *resource = [self.requestPrefix stringByAppendingFormat:@"%@/identities/%@/%@",
                          [[self type] requestPath],
                          identityProvider,
                          identityProviderId];
    
    [self.client GET:resource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(json, error) : nil;
    }];
}


@end
