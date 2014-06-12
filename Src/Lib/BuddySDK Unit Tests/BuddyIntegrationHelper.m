//
//  BuddyIntegrationHelper.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/29/13.
//
//

#import "BuddyIntegrationHelper.h"
#import "Buddy.h"

@implementation BuddyIntegrationHelper

+ (void) bootstrapInit
{
    [Buddy initClient:APP_ID appKey:APP_KEY];
}

+ (void) bootstrapLogin:(void(^)())callback
{
    [Buddy initClient:APP_ID appKey:APP_KEY];
    
    [Buddy login:TEST_USERNAME password:TEST_PASSWORD callback:^(BPUser *loggedInsUser, NSError *error) {
        
        BPUser *user = [BPUser new];
        user.firstName = @"Erik";
        user.lastName = @"Erik";
        user.gender = BPUserGender_Unknown;
        user.email = [NSString stringWithFormat:@"iostests%@@buddy.com", [BuddyIntegrationHelper randomString:10]];
        user.dateOfBirth = [BuddyIntegrationHelper randomDate];
        user.userName = TEST_USERNAME;
        
        if(loggedInsUser)
            callback();
        else {
            [Buddy createUser:user password:TEST_PASSWORD callback:^(NSError *error) {
                callback();
            }];
        }
    }];
        

}

+(void)createRandomUsers:(NSMutableArray*)users
                   count:(int)count
                callback:(BuddyCompletionCallback)callback
{
    __block int numTimesCallbackCalled = 0;
    __block NSError *capturedError=nil;
    
    NSString *usernamePrefix = [BuddyIntegrationHelper randomString:20];
    
    for(int index=0;index<count;index++)
    {
        BPUser *user = [BPUser new];
        user.userName= [NSString stringWithFormat:@"%@_%d",usernamePrefix,index];
        user.email = [NSString stringWithFormat:@"iostests%@_%d@buddy.com", [BuddyIntegrationHelper randomString:20], index];

        __block BPClient *client = [[BPClient alloc] init];
        [client setupWithApp:APP_ID appKey:APP_KEY options:nil delegate:nil];
        
        [BuddyIntegrationHelper createRandomUser:user withClient:client callback:^(NSError *error)
        {
            numTimesCallbackCalled++;
            if( (error!=nil) && (capturedError==nil))
            {
                capturedError = error;
            }
            
            if(error==nil)
            {
                [users addObject:user];
            }
            
            if(numTimesCallbackCalled == count && callback!=nil)
            {
                callback(capturedError);
            }
        }];
    }
}

+(void)deleteUsers:(NSArray*)users callback:(BuddyCompletionCallback)callback
{
    __block int numTimesCallbackCalled = 0;
    __block NSError *capturedError=nil;
    
    
    for(int index=0;index<[users count];index++)
    {
        BPUser *user = [users objectAtIndex:index];
        [user destroy:^(NSError *error) {
            numTimesCallbackCalled++;
            if( (error!=nil) && (capturedError==nil))
            {
                capturedError = error;
            }
            
            if( (numTimesCallbackCalled == [users count]) && callback!=nil)
            {
                callback(capturedError);
            }
            
        }];
    }
}

+(void)createRandomUser:(BPUser *)user withClient:(BPClient*)client callback:(BuddyCompletionCallback)callback
{
    user.firstName = [BuddyIntegrationHelper randomString:8];
    user.lastName = [BuddyIntegrationHelper randomString:8];
    user.gender = BPUserGender_Unknown;
    
    if(user.email==nil)
    {
        user.email = [NSString stringWithFormat:@"iostests%@@buddy.com", [BuddyIntegrationHelper randomString:20]];
    }
    user.dateOfBirth = [BuddyIntegrationHelper randomDate];
    
    if(user.userName==nil)
    {
        user.userName = [BuddyIntegrationHelper randomString:20];
    }
    [client createUser:user password:user.userName callback:^(NSError *error) {
        callback(error);
    }];
}

+ (NSDate *)randomDate
{
    NSDate *today = [[NSDate alloc] init];
    NSLog(@"%@", today);
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-100]; // note that I'm setting it to -1
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    NSLog(@"%@", endOfWorldWar3);
    
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [currentCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:endOfWorldWar3];
    
    [comps setMonth:arc4random_uniform(12)];
    
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[currentCalendar dateFromComponents:comps]];
    
    [comps setDay:arc4random_uniform(range.length)];
    
    // Normalise the time portion
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    [comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *randomDate = [currentCalendar dateFromComponents:comps];
    
    return randomDate;
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+ (NSString *)randomString:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

@end
