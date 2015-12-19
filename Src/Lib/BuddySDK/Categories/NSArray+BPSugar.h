#import <Foundation/Foundation.h>

@interface NSArray (BPSugar)

- (NSArray *)bp_map:(id (^)(id object))block;

@end
