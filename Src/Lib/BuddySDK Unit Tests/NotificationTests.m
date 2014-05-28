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

SPEC_BEGIN(NotificationsSpec)

describe(@"Notifications", ^{
    context(@"When an app has a valid device token", ^{
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
        
        afterAll(^{
        });
        
        it(@"Should allow sending a notification", ^{
            
            BPNotification *note = [BPNotification new];
            note.recipients = @[[Buddy user].id];
            note.message = @"Message";
            note.payload = @"Payload";
            note.osCustomData = @"{}";
            note.notificationType = BPNotificationType_Raw;
            
            [Buddy sendPushNotification:note callback:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow sending a notification to a user list", ^{
            
            __block BOOL fin = NO;
            __block BPUserList *tempUserList;
            tempUserList = [BPUserList new];
            __weak BPUserList *tempUserList2 =tempUserList;
            NSString *userListName =[NSString stringWithFormat:@"userList_%@",[BuddyIntegrationHelper randomString:10] ] ;
            tempUserList.name =userListName;
            
            [[Buddy userLists] addUserList:tempUserList callback:^(NSError *error) {
                
                [error shouldBeNil];
                [[tempUserList.id shouldNot] beNil];
                [[tempUserList.name should] equal: userListName];
                
                [tempUserList addUser:Buddy.user callback:^(BOOL result, NSError *error) {
                    [[error should] beNil];
                    [[theValue(result) shouldNot] equal: NO];
                    
                    BPNotification *note = [BPNotification new];
                    note.recipients = @[tempUserList2.id];
                    note.message = @"Message";
                    note.payload = @"Payload";
                    note.osCustomData = @"{}";
                    note.notificationType = BPNotificationType_Raw;
                    
                    [Buddy sendPushNotification:note callback:^(NSError *error) {
                        [[error should] beNil];
                        fin = YES;
                    }];
                }];
                
            }];
            
            
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
    });
});

SPEC_END
