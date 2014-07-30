//
//  Buddy.h
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import <Foundation/Foundation.h>

#import "BuddyObject.h"
#import "BuddyDevice.h"
#import "BPAlbumItem.h"
#import "BPClient.h"
#import "BPCheckin.h"
#import "BPCheckinCollection.h"
#import "BPAlbumCollection.h"
#import "BPPicture.h"
#import "BPUser.h"
#import "BPPictureCollection.h"
#import "BPVideoCollection.h"
#import "BPBlobCollection.h"
#import "BPUserCollection.h"
#import "BPCoordinate.h"
#import "BPDateRange.h"
#import "BPBlob.h"
#import "BPAlbum.h"
#import "BPLocationCollection.h"
#import "BPLocation.h"
#import "BPMetricCompletionHandler.h"
#import "BPMetadataItem.h"
#import "BPUserListCollection.h"
#import "BPNotification.h"
#import "BPIdentityValue.h"
#import "BPSize.h"
#import "BPPagingTokens.h"

// Models
#import "BPModelUser.h"
#import "BPModelCheckin.h"
#import "BPModelSearch.h"


/**
 * TODO
 *
 * @since v2.0
 */
@interface Buddy : NSObject

 /* The currently logged in user. Will be nil if no login session has occurred.
 */
+ (BPUser *)user;

/**
 * Used to check if location information is automatically being sent to the server or not.
 *
 * If set to YES then location information will automatically be sent to the server.
 * If set to NO then location information will not be sent.
 *
 * Default: NO
 *
 */
+ (BOOL) locationEnabled;

+ (BPClient*) currentClient;

/**
 * Determines whether location information will be automatically sent to the server or not.
 *
 * @param enabled     If set to YES then location information will automatically be sent to the server.
 *                    If set to NO then location information will not be sent.
 *
 *                    Default: NO
 */
+ (void) setLocationEnabled:(BOOL)enabled;

+ (void)setClientDelegate:(id<BPClientDelegate>)delegate;

/**
 *
 * Initialize the Buddy SDK with your App ID and App Key.
 *
 * @param appID  Your application ID.
 *
 * @param appKey Your application key.
 *
 */
+ (BPClient*)initClient:(NSString *)appID
            appKey:(NSString *)appKey;


/**
 *
 * Create a new Buddy User.
 *
 * @param user     A BPUser object populated with the users information.
 *
 * @param password The new user's password.
 *
 */
+ (void)createUser:(BPUser *)user password:(NSString *)password callback:(BuddyCompletionCallback)callback;
+ (void)createUser:(NSString*) userName
          password:(NSString*) password
         firstName:(NSString*) firstName
          lastName:(NSString*) lastName
             email:(NSString*) email
       dateOfBirth:(NSDate*) dateOfBirth
            gender:(NSString*) gender
               tag:(NSString*) tag
          callback:(BuddyCompletionCallback)callback;


/**
 *
 * Login a user using the provided username and password.
 *
 * @param username  The username of the user.
 *
 * @param password  The user's password.
 *
 */
+ (void)login:(NSString *)username password:(NSString *)password callback:(BuddyObjectCallback)callback;
+ (void)loginUser:(NSString *)username password:(NSString *)password callback:(BuddyObjectCallback)callback;

/**
 *
 * Login using a social provider such as Facebook or Twitter.
 *
 */
+ (void)socialLogin:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback;

/**
 *
 * Logout the current user.
 *
 */
+ (void)logout:(BuddyCompletionCallback)callback;

/* 
 * Send a push Notification to one or more users, or user lists.
 *
 * @param notification  a BPNotification object with the notification information populated.
 * 
 * @callback            a callback that is called once the server has accepted the request.
 *                      NOTE: The server sends push notifications asynchronously so the callback
 *                            may be called before all notifications have been sent out.
 *
 */
+ (void)sendPushNotification:(BPNotification *)notification callback:(BuddyCompletionCallback)callback;

/** 
 * Records a metric.
 *
 * Signals completion via the BuddyCompletion callback.
 *
 * @param key       The name of the metric.
 *
 * @param value     The value of the metric.
 *
 * @param callback  A callback that is called once the server has processed the request.
 *
 */
+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value callback:(BuddyCompletionCallback)callback;

/** 
 * Records a timed metric.
 * @param key     The name of the metric.
 *
 * @param value   The value of the metric.
 *
 * @param timeout The time after which the metric automatically expires (in seconds).
 *
 * @param callback A callback that returns the ID of the metric which allows the metric to be signaled as finished
                 via "finishMetric."
 *
 */
+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds callback:(BuddyMetricCallback)callback;

/**
 * Records a timed metric.
 * @param key       The name of the metric.
 *
 * @param value     The value of the metric.
 *
 * @param timeout   The time after which the metric automatically expires (in seconds). If this value is set to zero, the parameter is not sent to the server
 *
 * @param timestamp The time at which the metric occurred
 *
 * @param callback  A callback that returns the ID of the metric which allows the metric to be signaled as finished
 via "finishMetric."
 *
 */
+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds timestamp:(NSDate*)timestamp callback:(BuddyMetricCallback)callback;

/**
 * REST calls
 */
+ (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;
+ (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;
+ (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;
+ (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;
+ (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;

@end
