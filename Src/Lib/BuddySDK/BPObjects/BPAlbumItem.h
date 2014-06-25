//
//  BPAlbumItem.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/24/14.
//
//

#import "BuddyObject.h"

typedef NS_ENUM(NSInteger, BPAlbumItemType) {
    BPAlbumItemTypeUnknown,
    BPAlbumItemTypePicture,
    BPAlbumItemTypeVideo
};

@protocol BPMediaItem <NSObject>

@required

- (NSString *)id;

@end

@protocol BPAlbumItemProperties <BuddyObjectProperties>

@property (nonatomic, readonly, copy) NSString *albumID;
@property (nonatomic, readonly, copy) NSString *itemID;
@property (nonatomic, readonly, assign) BPAlbumItemType itemType;
@property (nonatomic, copy) NSString *caption;

@end

@interface BPSearchAlbumItems : BPObjectSearch<BPAlbumItemProperties>

@property (nonatomic, copy) NSString *albumID;
@property (nonatomic, copy) NSString *itemID;
@property (nonatomic, assign) BPAlbumItemType itemType;

@end

typedef void(^BuddyAlbumItemResponse)(NSData *data, NSError *error);
typedef void(^BuddyAlbumPictureResponse)(UIImage *data, NSError *error);

@interface BPAlbumItem : BuddyObject<BPAlbumItemProperties>

- (void)getData:(BuddyAlbumItemResponse)callback;
- (void)getImage:(BuddyAlbumPictureResponse)callback;

@end
