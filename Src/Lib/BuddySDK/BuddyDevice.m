#import "BuddyDevice.h"
#import "BPClient.h"

#import "Buddy.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>

/// <summary>
/// Represents an object that can be used to record device analytics, like device types and app crashes.
/// </summary>

@implementation BuddyDevice

BPClient* internalClient;

-(BPClient*)client
{
    return internalClient;
}

-(void)initialize:(BPClient*)client
{
    internalClient = client;
}

-(void)pushToken:(NSString*)pushToken
{
    [internalClient registerPushToken:pushToken callback:^(id device, NSError *error){
        if(error==nil)
        {
            NSLog(@"token registered");
        }
        else
        {
            NSLog(@"token registration failed: %@",[error localizedDescription]);
        }
    }];
}

+(NSString *)identifier {

    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[versionCompatibility objectAtIndex:0] intValue] >= 6)
    {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    else
    {
        // id for vendor is iOS 6+. Return @"" unless there is demand for pre-iOS 6 support.
        return @"";
    }
}

+ (NSString *)osVersion
{
	return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)appVersion
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)deviceModel
{
    static NSString *deviceModel;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        
        char *model = malloc(size);
        
        sysctlbyname("hw.machine", model, &size, NULL, 0);
        
        deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
        
        free(model);
    });
    
	return deviceModel;
}

@end