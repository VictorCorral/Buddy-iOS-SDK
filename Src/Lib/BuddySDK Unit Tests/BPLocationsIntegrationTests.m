//
//  CheckinIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import "BPLocation.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BuddyLocationsSpec)

describe(@"BPLocationIntegrationSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPLocation *tempLocation;
        __block BOOL fin = NO;

        beforeAll(^{
            
            [Buddy setLocationEnabled:YES];

            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        beforeEach(^{
            fin = NO;
        });
        
        it(@"Should allow you create a location.", ^{
            
            tempLocation = [BPLocation new];
            tempLocation.name = @"House of Pain";
            tempLocation.description = @"Where the pain is brought";
            tempLocation.location = BPCoordinateMake(1.2, 3.4);
            tempLocation.category = @"So much pain";
            tempLocation.isPublic = YES;
            tempLocation.tag = @"Some Tag";
            
            [[Buddy locations] addLocation:tempLocation callback:^(NSError *error) {
                [[error should] beNil];
                [[tempLocation.id should] beNonNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow updating a location", ^{
            tempLocation.name = @"New Name";
            [tempLocation save:^(NSError *error) {
                [[error should] beNil];
                [[tempLocation.name should] equal:@"New Name"];
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow retrieving a location", ^{

            [[Buddy locations] getLocation:tempLocation.id callback:^(BPLocation *retrievedLocation, NSError *error) {
                [[error should] beNil];
                [[retrievedLocation.name should] equal:@"New Name"];
                fin = YES;
            }];
            [tempLocation save:^(NSError *error) {
                [[error should] beNil];
                [[tempLocation.name should] equal:@"New Name"];
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });

        it(@"Should allow you to search for a location.", ^{
            __block NSArray *locations;
        
            BPSearchLocation *searchLocations = [BPSearchLocation new];
            searchLocations.limit = 9;
            searchLocations.locationRange = BPCoordinateRangeMake(44.987293, -93.2484864, 100);
            
            [[Buddy locations] searchLocation:searchLocations callback:^(NSArray *buddyObjects, NSString *pagingToken, NSError *error) {
                [[error should] beNil];
                locations = buddyObjects;
                [[locations should] beNonNil];
                [[theValue([locations count]) should] beGreaterThan:theValue(0)];
                [[[[locations firstObject] city] should] equal:@"Minneapolis"];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow paging location searches.", ^{
            BPSearchLocation *searchLocations = [BPSearchLocation new];
            //searchLocations.locationRange = BPCoordinateRangeMake(44.987293, -93.2484864, 100000);
            
            [[Buddy locations] searchLocation:searchLocations callback:^(NSArray *locations, NSString *pagingToken, NSError *error) {
                [[error should] beNil];
                [[locations should] beNonNil];
                BPLocation *oldFirst = [locations firstObject];
                
                
                searchLocations.pagingToken = pagingToken;
                
                [[Buddy locations] searchLocation:searchLocations callback:^(NSArray *secondLocations, NSString *pagingToken, NSError *error) {
                    BPLocation *newFirst = [secondLocations firstObject];
                    [[oldFirst.id shouldNot] equal:newFirst.id];
                    fin = YES;
                }];
                
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];

        });
        
        it(@"Should allow deleting a location.", ^{
            [tempLocation destroy:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
    });
});

SPEC_END
