//
//  CheckinIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "BPAppSettings.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

#define DEVICE_TOKEN_STRING @"myDeviceToken"
#define User_TOKEN_STRING @"myUserToken"

SPEC_BEGIN(AppSettings)

describe(@"App Settings Tests", ^{
    
    beforeAll(^{
        [BPAppSettings resetSettings];
    });
    
    xit(@"Should allow saving of app settings", ^{
        BPAppSettings *appSettings = [[BPAppSettings alloc] initWithAppId:@"appID" andKey:@"appKey" initialURL:nil];
        appSettings.userToken = User_TOKEN_STRING;
        appSettings.deviceToken = DEVICE_TOKEN_STRING;
    });
    
    xit(@"Should allow restoring of app settings", ^{
        BPAppSettings *appSettings = [[BPAppSettings alloc] initWithAppId:@"appID" andKey:@"appKey" initialURL:nil];
                                      
        [[appSettings.userToken should] equal:User_TOKEN_STRING];
        [[appSettings.deviceToken should] equal:DEVICE_TOKEN_STRING];
    });
});

SPEC_END

