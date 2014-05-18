//
//  BPLocation.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/9/14.
//
//

#import "BPLocation.h"
#import "BuddyObject+Private.h"

@implementation BPSearchLocation

@synthesize name, description, address1, address2, city, region, country, postalCode, fax, phone, website, category, isPublic;

@end

@interface BPLocation()

@property (nonatomic, assign) double *distance;

@end

@implementation BPLocation

@synthesize name;
@synthesize description;
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize region;
@synthesize country;
@synthesize postalCode;
@synthesize fax;
@synthesize phone;
@synthesize website;
@synthesize category;
@synthesize isPublic;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(name)];
    [self registerProperty:@selector(description)];
    [self registerProperty:@selector(address1)];
    [self registerProperty:@selector(address2)];
    [self registerProperty:@selector(city)];
    [self registerProperty:@selector(region)];
    [self registerProperty:@selector(country)];
    [self registerProperty:@selector(postalCode)];
    [self registerProperty:@selector(fax)];
    [self registerProperty:@selector(phone)];
    [self registerProperty:@selector(website)];
    [self registerProperty:@selector(category)];
    [self registerProperty:@selector(isPublic)];
}

NSString *location = @"locations";
+ (NSString *)requestPath
{
    return location;
}

@end
