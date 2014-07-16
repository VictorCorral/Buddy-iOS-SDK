//
//  BPServiceController.h
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import <Foundation/Foundation.h>
#import "BPAppSettings.h"
#import "BPRestProvider.h"


typedef void (^ServiceResponse)(NSInteger responseCode,id response, NSError *error);
typedef void (^REST_ServiceResponse)(NSInteger responseCode, NSDictionary* responseHeaders,id response, NSError *error);

@interface BPServiceController : NSObject

-(instancetype) init __attribute__((unavailable("Use initWithUrl:")));
+(instancetype) new __attribute__((unavailable("Use with initWithUrl:")));

- (instancetype)initWithAppSettings:(BPAppSettings *)appSettings;

@property (nonatomic, readonly, retain) NSString *appID;
@property (nonatomic, readonly, retain) NSString *appKey;

- (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(ServiceResponse)callback;
- (void)GET_FILE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(ServiceResponse)callback;
- (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(ServiceResponse)callback;

// data is required to be BuddyFiles
- (void)MULTIPART_POST:(NSString *)servicePath parameters:(NSDictionary *)parameters data:(NSDictionary *)data mimeType:(NSString *)mimeType callback:(ServiceResponse)callback;
- (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(ServiceResponse)callback;
- (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(ServiceResponse)callback;
- (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(ServiceResponse)callback;




- (void)REST_GET:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(REST_ServiceResponse)callback;
- (void)REST_POST:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(REST_ServiceResponse)callback;

// data is required to be BuddyFiles
- (void)REST_MULTIPART_POST:(NSString *)servicePath parameters:(NSDictionary *)parameters data:(NSDictionary *)data
                   mimeType:(NSString *)mimeType callback:(REST_ServiceResponse)callback;
- (void)REST_GET_FILE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(REST_ServiceResponse)callback;

- (void)REST_MULTIPART_POST:(NSString *)servicePath parameters:(NSDictionary *)parameters data:(NSDictionary *)data callback:(REST_ServiceResponse)callback;
- (void)REST_PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(REST_ServiceResponse)callback;
- (void)REST_PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(REST_ServiceResponse)callback;
- (void)REST_DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(REST_ServiceResponse)callback;


@end
