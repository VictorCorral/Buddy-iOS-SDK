#import "BPModelBase.h"

@interface BPBinaryModelBase : BPModelBase

@property (nonatomic,strong) NSString *contentType;
@property (nonatomic,assign) int contentLength;
@property (nonatomic,strong) NSString *signedUrl;

@end
