#import <UIKit/UIKit.h>

@interface BPDateRange : NSObject

@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;

@end

static inline BPDateRange *BPDateRangeMake(NSDate *start, NSDate *end)
{
    BPDateRange *range = [[BPDateRange alloc] init];
    range.start = start;
    range.end = end;
    return range;
};