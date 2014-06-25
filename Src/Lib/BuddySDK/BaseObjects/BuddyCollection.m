//
//  BuddyCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 10/7/13.
//
//

#import "BuddyCollection.h"
#import "BPClient.h"
#import "BuddyObject+Private.h"
#import "BuddyCollection+Private.h"

#define DEFAULT_SEARCH_LIMIT 100

@interface BuddyCollection()

@property (nonatomic, copy) NSString *requestPrefix;

@end

@implementation BuddyCollection

@synthesize client = _client;

- (instancetype)initWithClient:(id<BPRestProvider>)client {
    self = [super init];
    if(self)
    {
        _client = client;
    }
    return self;
}

- (NSString *)requestPrefix
{
    return @"";
}

- (void)getAll:(BPSearchCallback)callback
{
    [self search:nil callback:callback];
}

- (void)search:(NSMutableDictionary *)searchParmeters callback:(BPSearchCallback)callback
{
    NSString *resource = [self.requestPrefix stringByAppendingFormat:@"%@",
                          [[self type] requestPath]];
    
    NSNumber *pageSize  = [searchParmeters objectForKey:@"pageSize"];
    NSString *pagingToken =[searchParmeters objectForKey:@"pagingToken"];
    if(pagingToken==nil)
    {
        if(pageSize==nil || ([pageSize isEqualToNumber:[NSNumber numberWithInt:0]]) )
        {
            pagingToken = [BPObjectSearch pagingTokenFromPageSize:DEFAULT_SEARCH_LIMIT];
        }
        else
        {
            pagingToken = [BPObjectSearch pagingTokenFromPageSize:[pageSize unsignedLongValue]];
        }
        [searchParmeters setObject:pagingToken forKey:@"pagingToken"];
    }
    
    if(pageSize!=nil)
    {
        [searchParmeters removeObjectForKey:@"pageSize"];
    }
    
    [self.client GET:resource parameters:searchParmeters callback:^(id json, NSError *error) {
        BPPagingTokens *tokens = [BPPagingTokens new];
        [[JAGPropertyConverter bp_converter] setPropertiesOf:tokens fromDictionary:json];
        NSArray *results = [json[@"pageResults"] bp_map:^id(id object) {
            return [[self.type alloc] initBuddyWithResponse:object andClient:self.client];
        }];
        callback ? callback(results, tokens, error) : nil;
    }];
}

- (void)getItem:(NSString *)identifier callback:(BuddyObjectCallback)callback
{
    NSString *resource = [self.requestPrefix stringByAppendingFormat:@"%@/%@",
                                [[self type] requestPath],
                                identifier];
    
    [self.client GET:resource parameters:nil callback:^(id json, NSError *error) {
        id buddyObject = [[self.type alloc] initBuddyWithResponse:json andClient:self.client];
        callback ? callback(buddyObject, error) : nil;
    }];
}

@end
