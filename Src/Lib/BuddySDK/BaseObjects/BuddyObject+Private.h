//
//  BuddyObject+Private.h
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "BuddyObject.h"
#import "BPBase+Private.h"
#import "BPRestProvider.h"

@interface BuddyObject (Private)

- (instancetype)initBuddyWithClient:(id<BPRestProviderOld>)client;
- (instancetype)initBuddyWithResponse:(id)response andClient:(id<BPRestProviderOld>)rest;
- (instancetype)initForCreation;

- (NSDictionary *)buildUpdateDictionary;
- (void)registerProperties;

+ (NSDictionary *)baseEnumMap;
+ (NSDictionary *)enumMap;

- (void)savetoServerWithClient:(id<BPRestProviderOld>)client callback:(BuddyCompletionCallback)callback;
- (void)savetoServerWithSupplementaryParameters:(NSDictionary *)extraParams client:(id<BPRestProviderOld>)client callback:(BuddyCompletionCallback)callback;

@end
