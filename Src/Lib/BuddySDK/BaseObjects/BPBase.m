//
//  BPMetadataBase.m
//  BuddySDK
//
//  Created by Erik Kerber on 2/11/14.
//
//

#import "BPBase.h"
#import "BPBase+Private.h"
#import "BPEnumMapping.h"
#import "BPMetadataItem.h"
#import "JAGPropertyConverter.h"
#import "BPPagingTokens.h"

@interface BPBase()<BPEnumMapping>

@property (nonatomic, weak) id<BPRestProvider> client;
@property (nonatomic, weak) id<BPLocationProvider> locationProvider;

@end

@implementation BPBase

- (instancetype)initWithClient:(id<BPRestProvider>)client
{
    self = [super init];
    if (self) {
        _client = client;
    }
    return self;
}

+ (id)convertValue:(NSString *)value forKey:(NSString *)key
{
    return nil;
}

+ (id)convertValueToJSON:(NSString *)value forKey:(NSString *)key
{
    return nil;
}

+ (NSDictionary *)mapForProperty:(NSString *)key
{
    return [self enumMap][key];
}

+ (NSDictionary *)enumMap
{
    return [self baseEnumMap];
}

+ (NSDictionary *)baseEnumMap
{
    // Return any enum->string mappings used in responses subclass.
    return @{NSStringFromSelector(@selector(readPermissions)) : @{
                     @(BPPermissionsApp) : @"App",
                     @(BPPermissionsUser) : @"User",
                     },
             NSStringFromSelector(@selector(writePermissions)) : @{
                     @(BPPermissionsApp) : @"App",
                     @(BPPermissionsUser) : @"User",
                     }};
}

- (NSString *)metadataPath:(NSString *)key
{
    return @"";
}

- (void)setMetadata:(BPMetadataItem *)metadata callback:(BuddyCompletionCallback)callback
{
    id parameters = [metadata bp_parametersFromProperties];
    
    [self.client PUT:[self metadataPath:parameters[@"key"]] parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)setMetadataValues:(BPMetadataKeyValues *)metadata callback:(BuddyCompletionCallback)callback
{
    id parameters = [metadata bp_parametersFromProperties];
    
    [self.client PUT:[self metadataPath:nil] parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}


- (void)searchMetadata:(BPSearchMetadata *)search callback:(BPSearchCallback)callback
{
    id searchParameters = [search bp_parametersFromProperties];
    
    NSString *resource = [self metadataPath:nil];
    
    [self.client GET:resource parameters:searchParameters callback:^(id json, NSError *error) {
        BPPagingTokens *tokens = [BPPagingTokens new];
        [[JAGPropertyConverter converter] setPropertiesOf:tokens fromDictionary:json];
        
        NSArray *results = [json[@"pageResults"] bp_map:^id(id object) {
            id metadata = [[BPMetadataItem alloc] init];
            [[JAGPropertyConverter converter] setPropertiesOf:metadata fromDictionary:object];
            return metadata;
        }];
        callback ? callback(results, tokens, error) : nil;
    }];
}

- (void)incrementMetadata:(NSString *)key delta:(NSInteger)delta callback:(BuddyCompletionCallback)callback
{
    NSString *incrementResource = [NSString stringWithFormat:@"%@/increment", [self metadataPath:key]];
    
    NSDictionary *parameters = @{@"delta": @(delta)};
    
    [self.client POST:incrementResource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)getMetadataWithKey:(NSString *)key visibility:(BPPermissions)visibility callback:(BPMetadataCallback)callback
{
    NSDictionary *parameters = @{@"visibility": [[self class] enumMap][@"readPermissions"][@(visibility)]};
    
    [self.client GET:[self metadataPath:key] parameters:parameters callback:^(id metadata, NSError *error) {
        BPMetadataItem *item = [[BPMetadataItem alloc] initBuddyWithResponse:metadata];
        callback ? callback(item, error) : nil;
    }];
}

- (void)deleteMetadataWithKey:(NSString *)key visibility:(BPPermissions)visibility callback:(BuddyCompletionCallback)callback
{
    NSDictionary *parameters = @{@"visibility": [[self class] enumMap][@"readPermissions"][@(visibility)]};
    [self.client DELETE:[self metadataPath:key] parameters:parameters callback:^(id metadata, NSError *error) {
        callback ? callback(error) : nil;
    }];
}


@end
