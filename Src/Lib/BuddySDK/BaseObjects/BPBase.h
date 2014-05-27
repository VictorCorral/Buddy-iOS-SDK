//
//  BPMetadataBase.h
//  BuddySDK
//
//  Created by Erik Kerber on 2/11/14.
//
//

#import "BPMetadataItem.h"
#import "BPPermissions.h"
#import "BPLocationProvider.h"
#import "BPPagingTokens.h"

@protocol BuddyObjectProperties <NSObject>

@property (nonatomic, strong) BPCoordinate *location;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *lastModified;
@property (nonatomic, assign) BPPermissions readPermissions;
@property (nonatomic, assign) BPPermissions writePermissions;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *id;

@end

// Temp
@protocol BPSearchProperties <NSObject>

@property (nonatomic, strong) BPCoordinateRange *range;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, copy) BPPagingTokens *tokens;
@property (nonatomic, copy) NSString *userID;

@end

typedef void (^BuddyCompletionCallback)(NSError *error);
typedef void (^BuddyObjectCallback)(id newBuddyObject, NSError *error);
typedef void (^BuddyIdCallback)(NSString *buddyId, NSError *error);
typedef void (^BuddyResultCallback)(BOOL result, NSError *error);

@interface BPBase : NSObject

- (NSString *) metadataPath:(NSString *)key;

- (void)setMetadata:(BPMetadataItem *)metadata callback:(BuddyCompletionCallback)callback;
- (void)setMetadataValues:(BPMetadataCollection *)metadata callback:(BuddyCompletionCallback)callback;
- (void)searchMetadata:(BPSearchMetadata *)search callback:(void (^) (NSArray *buddyObjects, BPPagingTokens *tokens, NSError *error))callback;
- (void)incrementMetadata:(NSString *)key delta:(NSInteger)delta callback:(BuddyCompletionCallback)callback;
- (void)getMetadataWithKey:(NSString *)key permissions:(BPPermissions) permissions callback:(BPMetadataCallback) callback;
- (void)deleteMetadataWithKey:(NSString *)key permissions:(BPPermissions) permissions callback:(BuddyCompletionCallback)callback;

@property (nonatomic, readonly, weak) id<BPRestProvider> client;

@property (nonatomic, readonly, weak) id<BPLocationProvider> locationProvider;


@end
