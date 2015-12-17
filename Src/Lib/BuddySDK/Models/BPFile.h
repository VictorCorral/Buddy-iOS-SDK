#import <Foundation/Foundation.h>

@interface BPFile : NSObject

@property (nonatomic,strong) NSString *contentType;
@property (nonatomic,strong) NSData *fileData;

@end
