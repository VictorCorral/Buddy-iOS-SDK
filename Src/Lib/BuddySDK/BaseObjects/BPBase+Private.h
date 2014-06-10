//
//  BuddyObject+Private.h
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "BPBase.h"

@interface BPBase(Private)

- (instancetype)initWithClient:(id<BPRestProvider>)client;

@property (nonatomic, weak) id<BPRestProvider> client;
@property (nonatomic, weak) id<BPLocationProvider> locationProvider;

@end