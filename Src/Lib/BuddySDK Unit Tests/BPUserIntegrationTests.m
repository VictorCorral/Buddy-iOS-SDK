//
//  BPUserTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import "BPIdentityValue.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BPUserIntegrationSpec)

describe(@"BPUser", ^{
    context(@"When a user is logged in", ^{

        __block BOOL fin = NO;
        beforeAll(^{
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        beforeEach(^{
            fin = NO;
        });
        
        it(@"Should be allow modifying and saving", ^{
        
            NSDate *randomDate = [BuddyIntegrationHelper randomDate];
            NSLog(@"Created New Random Date for DOB: %@",randomDate);
            
            NSString *randomNameFirst = [BuddyIntegrationHelper randomString:10];
            NSLog(@"Created New Random First Name: %@",randomNameFirst);
            
            NSString *randomNameLast = [BuddyIntegrationHelper randomString:10];
            NSLog(@"Created New Random Last Name: %@",randomNameLast);

            if (![Buddy user]) {
                NSLog(@"Buddy User is nil");
            }
            
            NSLog(@"Initial DOB: %@", [Buddy user].dateOfBirth);
            NSLog(@"Initial First Name: %@:",[Buddy user].firstName);
            NSLog(@"Initial Last Name: %@:",[Buddy user].lastName);
            
            [Buddy user].dateOfBirth = randomDate;
            [Buddy user].firstName = randomNameFirst;
            [Buddy user].lastName = randomNameLast;
            
            NSLog(@"New DOB: %@", [Buddy user].dateOfBirth);
            
            [[Buddy user] save:^(NSError *error) {
                if (error) {
                    fail(@"Save was unsuccessful");
                }
                [[Buddy user] refresh:^(NSError *error) {
                    NSDate *f = [Buddy user].dateOfBirth;
                    NSLog(@"3333%@", f);
                }];
            }];
            
            [[expectFutureValue([Buddy user].firstName) shouldEventually] equal:randomNameFirst];
            [[expectFutureValue([Buddy user].lastName) shouldEventually] equal:randomNameLast];
            
            [[expectFutureValue([Buddy user].dateOfBirth) shouldEventually] equal:randomDate];
        });
        
        it(@"Should allow the user to set a profile picture", ^{
            
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            [[Buddy user] setUserProfilePicture:image caption:@"Hello" callback:^(NSError *error) {
                [[Buddy user] refresh:^(NSError *error) {
                    [[error should] beNil];
                    
                    [[theValue([[[Buddy user] profilePictureID] length]) should] beGreaterThan:theValue(0)];
                    [[theValue([[[Buddy user] profilePictureUrl] length]) should] beGreaterThan:theValue(0)];

                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        it(@"Should allow the user to retrieve a profile picture", ^{
            
            [[Buddy user] getUserProfilePictureWithSize:BPSizeMake(100,100) callback:^(BPPicture *picture, NSError *error) {
                [[error should] beNil];

                
                [[theValue(picture.size.w) should] equal:theValue(100)];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        it(@"Should allow the user to delete the profile picture", ^{
            [[Buddy user] deleteUserProfilePicture:^(NSError *error) {
                [[error should] beNil];

                [[theValue([[[Buddy user] profilePictureID] length]) should] equal:theValue(0)];
                [[theValue([[[Buddy user] profilePictureUrl] length]) should] equal:theValue(0)];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
    
        it(@"Should allow adding identity values.", ^{
            [[Buddy user] addIdentity:@"Facebook" value:@"sdf" callback:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        __block NSString *identityId;
        it(@"Should allow retrieving identity values.", ^{
            [[Buddy user] getIdentities:@"Facebook" callback:^(NSArray *buddyObjects, NSError *error) {
                [[error should] beNil];
                [[buddyObjects should] haveLengthOfAtLeast:1];
                identityId = [[buddyObjects firstObject] identityProviderID];
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        __block NSString *retrievedUserId;
        it(@"Should allow retrieving a users identity values", ^{
            
            [[Buddy users] getUserIdForIdentityProvider:@"Facebook" identityProviderId:identityId callback:^(NSString *buddyId, NSError *error) {
                [[error should] beNil];
                [[buddyId shouldNot] beNil];
                retrievedUserId = buddyId;
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        it(@"Should allow retrieving a user based on ID", ^{
            [[Buddy users] getUser:retrievedUserId callback:^(id newBuddyObject, NSError *error) {
                [[error should] beNil];
                [[newBuddyObject shouldNot] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        it(@"Should allow searching for users", ^{
            
            BPSearchUsers *searchUsers = [BPSearchUsers new];
            searchUsers.gender = BPUserGender_Unknown;
            
            [[Buddy users] searchUsers:searchUsers callback:^(NSArray *buddyObjects, BPPagingTokens *tokens, NSError *error) {
                [[error should] beNil];
                [[theValue([buddyObjects count]) should] beGreaterThan:theValue(0)];
                [[theValue([[buddyObjects firstObject] gender]) should] equal:theValue(BPUserGender_Unknown)];
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];

        });
        
        it(@"Should then allow deleting identity values.", ^{
            [[Buddy user] removeIdentity:@"Facebook" value:@"sdf" callback:^(NSError *error) {
                [[error should] beNil];
                [[Buddy user] getIdentities:@"Facebook" callback:^(NSArray *buddyObjects, NSError *error) {
                    [[error should] beNil];
                    [[buddyObjects shouldNot] containObjectsInArray:@[@"sdf"]];
                    fin = YES;
                }];
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        it(@"Should allow the user to logout", ^{
            [Buddy logout:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];

        });
        

    });
});

SPEC_END
