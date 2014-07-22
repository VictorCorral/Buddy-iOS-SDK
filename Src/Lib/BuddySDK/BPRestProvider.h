//
//  BPRestProvider.h
//  BuddySDK
//
//  Created by Erik Kerber on 12/29/13.
//
//

#import <Foundation/Foundation.h>

typedef void (^RESTCallback)(id obj, NSError *error);

typedef void (^RESTCallbackOld)(id json, NSError *error);

@protocol BPRestProvider <NSObject>

@required

- (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class) clazz callback:(RESTCallback)callback;
- (void)GET_FILE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallback)callback;
- (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class) clazz callback:(RESTCallback)callback;
- (void)MULTIPART_POST:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class) clazz
                  data:(NSDictionary *)data mimeType:(NSString *)mimeType callback:(RESTCallback)callback;
- (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class) clazz callback:(RESTCallback)callback;
- (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class) clazz callback:(RESTCallback)callback;
- (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class) clazz callback:(RESTCallback)callback;

@end

@protocol BPRestProviderOld <NSObject>

@required

- (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback;
- (void)GET_FILE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback;
- (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback;
- (void)MULTIPART_POST:(NSString *)servicePath parameters:(NSDictionary *)parameters
                  data:(NSDictionary *)data mimeType:(NSString *)mimeType callback:(RESTCallbackOld)callback;
- (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback;
- (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback;
- (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters callback:(RESTCallbackOld)callback;

@end

