//
//  BuddyCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 10/7/13.
//
//

#import <Foundation/Foundation.h>

#import "BuddyObject.h"
#import "BPPagingTokens.h"

typedef void (^BuddyCollectionCallback)(NSArray *buddyObjects, NSError *error);
typedef void (^BPSearchCallback)(NSArray *buddyObjects, BPPagingTokens *pagingToken, NSError *error);

@interface BuddyCollection : NSObject

@property (nonatomic) Class type;
@property (nonatomic, readonly, strong) id<BPRestProvider> client;

- (instancetype) init __attribute__((unavailable("init not available")));
+ (instancetype) new __attribute__((unavailable("new not available")));

- (instancetype)initWithClient:(id<BPRestProvider>)client;

- (void)getAll:(BPSearchCallback)callback;

- (void)getItem:(NSString *)identifier callback:(BuddyObjectCallback)callback;

@end
