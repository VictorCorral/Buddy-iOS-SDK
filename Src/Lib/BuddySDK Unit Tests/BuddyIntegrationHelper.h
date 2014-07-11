//
//  BuddyIntegrationHelper.h
//  BuddySDK
//
//  Created by Erik Kerber on 12/29/13.
//
//

#import <Foundation/Foundation.h>

@class BPUser;
@class BPClient;

@interface BuddyIntegrationHelper : NSObject

+ (void) bootstrapInit;

+ (void) bootstrapLogin:(void(^)())callback;

+ (NSDate *)randomDate;

+ (NSString *)randomString:(int)len;

/**
 * If username/email are set in the passed-in user, will not overwrite it and will use that username
 * (good for creating users with a common prefix for search 
 *
 * NOTE: The users passwords are set to the same as their username so you can log them back in later easily
 *
 */
+(void)createRandomUser:(BPUser *)user withClient:(BPClient*)client callback:(BuddyCompletionCallback)callback;

/**
 * Creates "count" random users
 * 
 * Users are created with a pattern for username with a random portion following by an underscort and and increasing number
 * e.g. bvzry_1, bzry_2m bzry_3 to allow for use in search test cases.
 * The users may not be in sorted order in the users array after completion.
 *
 * @param users         An array that will be populated with the users. Must be allocated (non-nil).
 *
 * @param count         Number of users to create.
 *
 * @param callback      A callback to be called when either all users are created or an error has occurred.
 *                      If an error occurs, the error in the callback will be set to ONE of the server errors.
 *                      Not necessarily the first
 *
 * NOTE: The users passwords are set to the same as their username so you can log them back in later easily
 */

+(void)createRandomUsers:(NSMutableArray*)users
                   count:(int)count
                callback:(BuddyCompletionCallback)callback;

/**
 * Attempts to delete the users via the supplied client
 * 
 * @param users     The array of users to delete
 *
 * @param callback  A callback that is called when all responses from the server are received.
 *                  If all users were successfully deleted, then error will be nil
 *                  If an error occurs, the error in the callback will be set to ONE of the server errors.
 *                  Not necessarily the first
 */
+(void)deleteUsers:(NSArray*)users callback:(BuddyCompletionCallback)callback;

+(NSString*) getUUID;
@end
