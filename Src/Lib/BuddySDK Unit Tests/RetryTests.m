#import <CoreLocation/CoreLocation.h>

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"

#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 100.0

SPEC_BEGIN(RetrySpec)

describe(@"Retry", ^{
    context(@"When a call is made", ^{
        
        beforeAll(^{
            [BuddyIntegrationHelper bootstrapInit];

        });
        
        it(@"Should allow for retry", ^{
            
            __block BOOL fin = NO;
            
            [Buddy logoutUser:^(NSError *error) {
                //[[error should] beNil];
                
                fin = YES;
            }];

            [[expectFutureValue(theValue(fin)) shouldEventuallyBeforeTimingOutAfter(200.0)] beYes];
        });
    });
});
SPEC_END
