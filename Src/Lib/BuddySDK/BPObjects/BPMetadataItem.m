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

@synthesize key, value, keyPrefix, locationRange, created, modified, visibility;

@end

@interface BPMetadataItem()<BPEnumMapping>

@property (nonatomic, strong) BPDateRange *created;
@property (nonatomic, strong) BPDateRange *modified;

@end

@implementation BPMetadataItem

@synthesize key = _key;
@synthesize value = _value;
@synthesize keyPrefix = _keyPrefix;
@synthesize locationRange = _locationRange;
@synthesize created = _created;
@synthesize modified = _modified;
@synthesize visibility = _visibility;

- (instancetype)initBuddyWithResponse:(id)response
{
    if (!response) return nil;
    
    self = [super init];
    if(self)
    {
        [[JAGPropertyConverter converter] setPropertiesOf:self fromDictionary:response];
    }
    return self;
}

@end

@implementation BPMetadataKeyValues

@synthesize values, visibility;

@end