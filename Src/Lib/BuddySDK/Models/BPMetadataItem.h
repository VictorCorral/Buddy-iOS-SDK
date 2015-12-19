#import "BPModelBase.h"

@class BPCoordinate;

@interface BPMetadataItem : BPModelBase

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;

@end
