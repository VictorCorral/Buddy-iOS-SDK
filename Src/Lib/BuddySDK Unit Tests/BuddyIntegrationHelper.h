//
//  BuddyIntegrationHelper.h
//  BuddySDK
//
//  Created by Erik Kerber on 12/29/13.
//
//

#import <Foundation/Foundation.h>

@class BPUser;

@interface BuddyIntegrationHelper : NSObject

+ (void) bootstrapInit;

+ (void) bootstrapLogin:(void(^)())callback;

+ (NSDate *)randomDate;

+ (NSString *)randomString:(int)len;

+(void)createRandomUser:(BPUser *)user callback:(BuddyCompletionCallback)callback;

@end
