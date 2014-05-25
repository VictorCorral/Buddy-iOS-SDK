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
Enum for specifying UserListItemType.
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

- (void)addUser:(BPUser *)user
       callback:(BuddyResultCallback)callback;

- (void)addUserId:(NSString*)userId
       callback:(BuddyResultCallback)callback;

- (void)deleteUser:(BPUser *)user
       callback:(BuddyResultCallback)callback;

- (void)deleteUserId:(NSString*)userId
         callback:(BuddyResultCallback)callback;

@end

@interface BPUserListItem : BuddyObject<BPUserListItemProperties>

@end
