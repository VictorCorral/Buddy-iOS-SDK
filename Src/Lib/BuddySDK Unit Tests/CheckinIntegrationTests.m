//
//  CheckinIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import "BPCoordinate.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BuddyCheckinSpec)

describe(@"BPCheckinIntegrationSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPCheckin *tempCheckin;
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow you to checkin.", ^{
            BPCoordinate *coordinate = [BPCoordinate new];
            coordinate.lat = 2.3;
            coordinate.lng = 4.4;
            
            tempCheckin = [BPCheckin new];
            tempCheckin.comment = @"Checking in!";
            tempCheckin.description = @"Description";
            tempCheckin.location = BPCoordinateMake(1.2, 3.4);
            
            [[Buddy checkins] addCheckin:tempCheckin
                                callback:^(NSError *error) {
                                 [[error should] beNil];
            }];

            
            [[expectFutureValue(tempCheckin.id) shouldEventually] beNonNil];
        });
        
        it(@"Should allow you to search checkins.", ^{
            __block NSArray *checkins;
            
            BPSearchCheckins *searchCheckins = [BPSearchCheckins new];
            searchCheckins.comment = @"Checking in!";
            searchCheckins.limit=25;
            
            [[Buddy checkins] searchCheckins:searchCheckins callback:^(NSArray *buddyObjects, NSError *error) {
                NSArray *cins = buddyObjects;
                
                [[theValue([cins count]) should] beGreaterThan:theValue(0)];
                for(BPCheckin *c in cins) {
                    [[c.comment should] equal:@"Checking in!"];
                }
                
                checkins = buddyObjects;
            }];
            
            //[[expectFutureValue(theValue([checkins count])) shouldEventually] beGreaterThan:theValue(0)];
        });

        it(@"Should allow you to retrieve a specific checkin.", ^{
            __block BPCheckin *retrievedCheckin;
            [[Buddy checkins] getCheckin:tempCheckin.id callback:^(id newBuddyObject, NSError *error) {
                retrievedCheckin = newBuddyObject;
            }];

            [[expectFutureValue(retrievedCheckin.id) shouldEventually] equal:tempCheckin.id];
            [[expectFutureValue(retrievedCheckin.comment) shouldEventually] equal:tempCheckin.comment];
            [[expectFutureValue(retrievedCheckin.description) shouldEventually] equal:tempCheckin.description];
        });

        it(@"Should allow modifying the comment of a checkin.", ^{
            
            tempCheckin.comment = @"My new comment";
            
            [tempCheckin save:^(NSError *error) {
                [tempCheckin refresh:^(NSError *error) {
                    NSLog(@"Checkin saved");
                }];
            
            }];
            
            tempCheckin.comment = @"";
            
            [[expectFutureValue(tempCheckin.comment) shouldEventually] equal:@"My new comment"];
        });
    });
});

SPEC_END
