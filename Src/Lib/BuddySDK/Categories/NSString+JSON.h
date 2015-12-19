#import <Foundation/Foundation.h>

@interface NSString (JSON)
- (NSDate *)bp_deserializeJsonDateString;
- (BOOL) bp_isDate;
@end
