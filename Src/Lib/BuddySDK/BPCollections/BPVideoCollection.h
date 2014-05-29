//
//  BPVideoCollection.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/5/14.
//
//

#import "BPVideo.h"

@interface BPVideoCollection : BuddyCollection

- (void)addVideo:(BPVideo *)video
       videoData:(NSData *)videoData
        callback:(BuddyCompletionCallback)callback;

- (void)searchVideos:(BPVideoSearch *)searchVideo callback:(BPSearchCallback)callback;

- (void)getVideo:(NSString *)pictureId callback:(BuddyObjectCallback)callback;

@end
