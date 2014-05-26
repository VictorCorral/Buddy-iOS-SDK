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

/**
 * Creates a user list.
 *
 * @param userList        The user list to create. This will be populated with a valid UserList id on success.
 *
 * @param callback        A callback to be called with the response.
 *
 */
- (void)addUserList:(BPUserList *)userList
        callback:(BuddyCompletionCallback)callback;

/**
 * Gets a specific user list.
 *
 * @param userListId      The id of the user list to get.
 *
 * @param callback        A callback to be called with the response.
 *                        On success the UserList will be passed to the callback.
 *
 */
- (void)getUserList:(NSString *)userListId callback:(BuddyObjectCallback)callback;

/**
 * Search for user lists.
 *
 * @param searchUserList  The properties to search for.
 *
 * @param callback        A callback to be called with the response.
 *                        The matching UserLists will be passed to the callback.
 *
 */
- (void)searchUserLists:(BPSearchUserList *)searchUserList callback:(BuddyCollectionCallback)callback;

@end
