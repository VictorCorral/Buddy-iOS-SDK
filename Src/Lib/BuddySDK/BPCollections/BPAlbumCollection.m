//
//  BPAlbumCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/24/14.
//
//

#import "BPAlbumCollection.h"
#import "BuddyCollection+Private.h"
#import "BuddyObject+Private.h"
#import "BPAlbum.h"

@implementation BPAlbumCollection

- (instancetype)initWithClient:(id<BPRestProvider>)client{
    self = [super initWithClient:client];
    if(self){
        self.type = [BPAlbum class];
    }
    return self;
}

- (void)addAlbum:(BPAlbum *)album
        callback:(BuddyCompletionCallback)callback
{
    [album savetoServer:callback];
}
    
-(void)getAlbums:(BuddyCollectionCallback)callback
{
    [self getAll:callback];
}
    

-(void)searchAlbums:(BPSearchAlbum *)searchAlbum callback:(BuddyCollectionCallback)callback
{
    id parameters = [searchAlbum parametersFromProperties];
    
    [self search:parameters callback:callback];
}
    
- (void)getAlbum:(NSString *)albumId callback:(BuddyObjectCallback)callback
{
    [self getItem:albumId callback:callback];
}

@end
