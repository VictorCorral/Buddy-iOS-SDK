#ifndef BuddySDK_BuddyClientProtocol_h
#define BuddySDK_BuddyClientProtocol_h

#import "BuddyCallbacks.h"

@class BPCoordinate;
@class BPUser;


typedef NS_ENUM(NSInteger, BPConnectivityLevel) {
    /** No network reachability */
    BPConnectivityNone     = 0,
    /** Reachable via carrier or not known */
    BPConnectivityCarrier = 1,
    /** Reachability via WiFi */
    BPConnectivityWiFi = 2,
};

typedef NS_ENUM(NSInteger, BPAuthenticationLevel) {
    /** No authentication */
    BPAuthenticationLevelNone,
    /** App/Device level authentication */
    BPAuthenticationLevelDevice,
    /** User level authentication */
    BPAuthenticationLevelUser
};

@protocol BPClientDelegate <NSObject>

@optional

- (void)userChangedTo:(BPUser *)newUser from:(BPUser *)oldUser;
- (void)connectivityChanged:(NSNumber *)level;
- (void)apiErrorOccurred:(NSError *)error;
- (void)authorizationNeedsUserLogin;

@end

@protocol BuddyClientProtocol <NSObject>

@property (readonly, nonatomic, copy) NSString *appID;
@property (readonly, nonatomic, copy) NSString *appKey;

@property (nonatomic, strong) BPCoordinate *lastLocation;

@property (nonatomic, readonly, assign) BPConnectivityLevel connectivityLevel;

@property (nonatomic, strong) BPUser *currentUser;

@property (nonatomic,weak) id<BPClientDelegate> delegate;

- (void)createUser:(NSString*) userName
          password:(NSString*) password
         firstName:(NSString*) firstName
          lastName:(NSString*) lastName
             email:(NSString*) email
       dateOfBirth:(NSDate*) dateOfBirth
            gender:(NSString*) gender
               tag:(NSString*) tag
          callback:(BuddyObjectCallback)callback;

- (void)loginUser:(NSString *)username password:(NSString *)password callback:(BuddyObjectCallback)callback;
- (void)socialLogin:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback;

- (void)logoutUser:(BuddyCompletionCallback)callback;

- (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;
- (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;
- (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;
- (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;
- (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback;


- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds callback:(BuddyMetricCallback)callback;
- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value callback:(BuddyCompletionCallback)callback;
- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds timestamp:(NSDate*)timestamp callback:(BuddyMetricCallback)callback;

- (void)registerPushTokenWithData:(NSData *)token callback:(BuddyObjectCallback) callback;
- (void)registerPushToken:(NSString *)token callback:(BuddyObjectCallback)callback;
- (void)notifyPushRecieved:(NSDictionary *)data;
@end

#endif
