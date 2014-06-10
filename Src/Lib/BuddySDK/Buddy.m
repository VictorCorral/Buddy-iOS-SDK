/*
 * Copyright (C) 2013 Buddy Platform, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

#import "Buddy.h"
#import "BuddyObject+Private.h"

/// <summary>
/// TODO
/// </summary>

@implementation Buddy

+ (id<BPRestProvider>)buddyRestProvider {
    return [BPClient defaultClient].restService;
}

+ (BPUser *)user
{
    return [[BPClient defaultClient] user];
}

+ (BPUserCollection *)users
{
    return [[BPClient defaultClient] users];
}

+ (BuddyDevice *)device
{
    return [[BPClient defaultClient] device];
}

+ (BPCheckinCollection *) checkins
{
    return [[BPClient defaultClient] checkins];
}

+ (BPPictureCollection *) pictures
{
    return [[BPClient defaultClient] pictures];
}

+ (BPVideoCollection *) videos
{
    return [[BPClient defaultClient] videos];
}

+ (BPBlobCollection *) blobs
{
    return [[BPClient defaultClient] blobs];
}

+ (BPAlbumCollection *) albums
{
    return [[BPClient defaultClient] albums];
}

+ (BPLocationCollection *) locations
{
    return [[BPClient defaultClient] locations];
}

+ (BPUserListCollection *) userLists
{
    return [[BPClient defaultClient] userLists];
}

+ (BOOL) locationEnabled
{
    return [[BPClient defaultClient] locationEnabled];
}

+ (void) setLocationEnabled:(BOOL)val
{
    [[BPClient defaultClient] setLocationEnabled:val];
}

+ (void)setClientDelegate:(id<BPClientDelegate>)delegate
{
    [BPClient defaultClient].delegate = delegate;
}

+ (void)initClient:(NSString *)appID
            appKey:(NSString *)appKey
{
    
	[Buddy initClient:appID
            appKey:appKey
            autoRecordDeviceInfo:NO
            autoRecordLocation:NO
            withOptions:nil];
}


+ (void) initClient:(NSString *)appID
            appKey:(NSString *)appKey
            withOptions:(NSDictionary *)options

{
    [[BPClient defaultClient] setupWithApp:appID
            appKey:appKey
            options:options
            delegate:nil];
}

+ (void) initClient:(NSString *)appID
            appKey:(NSString *)appKey
            autoRecordDeviceInfo:(BOOL)autoRecordDeviceInfo
            autoRecordLocation:(BOOL)autoRecordLocation
            withOptions:(NSDictionary *)options
{
    
    NSDictionary *defaultOptions = @{@"autoRecordLocation": @(autoRecordLocation),
                                     @"autoRecordDeviceInfo": @(autoRecordDeviceInfo)};
    
    NSMutableDictionary *combined = [NSMutableDictionary dictionaryWithDictionary:defaultOptions];
    
    [[BPClient defaultClient] setupWithApp:appID
            appKey:appKey
            options:combined
            delegate:nil];
    
}

#pragma mark User


+ (void)createUser:(BPUser *)user
          password:(NSString *)password
          callback:(BuddyCompletionCallback)callback
{
    [[BPClient defaultClient] createUser:user password:password callback:callback];
}

+ (void)login:(NSString *)username password:(NSString *)password callback:(BuddyObjectCallback)callback
{
    [[BPClient defaultClient] login:username password:password callback:callback  ];
     
}

+ (void)socialLogin:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback;
{
    [[BPClient defaultClient] socialLogin:provider providerId:providerId token:token success:callback];
}

+ (void)logout:(BuddyCompletionCallback)callback
{
    [[BPClient defaultClient] logout:callback];
}

+ (void)sendPushNotification:(BPNotification *)notification callback:(BuddyCompletionCallback)callback;
{
    [[BPClient defaultClient] sendPushNotification:notification callback:callback];
}

+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value callback:(BuddyCompletionCallback)callback
{
    [[BPClient defaultClient] recordMetric:key andValue:value callback:callback];
}

+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds callback:(BuddyMetricCallback)callback
{
    [[BPClient defaultClient] recordMetric:key andValue:value timeout:seconds callback:callback];
}

+ (void)setMetadata:(BPMetadataItem *)metadata callback:(BuddyCompletionCallback)callback
{
    [[BPClient defaultClient] setMetadata:metadata callback:callback];
}

+ (void)setMetadataValues:(BPMetadataKeyValues *)metadata callback:(BuddyCompletionCallback)callback
{
    [[BPClient defaultClient] setMetadataValues:metadata callback:callback];
}

+ (void)searchMetadata:(BPSearchMetadata *)search callback:(BPSearchCallback)callback
{
    [[BPClient defaultClient] searchMetadata:search callback:callback];
}


+ (void)incrementMetadata:(NSString *)key delta:(NSInteger)delta callback:(BuddyCompletionCallback)callback
{
    [[BPClient defaultClient] incrementMetadata:key delta:delta callback:callback];
}

+ (void)getMetadataWithKey:(NSString *)key visibility:(BPPermissions) visibility callback:(BPMetadataCallback)callback
{
    [[BPClient defaultClient] getMetadataWithKey:key visibility:(BPPermissions)visibility callback:callback];
}

+ (void)deleteMetadataWithKey:(NSString *)key visibility:(BPPermissions) visibility callback:(BuddyCompletionCallback)callback
{
    [[BPClient defaultClient] deleteMetadataWithKey:key visibility:(BPPermissions)visibility callback:callback];
}

@end
