//
//  BuddyIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/25/13.
//
//

#import "Buddy.h"
#import <Kiwi/Kiwi.h>
#import "BPAppSettings+Private.h"
#import "BuddyIntegrationHelper.h"

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 4.0


SPEC_BEGIN(BuddyIntegrationSpec)

describe(@"Buddy", ^{
    context(@"A clean boot of your app", ^{
        
        __block NSString *testCreateDeleteName = @"ItPutsTheLotionOnItsSkin";
        __block id mock = nil;
        __block BOOL fin = NO;

        beforeAll(^{
            
            [BPAppSettings resetSettings:nil];
            
            [Buddy initClient:APP_ID appKey:APP_KEY];
            
            [Buddy login:testCreateDeleteName password:TEST_PASSWORD callback:^(BPUser *loggedInsUser, NSError *error) {
                if (!error) {
                    [loggedInsUser destroy:^(NSError *error){
                        fin = YES;
                    }];
                } else {
                    fin = YES;
                }
            }];
            
            mock = [KWMock mockForProtocol:@protocol(BPClientDelegate)];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        beforeEach(^{
            fin = NO;
        });
        
        afterAll(^{

        });
        
        it(@"Should throw an auth error if they try to access pictures.", ^{
            [Buddy setClientDelegate:mock];
            
            [[mock shouldEventually] receive:@selector(apiErrorOccurred:)];
            [[[mock shouldEventually] receive] authorizationNeedsUserLogin];
            [[Buddy pictures] searchPictures:nil callback:^(NSArray *buddyObjects, BPPagingTokens *tokens, NSError *error) {
                [Buddy setClientDelegate:nil];
            }];
        });
        
        it(@"Should allow you to create a user.", ^{
            __block NSDate *randomDate = [BuddyIntegrationHelper randomDate];

            __block BPUser *newUser = [BPUser new];
            newUser.firstName = @"Erik";
            newUser.lastName = @"Kerber";
            newUser.gender = BPUserGender_Female;
            newUser.email = TEST_EMAIL;
            newUser.dateOfBirth = randomDate;
            newUser.userName = testCreateDeleteName;
            
            [Buddy createUser:newUser password:TEST_PASSWORD callback:^(NSError *error) {
                [[error should] beNil];
                if (error) {
                    fin = YES;
                    return;
                }
                [[newUser.userName should] equal:testCreateDeleteName];
                [[newUser.firstName should] equal:@"Erik"];
                [[newUser.lastName should] equal:@"Kerber"];
                [[theValue(newUser.gender) should] equal:theValue(BPUserGender_Female)];
                [[newUser.dateOfBirth should] equal:randomDate];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow you to login.", ^{
            __block BPUser *newUser;
            
            [Buddy setClientDelegate:mock];
            
            // Leaving in inline comment below. Can't verify it receives the object before the object exists.
            [[mock shouldEventually] receive:@selector(userChangedTo:from:) /*withArguments:[Buddy user], nil*/];

            [Buddy login:testCreateDeleteName password:TEST_PASSWORD callback:^(BPUser *loggedInsUser, NSError *error) {
                newUser = loggedInsUser;
                [Buddy setClientDelegate:nil];
            }];
            
            [[expectFutureValue(newUser.userName) shouldEventually] equal:testCreateDeleteName];
        });
        
        it(@"Should raise a notification of changing of a user.", ^{
            __block BOOL fin = NO;
            [Buddy login:testCreateDeleteName password:TEST_PASSWORD callback:^(BPUser *loggedInsUser, NSError *error) {
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow you to delete a user.", ^{
            __block BOOL deleted = NO;
            
            [Buddy login:testCreateDeleteName password:TEST_PASSWORD callback:^(BPUser *loggedInsUser, NSError *error) {
                [[error should] beNil];
                [loggedInsUser destroy:^(NSError *error){
                    [[error should] beNil];
                    deleted = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(deleted)) shouldEventually] beYes];

        });
    });
});

SPEC_END
