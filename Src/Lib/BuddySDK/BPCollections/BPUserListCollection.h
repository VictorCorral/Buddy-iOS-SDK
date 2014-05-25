//
//  BPUserListCollection.h
//  BuddySDK
//
//  Created by Nick Ambrose on 5/24/14.
//
//

#import <Foundation/Foundation.h>
#import "BPUserList.h"

@interface BPUserListCollection : BuddyCollection

- (void)addUserList:(BPUserList *)userList
        callback:(BuddyCompletionCallback)callback;

- (void)getUserList:(NSString *)userListId callback:(BuddyObjectCallback)callback;

- (void)searchUserLists:(BPSearchUserList *)searchUserList callback:(BuddyCollectionCallback)callback;

@end
