//
//  BPAppSettings.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/30/14.
//
//

#import "BPAppSettings.h"

@implementation BPAppSettings

@synthesize serviceUrl = _serviceUrl;

- (instancetype)initWithAppId:(NSString *)appID andKey:(NSString *)appKey
{
    self = [super init];
    if (self) {

        _appID = appID;
        _appKey = appKey;
        
        if (_appID) {
            [self restoreSettings];
        }
        
        [self addObserver:self forKeyPath:@"appID" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"appKey" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"serviceUrl" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"deviceToken" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"deviceTokenExpires" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"userToken" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"userTokenExpires" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self saveSettings];
}

#pragma mark - Custom accessors

- (NSString *)token
{
    return self.userToken ?: self.deviceToken ?: nil;
}

#pragma mark - BPAppSettings

- (void)clear
{
    self.serviceUrl = nil;
    self.deviceToken = nil;
    self.deviceTokenExpires = nil;
    self.lastUserID = nil;
    [self clearUser];
}

- (void)clearUser
{
    self.userToken = nil;
    self.userTokenExpires = nil;
    self.userID = nil;
}

- (void)saveSettings
{
    NSDictionary *settings = [[JAGPropertyConverter converter] convertToDictionary:self];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"BPUserSettings"];
}

- (void)restoreSettings
{
    NSDictionary *restoredSettings = [[NSUserDefaults standardUserDefaults] objectForKey:@"BPUserSettings"];
    
    if (!restoredSettings) {
        return;
    }
    
    [[JAGPropertyConverter converter] setPropertiesOf:self fromDictionary:restoredSettings];
}

@end
