//
//  BPBlob.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/4/14.
//
//
#import "BPAlbumItem.h"

@protocol BPBlobProperties <BuddyObjectProperties>

@property (nonatomic, readonly, assign) NSInteger contentLength;
@property (nonatomic, readonly, copy) NSString *contentType;
@property (nonatomic, readonly, copy) NSString *signedUrl;
@property (nonatomic, copy) NSString *friendlyName;

@end

@interface BPBlobSearch : BPObjectSearch<BPBlobProperties>

@end

@interface BPBlob : BuddyObject<BPBlobProperties, BPMediaItem>

typedef void(^BuddyDataResponse)(NSData *data, NSError *error);

- (void)savetoServerWithData:(NSData *)data client:(id<BPRestProvider>)client callback:(BuddyCompletionCallback)callback;

- (void)getData:(BuddyDataResponse)callback;

@end
