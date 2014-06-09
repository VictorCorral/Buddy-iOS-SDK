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
    it(@"Should allow saving of app settings", ^{
        BPAppSettings *appSettings = [[BPAppSettings alloc] initWithBaseUrl:@"test.com"];
        appSettings.userToken = User_TOKEN_STRING;
        appSettings.deviceToken = DEVICE_TOKEN_STRING;
    });
    
    it(@"Should allow restoring of app settings", ^{
        BPAppSettings *appSettings = [BPAppSettings restoreSettings];
                                      
        [[appSettings.userToken should] equal:User_TOKEN_STRING];
        [[appSettings.deviceToken should] equal:DEVICE_TOKEN_STRING];
    });
});

SPEC_END

