//
//  BPUserList.h
//  BuddySDK
//
//  Created by Nick Ambrose on 5/24/14.
//
//

#import <Foundation/Foundation.h>

#import "BPBase.h"

@class BPUser;

/**
 * Enum for specifying UserListItemType.
 */
typedef NS_ENUM(NSInteger, BPUserListItemType)
{
    /** User */
    BPUserListItem_User =0,
    
    /** UserList */
    BPUserListItem_UserList=1
};

@protocol BPUserListProperties <BuddyObjectProperties>
@property (nonatomic, copy) NSString *name;

@end

@interface BPSearchUserList : BPObjectSearch<BPUserListProperties>
@end

@protocol BPUserListItemProperties

@property (nonatomic,assign) BPUserListItemType itemType;
@property (nonatomic,copy) NSString *id;

@end


@interface BPUserList : BuddyObject<BPUserListProperties>

/**
 * Adds the id of the user to the user list.
 *
 * @param user        The users who's ID to add.
 *
 * @param callback    A callback to be called with a response.
 *                    If error is nil then the result will be YES if the user ID was not already in the List.
 *                    Or NO if the user ID was already present in the list.
 *
 */
- (void)addUser:(BPUser *)user
       callback:(BuddyResultCallback)callback;

/**
 * Adds the id of the User to the UserList.
 *
 * @param user        The users who's ID to add.
 *
 * @param callback    A callback to be called with a response.
 *                    If error is nil then the result will be YES if the user ID was not already in the List.
 *                    Or NO if the user ID was already present in the list.
 *
 */
- (void)addUserId:(NSString*)userId
       callback:(BuddyResultCallback)callback;

/**
 * Deletes the id of the User from the user list.
 *
 * @param user        The users who's ID to delete.
 *
 * @param callback    A callback to be called with a response.
 *                    If error is nil then the result will be YES if the user ID was deleted from the List.
 *                    Or NO if the user ID was not present in the list.
 *
 */
- (void)deleteUser:(BPUser *)user
       callback:(BuddyResultCallback)callback;

/**
 * Deletes the id of the User from the user list.
 *
 * @param user        The users who's ID to delete.
 *
 * @param callback    A callback to be called with a response.
 *                    If error is nil then the result will be YES if the user ID was deleted from the list.
 *                    Or NO if the user ID was not present in the list.
 *
 */
- (void)deleteUserId:(NSString*)userId
         callback:(BuddyResultCallback)callback;

@end

@interface BPUserListItem : BuddyObject<BPUserListItemProperties>

@end
