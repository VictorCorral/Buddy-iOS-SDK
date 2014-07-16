//
//  BPNotificationManager.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/26/14.
//
//

#import "BPRestProvider.h"
#import "BPBase.h"

@class BPNotification;

@interface BPNotificationManager : NSObject

- (instancetype)initWithClient:(id<BPRestProviderOld>)client;

- (void)sendPushNotification:(BPNotification *)notification callback:(BuddyCompletionCallback)callback;

@end
