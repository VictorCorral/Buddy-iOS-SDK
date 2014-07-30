//
//  CheckinIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(PasswordReset)

describe(@"Password Reset", ^{
    context(@"When an app has a valid device token", ^{
        __block BOOL fin = NO;
        
        __block BPClient* client;
        
        beforeAll(^{
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            client = [Buddy currentClient];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
        });
        
        beforeEach(^{
            fin = NO;
        });
        
        /*
         * NOTE: Leave these as pending_ for automated tests. Password reset testing needs manual intervention at the email level.
         */
        pending_(@"Should provide a method to request a password reset.", ^{
            
            [[client user] requestPasswordResetWithSubject:@"Your new password"
                                                     body:@"Here is your reset code: @ResetCode"
                                                 callback:^(id newBuddyObject, NSError *error)
             {
                 [[error should] beNil];
                 fin = YES;
             }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        pending_(@"Should then a method to reset the password with a reset code.", ^{
            
            NSString *newPassword = @"vnnrl";
            
            [[client user] resetPassword:@"vnnrl" newPassword:newPassword callback:^(NSError *error) {
                [[error should] beNil];
                [Buddy login:TEST_USERNAME password:newPassword callback:^(id newBuddyObject, NSError *error) {
                    [[error should] beNil];
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
            
        });
    });
});

SPEC_END
