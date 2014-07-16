///
//  BPClient.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "BPClient.h"
#import "BPServiceController.h"
#import "BPCheckinCollection.h"
#import "BPPictureCollection.h"
#import "BPVideoCollection.h"
#import "BPUserCollection.h"
#import "BPAlbumCollection.h"
#import "BPBlobCollection.h"
#import "BPLocationCollection.h"
#import "BPUserListCollection.h"
#import "BPRestProvider.h"
#import "BuddyObject+Private.h"
#import "BPLocationManager.h"
#import "BPNotificationManager.h"
#import "BuddyDevice.h"
#import "BPAppSettings.h"
#import "BuddyAppDelegateDecorator.h"
#import "BPCrashManager.h"
#import "BPUser+Private.h"
#import "BuddyObject+Private.h"
#import "NSDate+JSON.h"
#import "BPAFURLRequestSerialization.h"

#import "BuddyFile.h"

#import <CoreFoundation/CoreFoundation.h>
#define BuddyServiceURL @"BuddyServiceURL"

#define BuddyDefaultURL @"https://api.buddyplatform.com"

#define HiddenArgumentCount 2

@interface BPClient()<BPRestProvider,BPRestProviderOld, BPLocationDelegate, BPLocationProvider>

@property (nonatomic, strong) BPServiceController *service;
@property (nonatomic, strong) BPAppSettings *appSettings;
@property (nonatomic, strong) BPLocationManager *location;
@property (nonatomic, strong) BPNotificationManager *notifications;
@property (nonatomic, strong) BuddyAppDelegateDecorator *decorator;
@property (nonatomic, strong) BPCrashManager *crashManager;
@property (nonatomic, strong) NSMutableArray *queuedRequests;

- (void)recordMetricCore:(NSString*)key parameters:(NSDictionary*)parameters callback:(BuddyMetricCallback)callback;

@end

@implementation BPClient

@synthesize user=_user;
@synthesize checkins=_checkins;
@synthesize pictures =_pictures;
@synthesize videos = _videos;
@synthesize blobs = _blobs;
@synthesize albums = _albums;
@synthesize locations = _locations;
@synthesize users = _users;
@synthesize userLists = _userLists;
#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _notifications = [[BPNotificationManager alloc] initWithClient:self];
        _location = [BPLocationManager new];
        _location.delegate = self;
        [self addObserver:self forKeyPath:@"user.deleted" options:NSKeyValueObservingOptionNew context:nil];
//        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            switch (status) {
//                case AFNetworkReachabilityStatusNotReachable:
//                case AFNetworkReachabilityStatusUnknown:
//                    _reachabilityLevel = BPReachabilityNone;
//                    break;
//                case AFNetworkReachabilityStatusReachableViaWWAN:
//                    _reachabilityLevel = BPReachabilityCarrier;
//                    break;
//                case AFNetworkReachabilityStatusReachableViaWiFi:
//                    _reachabilityLevel = BPReachabilityWiFi;
//                    break;
//                default:
//                    break;
//            }
//            
//#if !(TARGET_IPHONE_SIMULATOR)
//            [self raiseReachabilityChanged:_reachabilityLevel];
//#endif
//        }];
//        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
    }
    return self;
}

- (void)resetOnLogout
{
    _user = nil;
    
    _users = nil;
    _checkins = nil;
    _pictures = nil;
    _blobs = nil;
    _albums = nil;
    _locations = nil;
    _userLists=nil;
    
    [self.appSettings clearUser];
}

-(void)setupWithApp:(NSString *)appID
             appKey:(NSString *)appKey
            options:(NSDictionary *)options
           delegate:(id<BPClientDelegate>) delegate
{
    
#if DEBUG
    // Annoying nuance of running a unit test "bundle".
    NSString *serviceUrl = [[NSBundle bundleForClass:[self class]] infoDictionary][BuddyServiceURL];
#else
    NSString *serviceUrl = [[NSBundle mainBundle] infoDictionary][BuddyServiceURL];
#endif

    serviceUrl = serviceUrl ?: @"https://api.buddyplatform.com";
    
    if (options[@"BPTestAppPrefix"]) {
        _appSettings = [[BPAppSettings alloc] initWithAppId:appID andKey:appKey initialURL:serviceUrl prefix:options[@"BPTestAppPrefix"]];
    } else {
        _appSettings = [[BPAppSettings alloc] initWithAppId:appID andKey:appKey initialURL:serviceUrl];
    }
    
    _service = [[BPServiceController alloc] initWithAppSettings:_appSettings];
    
    _appSettings.appKey = appKey;
    _appSettings.appID = appID;
    
    _crashManager = [[BPCrashManager alloc] initWithRestProvider:[self restService]];
    
    if(![options[@"disablePush"] boolValue]){
        [self registerForPushes];
    }
    
    if (_appSettings.token) {
        BPUser *restoredUser = [[BPUser alloc] initWithId:_appSettings.userID andClient:self];
        restoredUser.accessToken = self.appSettings.userToken;
        [restoredUser refresh:^(NSError *error) {
            self.user = restoredUser;
        }];
    }
}


-(void) registerForPushes {
    UIApplication* app = [UIApplication sharedApplication];
    //wrap the app delegate in a buddy decorator
    self.decorator = [BuddyAppDelegateDecorator  appDelegateDecoratorWithAppDelegate:app.delegate client:self andSettings:_appSettings];
    app.delegate = self.decorator;
    [app registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeNewsstandContentAvailability | UIRemoteNotificationTypeNone | UIRemoteNotificationTypeSound];
    
}


# pragma mark -
# pragma mark Singleton
+(instancetype)defaultClient
{
    static BPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

#pragma mark - Collections


- (BPUser *) user
{
    if(!_user)
    {
        [self raiseNeedsLoginError];
    }
    return _user;
}

- (void)setUser:(BPUser *)user
{
    BPUser *oldUser = _user;
    
    _user = user;
    self.appSettings.userToken = _user.accessToken;
    self.appSettings.userID = _user.id;
    // TODO - Create an auth-level change delegate method?
    self.appSettings.lastUserID = _user.id;
    
    if (!_user) {
        [self.appSettings clearUser];
    }
    
    [self raiseUserChangedTo:_user from:oldUser];
}

-(BPUserCollection *)users
{
    if(!_users)
    {
        _users = [[BPUserCollection alloc] initWithClient:self];;
    }
    return _users;
}

-(BPCheckinCollection *)checkins
{
    if(!_checkins)
    {
        _checkins = [[BPCheckinCollection alloc] initWithClient:self];;
    }
    return _checkins;
}

-(BPPictureCollection *)pictures
{
    if(!_pictures)
    {
        _pictures = [[BPPictureCollection alloc] initWithClient:self];
    }
    return _pictures;
}

-(BPVideoCollection *)videos
{
    if(!_videos)
    {
        _videos = [[BPVideoCollection alloc] initWithClient:self];
    }
    return _videos;
}


-(BPBlobCollection *)blobs
{
    if(!_blobs)
    {
        _blobs = [[BPBlobCollection alloc] initWithClient:self];
    }
    return _blobs;
}

-(BPAlbumCollection *)albums
{
    if(!_albums)
    {
        _albums = [[BPAlbumCollection alloc] initWithClient:self];
    }
    return _albums;
}

-(BPLocationCollection *)locations
{
    if(!_locations)
    {
        _locations = [[BPLocationCollection alloc] initWithClient:self];
    }
    return _locations;
}

-(BPUserListCollection *)userLists
{
    if(!_userLists)
    {
        _userLists = [[BPUserListCollection alloc] initWithClient:self];
    }
    return _userLists;
}

#pragma mark - User

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[BPUser class]] && [keyPath isEqualToString:@"user.deleted"]) {
        _user = nil;
    }
}

- (void)createUser:(BPUser *)user
          password:(NSString *)password
          callback:(BuddyCompletionCallback)callback
{
    NSDictionary *parameters = @{ @"password": password };
    
    id options = [user buildUpdateDictionary];

    parameters = [NSDictionary dictionaryByMerging:parameters with:options];
    
    [user savetoServerWithSupplementaryParameters:parameters client:self.client callback:^(NSError *error) {
        if (error) {
            callback ? callback(error) : nil;
            return;
        }
        
        self.user = user;
        self.appSettings.userToken = self.user.accessToken;
        
        callback ? callback(error) : nil;
    }];
}

#pragma mark - Login

-(void)loginWorker:(NSString *)username password:(NSString *)password success:(BuddyObjectCallback) callback
{
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password};
    [self POST:@"users/login" parameters:parameters class:[NSDictionary class] callback:^(id json, Class clazz,NSError *error) {
        callback ? callback(json, error) : nil;
    }];
}

-(void)socialLoginWorker:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback
{
    NSDictionary *parameters = @{@"identityProviderName": provider,
                                 @"identityId": providerId,
                                 @"identityAccessToken": token};
    
    [self POST:@"users/login/social" parameters:parameters class:[NSDictionary class] callback:^(id json, Class clazz,NSError *error) {
        callback ? callback(json, error) : nil;
    }];
}

- (void)login:(NSString *)username password:(NSString *)password callback:(BuddyObjectCallback)callback
{
    [self loginWorker:username password:password success:^(id json, NSError *error) {
        
        if(error) {
            callback ? callback(nil, error) : nil;
            return;
        }
        
        BPUser *user = [[BPUser alloc] initBuddyWithResponse:json andClient:self];
        self.appSettings.userToken = user.accessToken;
        
        [user refresh:^(NSError *error) {
            self.user = user;
            callback ? callback(user, error) : nil;
        }];
        
    }];
}

- (void)socialLogin:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback;
{
    [self socialLoginWorker:provider providerId:providerId token:token success:^(id json, NSError *error) {
        
        if (error) {
            callback ? callback(nil, error) : nil;
            return;
        }
        
        BPUser *user = [[BPUser alloc] initBuddyWithResponse:json andClient:self];
        self.appSettings.userToken = user.accessToken;

        [user refresh:^(NSError *error){
            self.user = user;
            callback ? callback(user, error) : nil;
        }];
    }];
}


- (void)logout:(BuddyCompletionCallback)callback
{
    NSString *resource = @"users/me/logout";
    
    [self POST:resource parameters:nil class:[NSDictionary class] callback:^(id json, Class clazz, NSError *error) {
        if (!error) {
            [self resetOnLogout];
        }
        
        callback ? callback(error) : nil;
    }];
}

-(void) registerPushToken:(NSString *)token callback:(BuddyObjectCallback)callback
{
    self.appSettings.devicePushToken = token;
    NSString *resource = @"devices/current";
    [self PATCH:resource parameters:@{@"pushToken": token} class:[NSDictionary class] callback:^(id json, Class clazz, NSError *error) {
        callback ? callback(error,json) : nil;
    }];
}


#pragma mark - Utility

-(void)ping:(BPPingCallback)callback
{
    [self GET:@"ping" parameters:nil class:[NSDictionary class] callback:^(id json, Class clazz, NSError *error) {
        callback ? callback([NSDecimalNumber decimalNumberWithString:@"2.0"]) : nil;
    }];
}

#pragma mark - Old BPRestProvider
- (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback
{
    [self checkDeviceToken:^{
        [self.service GET:servicePath parameters:[self injectLocation:parameters] callback:[self handleResponseOld:callback]];
    }];
}

- (void)GET_FILE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback
{
    [self checkDeviceToken:^{
        [self.service GET_FILE:servicePath parameters:[self injectLocation:parameters] callback:[self handleResponseOld:callback]];
    }];
}

- (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback
{
    [self checkDeviceToken:^{
        [self.service POST:servicePath parameters:[self injectLocation:parameters] callback:[self handleResponseOld:callback]];
    }];
}

- (void)MULTIPART_POST:(NSString *)servicePath parameters:(NSDictionary *)parameters data:(NSDictionary *)data mimeType:(NSString *)mimeType callback:(RESTCallbackOld)callback
{
    [self checkDeviceToken:^{
        [self.service MULTIPART_POST:servicePath parameters:[self injectLocation:parameters] data:data mimeType:mimeType callback:[self handleResponseOld:callback]];
    }];
}

- (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback
{
    [self checkDeviceToken:^{
        [self.service PATCH:servicePath parameters:[self injectLocation:parameters] callback:[self handleResponseOld:callback]];
    }];
}

- (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback
{
    [self checkDeviceToken:^{
        [self.service PUT:servicePath parameters:[self injectLocation:parameters] callback:[self handleResponseOld:callback]];
    }];
}

- (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback
{
    [self checkDeviceToken:^{
        [self.service DELETE:servicePath parameters:parameters callback:[self handleResponseOld:callback]];
    }];
}


#pragma mark - BPRestProvider

- (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        if(clazz ==[BuddyFile class])
        {
            [self.service REST_GET_FILE:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
        }
        else
        {
            [self.service REST_GET:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
        }
    }];
}

- (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        // We check if any of the parameters are files or not, and separate files from non-files.
        NSMutableDictionary *nonFiles = [NSMutableDictionary new];
        NSMutableDictionary *files =[NSMutableDictionary new];
        
        for(NSString *name in [parameters allKeys]){
            id object = [parameters objectForKey:name];
            if([object isKindOfClass:[BuddyFile class]])
            {
                [files setObject:object forKey:name];
            }
            else
            {
                [nonFiles setObject:object forKey:name];
            }
        }
        
        if([files count]>0)
        {
            // We have some files
            [self.service REST_MULTIPART_POST:servicePath parameters:[self convertDictionaryForUpload:nonFiles] data:files callback:[self handleResponse:clazz callback:callback]];
        }
        else
        {
            [self.service REST_POST:servicePath parameters:[self convertDictionaryForUpload:nonFiles] callback:[self handleResponse:clazz callback: callback]];
        }

    }];
}

- (void)MULTIPART_POST:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class) clazz data:(NSDictionary *)data mimeType:(NSString *)mimeType callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        [self.service REST_MULTIPART_POST:servicePath parameters:[self convertDictionaryForUpload:parameters] data:data mimeType:mimeType callback:[self handleResponse:clazz callback:callback]];
    }];
}

- (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        [self.service REST_PATCH:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
    }];
}

- (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        [self.service REST_PUT:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
    }];
}

- (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        [self.service REST_DELETE:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
    }];
}

// Data struct to keep track of requests waiting on device token.
- (void)checkDeviceToken:(void(^)())method
{
    [method copy];
    
    if (!self.queuedRequests) {
        self.queuedRequests = [NSMutableArray array];
    }
    
    if ([self.appSettings.deviceToken length] > 0) {
        method();
    } else {
        @synchronized (self) {
            if ([self.queuedRequests count] > 0) {
                [self.queuedRequests addObject:method];
                return;
            }
            else {
                [self.queuedRequests addObject:method];
                
                NSDictionary *getTokenParams = @{
                                                 @"appId": BOXNIL(self.appSettings.appID),
                                                 @"appKey": BOXNIL(self.appSettings.appKey),
                                                 @"Platform": @"iOS",
                                                 @"UniqueId": BOXNIL([BuddyDevice identifier]),
                                                 @"Model": BOXNIL([BuddyDevice deviceModel]),
                                                 @"OSVersion": BOXNIL([BuddyDevice osVersion]),
                                                 @"DeviceToken": BOXNIL(self.appSettings.devicePushToken),
                                                 @"AppVersion": BOXNIL(self.appSettings.appVersion)
                                                 };
                [self.service POST:@"devices" parameters:getTokenParams callback:[self handleResponseOld:^(id json, NSError *error) {
                    // Grab the potentially different base url.
                    if (json[@"accessToken"] && ![json[@"accessToken"] isEqualToString:self.appSettings.token]) {
                        self.appSettings.deviceToken = json[@"accessToken"];
                        
                        // We have a device token. Start monitoring for crashes.
                        [self.crashManager startReporting:self.appSettings.deviceToken];
                    }
                    
                    for (void(^block)() in self.queuedRequests) {
                        block();
                    }
                    
                    [self.queuedRequests removeAllObjects];
                }]];
            }
        }
    }
}

#pragma mark - Old Response Handler
- (ServiceResponse) handleResponseOld:(RESTCallbackOld)callback
{
    return ^(NSInteger responseCode, id response, NSError *error) {
        NSLog (@"Framework: handleResponse");
        
        NSError *buddyError;
        
        id result = response;
        
        // Is it a JSON response (as opposed to raw bytes)?
        if(result && [result isKindOfClass:[NSDictionary class]]) {
            
            // Grab the result
            result = response[@"result"] ?: result;
            
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                // Grab the access token
                if (result[@"serviceRoot"]) {
                    self.appSettings.serviceUrl = result[@"serviceRoot"];
                }
            }
        }
        
        result = result ?: [NSDictionary new];
        id responseObject = nil;
        
        switch (responseCode) {
            case 200:
            case 201:
                responseObject = result;
                break;
            case 400:
            case 401:
            case 402:
            case 403:
            case 404:
            case 405:
            case 500:
                buddyError = [NSError buildBuddyError:result];
                break;
            default:
                buddyError = [NSError bp_noInternetError:error.code message:result];
                break;
        }
        if([buddyError needsLogin]) {
            [self.appSettings clearUser];
            [self raiseNeedsLoginError];
        }
        if([buddyError credentialsInvalid]) {
            [self.appSettings clear];
        }
        if (buddyError) {
            [self raiseAPIError:buddyError];
        }
        
        callback(responseObject, buddyError);
    };
}


#pragma mark - Response Handlers

- (REST_ServiceResponse) handleResponse:(Class) clazz callback:(RESTCallback)callback
{
    return ^(NSInteger responseCode, NSDictionary *responseHeaders, id response, NSError *error) {
        NSLog (@"Framework: handleResponse");
        
        NSError *buddyError;
        
        id result = response;
        
        // Is it a JSON response (as opposed to raw bytes)?
        if(result && [result isKindOfClass:[NSDictionary class]]) {
            
            // Grab the result
            result = response[@"result"] ?: result;
            
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                // Grab the access token
                if (result[@"serviceRoot"]) {
                    self.appSettings.serviceUrl = result[@"serviceRoot"];
                }
            }
        }
        
        result = result ?: [NSDictionary new];
        id responseObject = nil;
        
        switch (responseCode) {
            case 200:
            case 201:
                responseObject = result;
                break;
            case 400:
            case 401:
            case 402:
            case 403:
            case 404:
            case 405:
            case 500:
                buddyError = [NSError buildBuddyError:result];
                break;
            default:
                buddyError = [NSError bp_noInternetError:error.code message:result];
                break;
        }
        if([buddyError needsLogin]) {
            [self.appSettings clearUser];
            [self raiseNeedsLoginError];
        }
        if([buddyError credentialsInvalid]) {
            [self.appSettings clear];
        }
        if (buddyError) {
            [self raiseAPIError:buddyError];
        }
        
        if(clazz == [BuddyFile class])
        {
            // NOTE: Should we check if responseObject is not a dict here ?
            BuddyFile *file = [BuddyFile new];
            file.fileData =response;
            file.contentType = [responseHeaders objectForKey:@"Content-Type"];
            if(file.contentType==nil)
            {
                file.contentType = @"application/octet-stream";
            }
            callback(file,clazz,buddyError);
            return;
        }
        
        if(![result isKindOfClass:[NSDictionary class]])
        {
            // If result is not a dictionary then we just pass it back to the caller as we cannot convert that.
            callback(responseObject, clazz, buddyError);
            return;
        }
        else if(clazz == [NSDictionary class] && ([result isKindOfClass:[NSDictionary class]]) )
        {
            // If caller wants a dictionary, we can shortcut and just give it to them
            callback(responseObject, clazz, buddyError);
            return;
        }
        else
        {
            // Try to convert to what the caller wants.
            id returnObj = [[clazz alloc] init];
            [[JAGPropertyConverter bp_converter] setPropertiesOf:returnObj fromDictionary:result];
            callback(returnObj, clazz, buddyError);
            return;
        }
    };
}

- (void)raiseUserChangedTo:(BPUser *)user from:(BPUser *)from
{
    [self tryRaiseDelegate:@selector(userChangedTo:from:) withArguments:BOXNIL(user), BOXNIL(from), nil];
}

- (void)raiseReachabilityChanged:(BPReachabilityLevel)level
{
    [self tryRaiseDelegate:@selector(connectivityChanged:) withArguments:@(level), nil];
}

- (void)raiseNeedsLoginError
{
    [self tryRaiseDelegate:@selector(authorizationNeedsUserLogin) withArguments:nil];
}

- (void)raiseAPIError:(NSError *)error
{
    [self tryRaiseDelegate:@selector(apiErrorOccurred:) withArguments:error, nil];
}

- (void)tryRaiseDelegate:(SEL)selector withArguments:(id)firstArgument, ...
{
    va_list args;
    va_start(args, firstArgument);
    NSMutableArray *argList = [NSMutableArray array];
    for (id arg = firstArgument; arg != nil; arg = va_arg(args, id))
    {
        [argList addObject:arg];
    }
    
    va_end(args);
    
    id<UIApplicationDelegate> app = [[UIApplication sharedApplication] delegate];
    id target = nil;
    SuppressPerformSelectorLeakWarning(
       if (!self.delegate) {// If no delegate, see if we've implemented delegate methods on the AppDelegate.
           target = app;
       } else { // Try the delegate
           target = self.delegate;
       }
       if ([target respondsToSelector:selector]) {
           
           if ([argList count] >= 2) {
               [target performSelector:selector withObject:UNBOXNIL(argList[0]) withObject:UNBOXNIL(argList[1])];
           } else if ([argList count] == 1) {
               [target performSelector:selector withObject:UNBOXNIL(argList[0])];
           } else {
               [target performSelector:selector];
           }
       }
   );
}



#pragma mark - Location

- (void)setLocationEnabled:(BOOL)locationEnabled
{
    _locationEnabled = locationEnabled;
    [self.location beginTrackingLocation:^(NSError *error) {
        if (error) {
            // TODO - Not really an API error. What should we do?
            [self raiseAPIError:error];
        }
    }];
}

- (void)didUpdateBuddyLocation:(BPCoordinate *)newLocation
{
    _lastLocation = newLocation;
}

// Provide self as a simple passthrough of BPLocationProvider for convenience.
- (BPCoordinate *)currentLocation
{
    return self.location.currentLocation;
}

- (NSDictionary*) convertDictionaryForUpload:(NSDictionary*)dictionary
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // Convert any params that dont serialize cleanly
    for (NSString *name in [dictionary allKeys])
    {
        id val = [dictionary objectForKey:name];
        
        if([[val class] isSubclassOfClass:[NSDate class]])
        {
            val = [val bp_serializeDateToJson];
        }
        else if([[val class] isSubclassOfClass:[BPCoordinate class]])
        {
            val = [val stringValue];
        }
        
        if (val) {
            parameters[name] = val;
        }
    }

    // Inject location if needed
    if (!parameters[@"location"] && self.locationEnabled)
    {
        [parameters setObject:BOXNIL([self.location.currentLocation stringValue]) forKey:@"location"];
    }
    
    return parameters;
}

- (NSDictionary *)injectLocation:(NSDictionary *)parameters
{
    // Inject location only if it wasn't manually provided (and it's enabled, of course)
    if (!parameters[@"location"] && self.locationEnabled) {
        return [parameters dictionaryByMergingWith:@{@"location": BOXNIL([self.location.currentLocation stringValue])}];
    } else {
        return parameters;
    }
}

#pragma mark - Notifications

- (void)sendPushNotification:(BPNotification *)notification callback:(BuddyCompletionCallback)callback
{
    [self.notifications sendPushNotification:notification callback:callback];
}

#pragma mark - Metrics

- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value callback:(BuddyCompletionCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"metrics/events/%@", key];
    NSDictionary *parameters = @{@"value": BOXNIL(value)};
    
    [self POST:resource parameters:parameters class:[NSDictionary class] callback:^(id json, Class clazz, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds callback:(BuddyMetricCallback)callback
{
    
    NSDictionary *parameters = @{@"value": BOXNIL(value),
                                 @"timeoutInSeconds": @(seconds)};
    [self recordMetricCore:key parameters:parameters callback:callback];
}

- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds timestamp:(NSDate*)timestamp callback:(BuddyMetricCallback)callback
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:BOXNIL(value) forKey:@"value"];
    if(seconds>0)
    {
        [parameters setObject:@(seconds) forKey:@"timeoutInSeconds"];
    }
    if(timestamp)
    {
        [parameters setObject:[timestamp bp_serializeDateToJson ] forKey:@"timestamp"];
    }
  
    [self recordMetricCore:key parameters:parameters callback:callback];
}

- (void)recordMetricCore:(NSString*)key parameters:(NSDictionary*)parameters callback:(BuddyMetricCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"metrics/events/%@", key];
    [self POST:resource parameters:parameters class:[NSDictionary class] callback:^(id json, Class clazz, NSError *error) {
        BPMetricCompletionHandler *completionHandler;
        if (!error) {
            completionHandler = [[BPMetricCompletionHandler alloc] initWithMetricId:json[@"id"] andClient:self];
        }
        callback ? callback(completionHandler, error) : nil;
    }];
}

#pragma mark - REST workaround

- (id<BPRestProvider,BPRestProviderOld>)restService
{
    return self;
}

#pragma mark - Metadata

- (id<BPRestProvider,BPRestProviderOld>)client
{
    return self;
}


static NSString *metadataRoute = @"metadata/app";
- (NSString *) metadataPath:(NSString *)key
{
    if (!key) {
        return metadataRoute;
    } else {
        return [NSString stringWithFormat:@"%@/%@", metadataRoute, key];
    }
}

#pragma mark - Push Notification


-(void)sendApplicationMessage:(SEL)selector withArguments:(NSArray*)args
{
    UIApplication* app = [UIApplication sharedApplication];
    if([app respondsToSelector:selector]){
        NSMethodSignature* messageSig = [UIApplication methodSignatureForSelector:selector];
        NSInvocation* invoke = [NSInvocation invocationWithMethodSignature: messageSig];
        [invoke setSelector:selector];
        [invoke setTarget:app];
        if([args count] != ([messageSig numberOfArguments] - HiddenArgumentCount)){
            return;
        }
       
        for ( int currentArgIndex = 0;currentArgIndex < [args count]; currentArgIndex++){
            [invoke setArgument:(void*)[args objectAtIndex:currentArgIndex] atIndex:currentArgIndex];
        }
        [invoke invoke];
        
    }
    
}

@end

