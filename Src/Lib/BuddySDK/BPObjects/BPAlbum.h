//
//  BPAlbum.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/8/14.
//
//

#import "BPAlbumItem.h"

@protocol BPAlbumProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *name;

@end

@interface BPSearchAlbum : BPObjectSearch<BPAlbumProperties>

@end

@interface BPAlbum : BuddyObject<BPAlbumProperties>

- (void)addItemToAlbum:(BPAlbumItem *)albumItem withItem:(BuddyObject<BPMediaItem> *)itemToAdd callback:(BuddyCompletionCallback)callback;
- (void)getAlbumItem:(NSString *)itemId callback:(BuddyObjectCallback)callback;
- (void)searchAlbumItems:(BPSearchAlbumItems *)searchAlbumItem callback:(BPSearchCallback)callback;

@end
