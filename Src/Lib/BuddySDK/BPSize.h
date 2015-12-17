#import <Foundation/Foundation.h>

@interface BPSize : NSObject
@property (nonatomic, assign) NSUInteger w;
@property (nonatomic, assign) NSUInteger h;

- (NSString *)stringValue;
@end

static inline BPSize *BPSizeMake(NSUInteger height, NSUInteger width)
{
    BPSize *size = [[BPSize alloc] init];
    size.h = height;
    size.w = width;
    return size;
};
