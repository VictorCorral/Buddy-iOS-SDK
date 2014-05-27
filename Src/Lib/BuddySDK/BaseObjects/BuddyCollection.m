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

- (id<BPRestProvider>)client
{   
    return _client ?: (id<BPRestProvider>)[BPClient defaultClient];
}

- (void)getAll:(BPSearchCallback)callback
{
    [self search:nil callback:callback];
}

- (void)search:(NSDictionary *)searchParmeters callback:(BPSearchCallback)callback
{
    NSString *resource = [self.requestPrefix stringByAppendingFormat:@"%@",
                          [[self type] requestPath]];
    
    NSNumber *limit  = [searchParmeters objectForKey:@"limit"];
    if(limit==nil || ([limit isEqualToNumber:[NSNumber numberWithInt:0]]))
    {
        [searchParmeters setValue:[NSNumber numberWithInt:DEFAULT_SEARCH_LIMIT] forKey:@"limit"];
    }
    
    [self.client GET:resource parameters:searchParmeters callback:^(id json, NSError *error) {
        NSString *pagingToken = json[@"nextToken"];
        NSArray *results = [json[@"pageResults"] bp_map:^id(id object) {
            return [[self.type alloc] initBuddyWithResponse:object andClient:self.client];
        }];
        callback ? callback(results, pagingToken, error) : nil;
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
