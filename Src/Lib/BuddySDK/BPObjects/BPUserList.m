//
//  BPUserList.m
//  BuddySDK
//
//  Created by Nick Ambrose on 5/24/14.
//
//

#import "BPUserList.h"
#import "BPUserListCollection.h"
#import "BuddyObject+Private.h"
#import "BPRestProvider.h"
#import "BPCLient.h"



@implementation BPUserList

@synthesize name=_name;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerProperties];
    }
    return self;
}

- (instancetype)initBuddyWithClient:(id<BPRestProvider>)client {
    self = [super initBuddyWithClient:client];
    if(self)
    {
        [self registerProperties];
    }
    return self;
}

- (instancetype)initBuddyWithResponse:(id)response andClient:(id<BPRestProvider>)rest {
    self = [super initBuddyWithResponse:response andClient:rest];
    if(self)
    {
        [self registerProperties];
    }
    return self;
}

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(name)];
}

static NSString *userLists = @"users/lists";
+(NSString *) requestPath{
    return userLists;
}

@end
