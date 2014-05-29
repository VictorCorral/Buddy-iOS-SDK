//
//  BPBlobCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/7/14.
//
//

#import "BPBlob.h"

@interface BPBlobCollection : BuddyCollection

- (void)addBlob:(BPBlob *)blob
           data:(NSData *)data
       callback:(BuddyCompletionCallback)callback;

- (void)getBlobs:(BPSearchCallback)callback;

- (void)searchBlobs:(BPBlobSearch *)searchBlobs callback:(BPSearchCallback)callback;

- (void)getBlob:(NSString *)blobId callback:(BuddyObjectCallback)callback;

@end
