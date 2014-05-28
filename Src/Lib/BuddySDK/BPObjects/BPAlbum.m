//
//  BPAlbum.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/8/14.
//
//

#import "BPAlbum.h"
#import "BPAlbumItem.h"
#import "BPAlbumItem.h"
#import "BPAlbumItemCollection.h"
#import "BuddyObject+Private.h"
#import "BPRestProvider.h"
#import "BPCLient.h"

@implementation BPSearchAlbum

@synthesize name, caption;

@end

@interface BPAlbum()

@property (nonatomic, strong) BPAlbumItemCollection *items;
    
@end

@implementation BPAlbum

@synthesize name = _name;
@synthesize caption = _caption;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerProperties];
    }
    return self;
}

- (instancetype)initBuddyWithClient:(id<BPRestProvider>)client {
    self = [super initBuddyWithClient:client];
    if(self)
    {
        [self registerProperties];
        _items = [[BPAlbumItemCollection alloc] initWithAlbum:self andClient:client];
    }
    return self;
}

- (instancetype)initBuddyWithResponse:(id)response andClient:(id<BPRestProvider>)rest {
    self = [super initBuddyWithResponse:response andClient:rest];
    if(self)
    {
        [self registerProperties];
        _items = [[BPAlbumItemCollection alloc] initWithAlbum:self andClient:rest];
    }
    return self;
}

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(name)];
    [self registerProperty:@selector(caption)];
}

- (BPAlbumItemCollection *)items
{
    assert(self.client);
    
    if (!_items && self.client) {
        _items = [[BPAlbumItemCollection alloc] initWithAlbum:self andClient:self.client];
    }
    return _items;
}

static NSString *albums = @"albums";
+(NSString *) requestPath{
    return albums;
}

- (void)addItemToAlbum:(BPAlbumItem *)albumItem withItem:(BuddyObject<BPMediaItem> *)itemToAdd callback:(BuddyCompletionCallback)callback
{
    assert(self.items);
    
    [self.items addAlbumItem:albumItem withItem:itemToAdd callback:callback];
    
}

- (void)searchAlbumItems:(BPSearchAlbumItems *)searchAlbumItem callback:(BuddyCollectionCallback)callback
{
    [self.items searchAlbumItems:searchAlbumItem callback:callback];
}

- (void)getAlbumItem:(NSString *)itemId callback:(BuddyObjectCallback)callback
{
    [self.items getAlbumItem:itemId callback:callback];
}

@end
