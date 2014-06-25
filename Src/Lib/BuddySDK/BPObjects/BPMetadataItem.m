//
//  BPMetadataItem.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/4/14.
//
//

#import "BPMetadataItem.h"
#import "BPEnumMapping.h"

@implementation BPMetadataBase

+ (NSDictionary *)mapForProperty:(NSString *)key
{
    if ([key isEqualToString:@"visibility"]) {
        return @{
                         @(BPPermissionsApp) : @"App",
                         @(BPPermissionsUser) : @"User",
                         };
    }
    
    return nil;
}

+ (id)convertValue:(NSString *)value forKey:(NSString *)key
{
    return nil;
}

@end

@interface BPSearchMetadata()<BPEnumMapping>

@end

@implementation BPSearchMetadata

@synthesize key, value, keyPrefix, created, lastModified, visibility, valuePath, locationRange;

@end

@interface BPMetadataItem()<BPEnumMapping>

@end

@implementation BPMetadataItem

@synthesize key = _key;
@synthesize value = _value;
@synthesize created = _created;
@synthesize lastModified = _lastModified;
@synthesize visibility = _visibility;

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

@implementation BPMetadataKeyValues

@synthesize values, visibility;

@end