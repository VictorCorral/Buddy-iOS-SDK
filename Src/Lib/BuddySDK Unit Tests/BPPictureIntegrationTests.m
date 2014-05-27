//
//  BPPictureIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/3/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BuddyPictureSpec)

describe(@"BPPictureIntegrationSpec", ^{
    
    __block BOOL fin = NO;
    
    beforeEach(^{
        fin = NO;
    });
    
    context(@"When a user is NOT logged in", ^{
        
        beforeAll(^{
            [BuddyIntegrationHelper bootstrapInit];
        });
        
        it(@"Should not allow them to add and describe pictures.", ^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            __block BPPicture *picture = [BPPicture new];
            picture.caption = @"Hello, caption!";
            
            [[Buddy pictures] addPicture:picture image:image callback:^(NSError *error) {
                [[error shouldNot] beNil];
                [[picture.id should] beNil];
                [[theValue([error code]) should] equal:theValue(0x107)]; // AuthUserAccessTokenRequired = 0x107
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
    }),
            
    context(@"When a user is logged in", ^{
        __block BPPicture *newPicture;
        
        beforeEach(^{
            fin = NO;
        });
        
        beforeAll(^{            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        
        it(@"Should allow users to post pictures", ^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            newPicture = [BPPicture new];
            newPicture.caption = @"Hello, caption!";
            
            [[Buddy pictures] addPicture:newPicture image:image callback:^(NSError *error) {
                [[error should] beNil];
                if (error) return;
                
                [[theValue(newPicture.contentLength) should] beGreaterThan:theValue(1)];
                [[newPicture.contentType should] equal:@"image/png"];
                [[newPicture.signedUrl should] haveLengthOfAtLeast:1];
                [[newPicture.caption should] equal:@"Hello, caption!"];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow retrieving pictures", ^{
            __block BPPicture *secondPicture;
            [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                secondPicture = newBuddyObject;
                
                [[error should] beNil];
                
                if (error) return;
                
                [[theValue(secondPicture.contentLength) should] equal:theValue(newPicture.contentLength)];
                [[secondPicture.contentType should] equal:@"image/png"];
                [[[secondPicture.signedUrl componentsSeparatedByString:@"?"][0] should] equal:[newPicture.signedUrl componentsSeparatedByString:@"?"][0]];
                [[secondPicture.caption should] equal:newPicture.caption];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow modifying pictures", ^{
            __block BPPicture *secondPicture;
        
            newPicture.caption = @"Some new picture caption";
            
            [newPicture save:^(NSError *error) {
                [[error should] beNil];
                [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                    secondPicture = newBuddyObject;
                }];
            }];
            

            [[expectFutureValue(secondPicture) shouldEventually] beNonNil];
            [[expectFutureValue(secondPicture.caption) shouldEventually] equal:@"Some new picture caption"];
        });
        
        it(@"Should allow modifying a *retrieved* picture", ^{
            __block BPPicture *retrievedPicture;
            [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                retrievedPicture = newBuddyObject;
            }];
            
            [[expectFutureValue(retrievedPicture) shouldEventually] beNonNil];
            
            retrievedPicture.caption = @"Hakuna matata";
            
            [retrievedPicture save:^(NSError *error) {
                [[error should] beNil];
                retrievedPicture = nil;
                [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                    retrievedPicture = newBuddyObject;
                }];
            }];
            
            
            [[expectFutureValue(retrievedPicture) shouldEventually] beNonNil];
            [[expectFutureValue(retrievedPicture.caption) shouldEventually] equal:@"Hakuna matata"];
        });
        
        it(@"Should allow directly retrieving the image file", ^{
            __block UIImage *theImage;
            [newPicture getImage:^(UIImage *image, NSError *error) {
                theImage = image;
            }];
            
            [[expectFutureValue(theImage) shouldEventually] beNonNil];
        });
        
        it(@"Should allow searching for images", ^{
            __block NSArray *retrievedPictures;

            BPSearchPictures *searchPicture = [BPSearchPictures new];
            // Test "Default" limit code.
            searchPicture.caption = @"Hakuna matata";
            
            [[Buddy pictures] searchPictures:searchPicture callback:^(NSArray *buddyObjects, NSError *error) {
                NSArray *p = buddyObjects;
                
                [[theValue([p count]) should]beGreaterThan:theValue(0)];
                for(BPPicture *picture in p) {
                    [[picture.caption should] equal:@"Hakuna matata"];
                }
                retrievedPictures = buddyObjects;
            }];
            
        });
        
        it(@"Should allow searching for images2", ^{
            __block NSArray *retrievedPictures;
            
            BPSearchPictures *searchPicture = [BPSearchPictures new];
            searchPicture.caption = @"Hakuna matataX";
            
            [[Buddy pictures] searchPictures:searchPicture callback:^(NSArray *buddyObjects, NSError *error) {
                retrievedPictures = buddyObjects;
            }];
            
            [[expectFutureValue(theValue([retrievedPictures count])) shouldEventually] equal:theValue(0)];
        });
        
        it(@"Should allow the user to delete pictures", ^{
            [newPicture destroy:^(NSError *error){
                [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                    newPicture = newBuddyObject;
                }];
            }];
            
            [[expectFutureValue(newPicture) shouldEventually] beNil];
        });
        
        
    });
});

SPEC_END

