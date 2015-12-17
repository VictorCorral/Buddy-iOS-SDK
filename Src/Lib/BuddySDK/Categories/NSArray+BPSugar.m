#import "NSArray+BPSugar.h"

@implementation NSArray (BPSugar)

- (NSArray *)bp_map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        id newObject = block(object);
        if (newObject) {
            [array addObject:newObject];
        }
    }
    
    return array;
}

@end
