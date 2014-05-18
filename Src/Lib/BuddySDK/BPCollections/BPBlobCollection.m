//
//  BPBlobCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/7/14.
//
//

#import "BPBlobCollection.h"
#import "BuddyCollection+Private.h"
#import "BPBlob.h"

@implementation BPBlobCollection

- (instancetype)initWithClient:(id<BPRestProvider>)client {
    self = [super initWithClient:client];
    if(self){
        self.type = [BPBlob class];
    }
    return self;
}

- (void)addBlob:(BPBlob *)blob
       data:(NSData *)data
       callback:(BuddyCompletionCallback)callback;
{
    [blob savetoServerWithData:data callback:callback];
}

-(void)getBlobs:(BuddyCollectionCallback)callback
{
    [self getAll:callback];
}

- (void)getBlob:(NSString *)blobId callback:(BuddyObjectCallback)callback
{
    [self getItem:blobId callback:callback];
}

- (void)searchBlobs:(BPBlobSearch *)searchBlobs callback:(BuddyCollectionCallback)callback
{
    id parameters = [searchBlobs parametersFromProperties];
    
    [self search:parameters callback:callback];
}

@end
