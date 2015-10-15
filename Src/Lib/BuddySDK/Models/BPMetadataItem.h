//
//  BPMetadataItem.h
//  BuddySDK
//
//  Created by Nick Ambrose on 8/26/14.
//
//

#import "BPModelBase.h"

@class BPCoordinate;

@interface BPMetadataItem : BPModelBase

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;

@end
