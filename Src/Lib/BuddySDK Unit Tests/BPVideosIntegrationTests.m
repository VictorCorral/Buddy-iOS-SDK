//
//  CheckinIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 60.0

SPEC_BEGIN(BuddyVideosSpec)

describe(@"BPVideosIntegrationSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPVideo *tempVideo;
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow you create a video.", ^{
            
            __block BOOL fin = NO;
            
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *videoPath = [bundle pathForResource:@"small" ofType:@"mp4"];
            NSData *video = [NSData dataWithContentsOfFile:videoPath];
            
            tempVideo = [BPVideo new];
            tempVideo.title = @"That cliche bunny video";
            
            [[Buddy videos] addVideo:tempVideo videoData:video callback:^(NSError *error) {
                [[theValue(tempVideo.contentLength) should] beGreaterThan:theValue(1)];
                [[tempVideo.contentType should] equal:@"video/mp4"];
                if (tempVideo) {
                    // Silly framework crashes, not fails the assert if there is no tempVideo.
                    [[tempVideo.signedUrl should] haveLengthOfAtLeast:1];
                }
                
                [[tempVideo.thumbnailID shouldNot] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
            
        });
        
        it(@"Should allow you to retrieve a video.", ^{
            __block BPVideo *retrievedVideo;
            __block BOOL fin = NO;

            [[Buddy videos] getVideo:tempVideo.id callback:^(id newBuddyObject, NSError *error) {
                [[error should] beNil];

                if (error) {
                    fin = YES;
                    return;
                }
                retrievedVideo = newBuddyObject;
                
                [[retrievedVideo shouldNot] beNil];
                [[retrievedVideo.id should] equal:tempVideo.id];
                
                [[retrievedVideo.contentType should] equal:tempVideo.contentType];
                [[[retrievedVideo.signedUrl componentsSeparatedByString:@"?"][0] should] equal:[tempVideo.signedUrl componentsSeparatedByString:@"?"][0]];
                [[retrievedVideo.title should] equal:tempVideo.title];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow you to modify a video.", ^{
            
            __block BPVideo *secondVideo;
            __block BOOL fin = NO;

            tempVideo.title = @"Modified title";
            
            [tempVideo save:^(NSError *error) {
                [[error should] beNil];
                [[Buddy videos] getVideo:tempVideo.id callback:^(id newBuddyObject, NSError *error) {
                    [[error should] beNil];
                    secondVideo = newBuddyObject;
                    [[secondVideo shouldNot] beNil];
                    [[secondVideo.title should] equal:@"Modified title"];
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow you to delete a video.", ^{
            __block BOOL fin = NO;

            [tempVideo destroy:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
    });
});

SPEC_END
