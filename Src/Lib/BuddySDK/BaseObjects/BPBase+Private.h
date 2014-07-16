//
//  BuddyObject+Private.h
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "BPBase.h"

@interface BPBase(Private)

- (instancetype)initWithClient:(id<BPRestProviderOld>)client;

@property (nonatomic, weak) id<BPRestProviderOld> client;
@property (nonatomic, weak) id<BPLocationProvider> locationProvider;

@end