#import <CoreLocation/CoreLocation.h>

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"

#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 100.0

SPEC_BEGIN(LocationSpec)

describe(@"Locations", ^{
    context(@"When a call is made", ^{
        
        __block BOOL fin = NO;

        beforeAll(^{
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });

 
        it(@"Should use last location", ^{
            
            __block BOOL fin = NO;
            
            [Buddy setLastLocation:BPCoordinateMake(1.2, 3.4)];
            
            NSDictionary *parameters = @{@"value": @"value1"};
         
            NSString *path = [NSString stringWithFormat:@"/metadata/%@/key1", [Buddy user].id];
            [Buddy PUT:path parameters:parameters class:[NSDictionary class] callback:^(id obj, NSError *error) {
                
                [obj shouldNotBeNil];
                [error shouldBeNil];
                
                [Buddy GET:path parameters:@{} class:[BPMetadataItem class] callback:^(id obj, NSError *error) {
    
                    [obj shouldNotBeNil];
                    [error shouldBeNil];
                    
                    BPMetadataItem *result = (BPMetadataItem *)obj;
                    
                    [[theValue(result.location.lat) should] equal: 1.2 withDelta:FLT_EPSILON];
                    [[theValue(result.location.lng) should] equal: 3.4 withDelta:FLT_EPSILON];
                    
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        
        it(@"Should allow for override of last location", ^{
            
            __block BOOL fin = NO;
            
            [Buddy setLastLocation:BPCoordinateMake(1.2, 3.4)];
            
            NSDictionary *parameters = @{@"value": @"value1", @"location" : BPCoordinateMake(5.6, 7.8)};
            
            NSString *path = [NSString stringWithFormat:@"/metadata/%@/key2", [Buddy user].id];
            [Buddy PUT:path parameters:parameters class:[BPMetadataItem class] callback:^(id obj, NSError *error) {
                
                [Buddy GET:path parameters:@{} class:[BPMetadataItem class] callback:^(id obj, NSError *error) {
                    
                    [obj shouldNotBeNil];
                    [error shouldBeNil];
                    
                    BPMetadataItem *result = (BPMetadataItem *)obj;
                
                    [[theValue(result.location.lat) should] equal: 5.6 withDelta:FLT_EPSILON];
                    [[theValue(result.location.lng) should] equal: 7.8 withDelta:FLT_EPSILON];
                
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
    });
});
SPEC_END
