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
#define kKW_DEFAULT_PROBE_TIMEOUT 30.0

SPEC_BEGIN(BuddyAlbumSpec)

describe(@"BPAlbumIntegrationSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPAlbum *tempAlbum;
        __block BPPicture *tempPicture;
        __block BPAlbumItem *tempItem;
        __block BOOL fin = NO;

        beforeAll(^{
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        beforeEach(^{
            fin = NO;
        });
        
        it(@"Should allow you create an album.", ^{
            
            tempAlbum = [BPAlbum new];
            tempAlbum.name = @"My album";
            tempAlbum.caption = @"Kid pictures";
            
            [[Buddy albums] addAlbum:tempAlbum callback:^(NSError *error) {
                [[error should] beNil];
                [[tempAlbum.id shouldNot] beNil];
                [[tempAlbum.name should] equal:@"My album"];
                [[tempAlbum.caption should] equal:@"Kid pictures"];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow you to retrieve an album.", ^{
            __block BPAlbum *retrievedAlbum;
            [[Buddy albums] getAlbum:tempAlbum.id callback:^(id newBuddyObject, NSError *error) {
                retrievedAlbum = newBuddyObject;
            }];
            
            [[expectFutureValue(retrievedAlbum) shouldEventually] beNonNil];
            [[expectFutureValue(retrievedAlbum.name) shouldEventually] equal:tempAlbum.name];
            [[expectFutureValue(retrievedAlbum.caption) shouldEventually] equal:tempAlbum.caption];
        });
        
        it(@"Should allow you to search for albums.", ^{
            __block NSArray *retrievedAlbums;
            
            [[Buddy albums] searchAlbums:nil callback:^(NSArray *buddyObjects, NSString *pagingToken, NSError *error) {
                retrievedAlbums = buddyObjects;
            }];
            
            [[expectFutureValue(theValue([retrievedAlbums count])) shouldEventually] beGreaterThan:theValue(0)];
        });
        
        it(@"Should allow you to modify an album.", ^{
            __block BPAlbum *retrievedAlbum;

            tempAlbum.caption = @"Some new caption";
            
            [tempAlbum save:^(NSError *error) {
                [[Buddy albums] getAlbum:tempAlbum.id callback:^(id newBuddyObject, NSError *error) {
                    retrievedAlbum = newBuddyObject;
                }];
            }];
            
            [[expectFutureValue(retrievedAlbum.caption) shouldEventually] equal:@"Some new caption"];
        });
        
        
        it(@"Should allow you to add items to an album.", ^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            tempPicture = [BPPicture new];
            tempPicture.caption = @"Test image for album";
            
            [[Buddy pictures] addPicture:tempPicture image:image callback:^(NSError *error) {
                [[error should] beNil];
                __block BPAlbumItem *newItem = [BPAlbumItem new];
                newItem.caption = @"Caption";

                [tempAlbum addItemToAlbum:newItem withItem:tempPicture callback:^(NSError *error) {
                    [[error should] beNil];
                    tempItem = newItem;
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        
        it(@"Should allow you to retrieve an item from an album.", ^{
            __block BPPicture *retrievedPicture;
            [tempAlbum getAlbumItem:tempItem.id callback:^(id newBuddyObject, NSError *error) {
                retrievedPicture = newBuddyObject;
            }];

            [[expectFutureValue(retrievedPicture) shouldEventually] beNonNil];
        });
        
        it(@"Should allow searching from retrieved albums (Github issue #23", ^{
            __block BOOL fin = NO;
            
            [[Buddy albums] searchAlbums:nil callback:^(NSArray *buddyObjects, NSString *pagingToken, NSError *error) {
                BPAlbum *album = [buddyObjects firstObject];
                                
                [album searchAlbumItems:nil callback:^(NSArray *buddyObjects, NSString *pagingToken, NSError *error) {
                    [[error should] beNil];
                    [[buddyObjects shouldNot] beNil];
                    [[theValue([buddyObjects count]) should] beGreaterThan:theValue(0)];
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow you to get the file for an item from an album.", ^{
            __block UIImage *retrievedPicture;
            [tempItem getImage:^(UIImage *image, NSError *error) {
                [[error should] beNil];
                retrievedPicture = image;
            }];
            
            [[expectFutureValue(retrievedPicture) shouldEventually] beNonNil];
        });
        it(@"Should allow you to search for items in an album.", ^{
            __block NSArray *retrievedPictures;
            [tempAlbum searchAlbumItems:nil callback:^(NSArray *buddyObjects, NSString *pagingToken, NSError *error) {
                [[error should] beNil];
                retrievedPictures = buddyObjects;
            }];
            
            [[expectFutureValue(theValue([retrievedPictures count])) shouldEventually] beGreaterThan:theValue(0)];
        });
        
        it(@"Should allow you to delete an album.", ^{
            __block NSString *deletedId = tempAlbum.id;
            [tempAlbum destroy:^(NSError *error){
                [[Buddy albums] getAlbum:deletedId callback:^(id newBuddyObject, NSError *error) {
                    [[error should] beNonNil];
                    tempAlbum = newBuddyObject;
                }];
            }];
            
            [[expectFutureValue(tempAlbum) shouldEventually] beNil];
        });
    });
});

SPEC_END
