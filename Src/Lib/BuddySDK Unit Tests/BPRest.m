//
//  BPRest.m
//  BuddySDK
//
//  Created by Nick Ambrose on 7/16/14.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"

#import "BPModelCheckin.h"
#import "BuddyFile.h"

#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BPRESTIntegrationSpec)

describe(@"BPUser", ^{
    context(@"When a user is logged in", ^{
        
        __block BOOL fin = NO;
        beforeAll(^{
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        beforeEach(^{
            fin = NO;
        });

        it(@"Should allow creating a checkin with a dictionary", ^{
            
            NSDictionary *checkin = @{@"comment":@"my checkin with dict", @"description":@"it was a nice place",@"location":BPCoordinateMake(1.2, 3.4)};
            
            [Buddy POST:@"/checkins" parameters:checkin class:[NSDictionary class] callback:^(id obj, __unsafe_unretained Class clazz, NSError *error) {
                
                [[error should] beNil];
                if(error!=nil)
                {
                    return;
                }
                
                NSDictionary *checkinResult = (NSDictionary*)obj;
                if(checkinResult==nil)
                {
                    [[checkinResult should] beNonNil];
                    return;
                }
                
                NSString *returnedComment = [checkinResult objectForKey:@"comment"];
                [[returnedComment should] equal:@"my checkin with dict"];
                
                NSString *returnedDesc =[checkinResult objectForKey:@"description"];
                [[returnedDesc should] equal: @"it was a nice place"];
                
            }];
        });
        it(@"Should allow creating a checkin with a model", ^{
            
            NSDictionary *checkin = @{@"comment":@"my checkin with model", @"description":@"it was an even better place",@"location":BPCoordinateMake(11.2, 33.4)};
            
            [Buddy POST:@"/checkins" parameters:checkin class:[BPModelCheckin class] callback:^(id obj, __unsafe_unretained Class clazz, NSError *error) {
                
                [[error should] beNil];
                if(error!=nil)
                {
                    return;
                }
                
                BPModelCheckin *checkinResult = (BPModelCheckin*)obj;
                if(checkinResult==nil)
                {
                    [[checkinResult should] beNonNil];
                    return;
                }
                
                [[checkinResult.id should] beNonNil];
                
                [[checkinResult.created should] beNonNil];
                
                [[checkinResult.comment should] equal:@"my checkin with model"];
                
                [[checkinResult.description should] equal: @"it was an even better place"];
                
            }];
        });
        
        it(@"Should allow updating a checkin with a model", ^{
            
            NSDictionary *checkin = @{@"comment":@"my checkin with model", @"description":@"it was an even better place",@"location":BPCoordinateMake(11.2, 33.4)};
            
            [Buddy POST:@"/checkins" parameters:checkin class:[BPModelCheckin class] callback:^(id obj, __unsafe_unretained Class clazz, NSError *error) {
                
                [[error should] beNil];
                if(error!=nil)
                {
                    return;
                }
                
                BPModelCheckin *checkinResult = (BPModelCheckin*)obj;
                [[checkinResult should] beNonNil];
                
                [[checkinResult.id should] beNonNil];
                
                [[checkinResult.created should] beNonNil];
                
                [[checkinResult.comment should] equal:@"my checkin with model"];
                
                [[checkinResult.description should] equal: @"it was an even better place"];
                
                NSDictionary *checkinPatch = @{@"comment":@"my checkin with model patched"};
                
                [Buddy PATCH:[NSString stringWithFormat:@"/checkins/%@",checkinResult.id] parameters:checkinPatch class:[BPModelCheckin class] callback:^(id obj, __unsafe_unretained Class clazz, NSError *error) {
                    
                    [[error should] beNonNil];
                    if(error!=nil)
                    {
                        return;
                    }
                    
                    BPModelCheckin *checkinResultPatched = (BPModelCheckin*)obj;
                    [[checkinResult should] beNonNil];
                    
                    
                    [[checkinResultPatched.id should] equal:checkinResult.id];
                    
                    [[checkinResultPatched.created should] beNonNil];
                    
                    [[checkinResultPatched.comment should] equal:@"my checkin with model patched"];
                    
                    [[checkinResultPatched.description should] equal: @"it was an even better place"];
                    
                    
                }];
                
            }];
        });
        
    });
    
    it(@"Should allow deleting a checkin", ^{
        
        NSDictionary *checkin = @{@"comment":@"my checkin with model", @"description":@"it was an even better place",@"location":BPCoordinateMake(11.2, 33.4)};
        
        [Buddy POST:@"/checkins" parameters:checkin class:[BPModelCheckin class] callback:^(id obj, __unsafe_unretained Class clazz, NSError *error) {
            
            [[error should] beNil];
            if(error!=nil)
            {
                return;
            }
            
            BPModelCheckin *checkinResult = (BPModelCheckin*)obj;
            [[checkinResult should] beNonNil];
            
            [[checkinResult.id should] beNonNil];
            
            [[checkinResult.created should] beNonNil];
            
            [[checkinResult.comment should] equal:@"my checkin with model"];
            
            [[checkinResult.description should] equal: @"it was an even better place"];
            
            [Buddy DELETE:[NSString stringWithFormat:@"/checkins/%@",checkinResult.id] parameters:nil class:[BPModelCheckin class] callback:^(id obj, __unsafe_unretained Class clazz, NSError *error) {
                
                [[error should] beNil];
                if(error!=nil)
                {
                    return;
                }
                
            }];
            
        }];
    });
    
    it(@"Should allow uuploading a picture", ^{
        
        NSMutableDictionary *pic = [NSMutableDictionary new];
        
        [pic setObject:@"Pic from iOS" forKey:@"caption"];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
        
        
        BuddyFile *file = [BuddyFile new];
        file.fileData = [[NSFileManager defaultManager] contentsAtPath:imagePath];
        file.contentType = @"image/png";
        
        [pic setObject:file forKey:@"data"];
        
        [Buddy POST:@"/pictures" parameters:pic class:[NSDictionary class] callback:^(id json, __unsafe_unretained Class clazz, NSError *error) {
            [[error should] beNil];
            if(error!=nil)
            {
                return;
            }
            
        }];
    });
    
});
SPEC_END
