#ifndef BuddySDK_Buddy_Private_h
#define BuddySDK_Buddy_Private_h

#import "Buddy.h"

@class BPClient;

@interface Buddy(Private)

+(BPClient*) currentClientObject;

@end

#endif
