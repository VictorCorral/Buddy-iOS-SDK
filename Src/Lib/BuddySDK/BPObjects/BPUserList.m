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

@implementation BPSearchUserList

@synthesize name;

@end

@interface BPUserList()

+(NSString *) requestPath;

@end


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

- (instancetype)initBuddyWithClient:(id<BPRestProviderOld>)client {
    self = [super initBuddyWithClient:client];
    if(self)
    {
        [self registerProperties];
    }
    return self;
}

- (instancetype)initBuddyWithResponse:(id)response andClient:(id<BPRestProviderOld>)rest {
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

- (void)addUser:(BPUser *)user
       callback:(BuddyResultCallback)callback
{
    [self addUserId:user.id callback:callback];
}

- (void)addUserId:(NSString*)userId
         callback:(BuddyResultCallback)callback
{
    NSString *requestPath = [NSString stringWithFormat:@"%@/%@/items/%@",[BPUserList requestPath],self.id,userId];
    
    id params = [self buildUpdateDictionary];
    
    [self.client PUT:requestPath parameters:params callback:^(id json, NSError *error) {
        
        BOOL result=NO;
        if(error==nil)
        {
            NSNumber *resultNum= json; // Its not really JSON, just a number
            if([resultNum intValue] >0)
            {
                result=YES;
            }
        }
        callback(result,error);
    }];
}

- (void)deleteUser:(BPUser *)user
       callback:(BuddyResultCallback)callback
{
    [self deleteUserId:user.id callback:callback];
}

- (void)deleteUserId:(NSString*)userId
         callback:(BuddyResultCallback)callback
{
    NSString *requestPath = [NSString stringWithFormat:@"%@/%@/items/%@",[BPUserList requestPath],self.id,userId];
    
    id params = [self buildUpdateDictionary];
    
    [self.client DELETE:requestPath parameters:params callback:^(id json, NSError *error) {
        
        BOOL result=NO;
        if(error==nil)
        {
            NSNumber *resultNum= json; // Its not really JSON, just a number
            if([resultNum intValue] >0)
            {
                result=YES;
            }
        }
        callback(result,error);
    }];
}


@end


@implementation BPUserListItem

@synthesize itemType=_itemType;
@synthesize id=_id;


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerProperties];
    }
    return self;
}

- (instancetype)initBuddyWithClient:(id<BPRestProviderOld>)client {
    self = [super initBuddyWithClient:client];
    if(self)
    {
        [self registerProperties];
    }
    return self;
}

- (instancetype)initBuddyWithResponse:(id)response andClient:(id<BPRestProviderOld>)rest {
    self = [super initBuddyWithResponse:response andClient:rest];
    if(self)
    {
        [self registerProperties];
    }
    return self;
}


+ (NSDictionary *)enumMap
{
    return [[[self class] baseEnumMap] dictionaryByMergingWith: @{
                                                                  NSStringFromSelector(@selector(itemType)) : @{
                                                                          @(BPUserListItem_User) : @"User",
                                                                          @(BPUserListItem_UserList) : @"UserList",
                                                                          },
                                                                  }];
}

/*
+ (NSString *)requestPath
{
    return @"items";
}
*/

/*
- (NSString *)buildRequestPath
{
    return [NSString stringWithFormat:@"users/lists/%@/items", self.albumID];
}
 */


- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(itemType)];
    [self registerProperty:@selector(id)];
}

@end
