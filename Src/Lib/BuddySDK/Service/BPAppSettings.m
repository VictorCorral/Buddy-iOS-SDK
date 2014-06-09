//
//  BPAppSettings.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/30/14.
//
//

#import "BPAppSettings.h"

@interface BPAppSettings()

@property (nonatomic, strong) NSString *defaultUrl;

@end

@implementation BPAppSettings

@synthesize serviceUrl = _serviceUrl;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
        _defaultUrl = baseUrl;
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

- (NSString *)serviceUrl
{
    return _serviceUrl ?: self.defaultUrl;
}

- (void)setServiceUrl:(NSString *)serviceUrl
{
    _serviceUrl = serviceUrl;
}

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
    [self clearUser];
}

- (void)clearUser
{
    self.userToken = nil;
    self.userTokenExpires = nil;
}

- (void)saveSettings
{
    NSDictionary *settings = [[JAGPropertyConverter converter] convertToDictionary:self];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"BPUserSettings"];
}

+ (BPAppSettings *)restoreSettings
{
    NSDictionary *restoredSettings = [[NSUserDefaults standardUserDefaults] objectForKey:@"BPUserSettings"];
    
    if (!restoredSettings) {
        return nil;
    }
    
    BPAppSettings *settings = [[BPAppSettings alloc] initWithBaseUrl:nil];
    
    [[JAGPropertyConverter converter] setPropertiesOf:settings fromDictionary:restoredSettings];
    
    return settings;
}

@end
