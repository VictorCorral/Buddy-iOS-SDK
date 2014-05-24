//
//  UserListIntegrationTests.m
//  BuddySDK
//
//  Created by Nick Ambrose on 5/24/14.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"

#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 60.0

SPEC_BEGIN(BuddyUserListsSpec)

describe(@"BuddyUserListsSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPUserList *tempUserList;
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow you create a User List.", ^{
            
            __block BOOL fin = NO;
            
            tempUserList = [BPUserList new];
            NSString *userListName =[NSString stringWithFormat:@"userList_%@",[BuddyIntegrationHelper randomString:10] ] ;
            tempUserList.name =userListName;
        
            [[Buddy userLists] addUserList:tempUserList callback:^(NSError *error) {
                
                [error shouldBeNil];
                [[tempUserList.id shouldNot] beNil];
                [[tempUserList.name should] equal: userListName];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
            
        });
        
        
        it(@"Should allow you to retrieve a UserList.", ^{
            __block BPUserList *retrievedUserList;
            __block BOOL fin = NO;
            
            [[Buddy userLists] getUserList:tempUserList.id callback:^(id newBuddyObject, NSError *error) {
                [[error should] beNil];
                
                if (error) {
                    fin = YES;
                    return;
                }
                
                retrievedUserList = newBuddyObject;
                
                [[retrievedUserList shouldNot] beNil];
                [[retrievedUserList.id should] equal:tempUserList.id];
                
                [[retrievedUserList.name should] equal:tempUserList.name];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        
         
        it(@"Should allow you to modify a userList.", ^{
            
            __block BPUserList *secondUserList;
            __block BOOL fin = NO;
            
            NSString *secondUserListName =[NSString stringWithFormat:@"userList_%@",[BuddyIntegrationHelper randomString:10] ] ;
            tempUserList.name = secondUserListName;
            
            [tempUserList save:^(NSError *error) {
                [[error should] beNil];
                [[Buddy userLists] getUserList:tempUserList.id callback:^(id newBuddyObject, NSError *error) {
                    [[error should] beNil];
                    secondUserList = newBuddyObject;
                    [[secondUserList shouldNot] beNil];
                    [[secondUserList.name should] equal:secondUserListName];
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        
        it(@"Should allow you to delete a User List.", ^{
            __block BOOL fin = NO;
            __block NSString *userListId =tempUserList.id;
            
            [tempUserList destroy:^(NSError *error) {
                [[error should] beNil];
                [[Buddy userLists] getUserList:userListId callback:^(id newBuddyObject, NSError *error) {
                    [[error shouldNot] beNil];
                    [[newBuddyObject should] beNil];
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
    });
         
});

SPEC_END
