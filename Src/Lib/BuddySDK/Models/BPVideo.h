#import "BPBinaryModelBase.h"

@interface BPVideo : BPBinaryModelBase

@property (nonatomic,strong) NSString *encoding;
@property (nonatomic,assign) int bitRate;
@property (nonatomic,assign) double lengthInSeconds;
@property (nonatomic,strong) NSString *thumbnailID;

@end
