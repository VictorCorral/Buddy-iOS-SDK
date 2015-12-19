#import "BPBinaryModelBase.h"

@class BPSize;

@interface BPPicture : BPBinaryModelBase

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *caption;
@property (nonatomic, copy) NSString *watermark;
@property (nonatomic, strong) BPSize *size;

@end
