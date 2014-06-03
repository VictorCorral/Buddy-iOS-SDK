//
//  BPUser.h
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import <UIKit/UIKit.h>
#import "BuddyObject.h"
#import "BuddyCollection.h"

@class BPSize;

/**
 Enum for specifying gender.
 */
typedef NS_ENUM(NSInteger, BPUserGender)
{
    /** Unknown */
    BPUserGender_Unknown = 0,
    /** Male */
	BPUserGender_Male = 1,
    /** Female */
	BPUserGender_Female = 2,
};

@protocol BPUserProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) BPUserGender gender;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, readonly, copy) NSString *profilePictureID;
@property (nonatomic, readonly, copy) NSString *profilePictureUrl;
@property (nonatomic, assign) BOOL locationFuzzing;
@property (nonatomic, assign) BOOL celebMode;

@end

@interface BPSearchUsers : BPObjectSearch<BPUserProperties>

@property (nonatomic,strong) NSString *userListId;

@end

@interface BPUser : BuddyObject<BPUserProperties>

- (NSInteger)age;

- (void)requestPasswordResetWithSubject:(NSString *)subject body:(NSString *)body callback:(BuddyObjectCallback)callback;
- (void)resetPassword:(NSString *)resetCode newPassword:(NSString *)newPassword callback:(BuddyCompletionCallback)callback;
- (void)addIdentity:(NSString *)identityProvider value:(NSString *)value callback:(BuddyCompletionCallback)callback;
- (void)removeIdentity:(NSString *)identityProvider value:(NSString *)value callback:(BuddyCompletionCallback)callback;
- (void)getIdentities:(NSString *)identityProvider callback:(BuddyCollectionCallback)callback;
- (void)setUserProfilePicture:(UIImage *)picture caption:(NSString *)comment callback:(BuddyCompletionCallback)callback;
- (void)getUserProfilePictureWithSize:(BPSize *)size callback:(BuddyObjectCallback)callback;
- (void)deleteUserProfilePicture:(BuddyCompletionCallback)callback;

@end
