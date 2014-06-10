//
//  BPMetadataItem.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/4/14.
//
//

#import "BPCoordinate.h"
#import "BPDateRange.h"
#import "BuddyObject.h"
#import "BPPermissions.h"
#import "BPEnumMapping.h"

@interface BPMetadataBase : NSObject<BPEnumMapping>

@end

@protocol BPMetadataProperties <NSObject>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic, copy) NSString *keyPrefix;
@property (nonatomic, readonly, strong) BPCoordinateRange *locationRange;
@property (nonatomic, readonly, strong) BPDateRange *created;
@property (nonatomic, readonly, strong) BPDateRange *modified;
@property (nonatomic, assign) BPPermissions visibility;

@end

@protocol BPMetadataCollectionProperties <NSObject>

@property (nonatomic, strong) NSDictionary *values;
@property (nonatomic, assign) BPPermissions visibility;

@end

@class BPMetadataItem;

@interface BPSearchMetadata : BPMetadataBase<BPMetadataProperties>

@end

typedef void(^BPMetadataCallback)(BPMetadataItem *metadata, NSError *error);

@interface BPMetadataItem : BPMetadataBase<BPMetadataProperties>
- (instancetype)initBuddyWithResponse:(id)response;
@end

@interface BPMetadataKeyValues : BPMetadataBase<BPMetadataCollectionProperties>

@end
