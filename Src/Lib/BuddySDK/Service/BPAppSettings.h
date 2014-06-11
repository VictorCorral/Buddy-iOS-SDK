//
//  BPAppSettings.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/30/14.
//
//

#import <Foundation/Foundation.h>

@interface BPAppSettings : NSObject

- (instancetype) init __attribute__((unavailable("Use initWithAppId::")));
+ (instancetype) new __attribute__((unavailable("Use initWithAppId::")));

- (instancetype)initWithAppId:(NSString *)appID andKey:(NSString *)appKey;

@property (nonatomic, strong) NSString *appVersion;

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *serviceUrl;

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSDate *deviceTokenExpires;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSDate *userTokenExpires;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *lastUserID;

@property (nonatomic, strong) NSString *devicePushToken;

@property (nonatomic, readonly, strong) NSString *token;


- (void)clear;
- (void)clearUser;

@end
