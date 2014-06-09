//
//  BPBlob.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/4/14.
//
//

#import "BPBlob.h"
#import "BuddyObject+Private.h"
#import "Buddy.h"

@implementation BPBlobSearch

@synthesize contentLength, contentType, signedUrl, friendlyName;

@end

@interface BPBlob()

@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *signedUrl;
@property (nonatomic, assign) NSInteger contentLength;

@end

@implementation BPBlob

@synthesize contentLength, contentType, signedUrl, friendlyName;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(friendlyName)];
}

static NSString *blobs = @"blobs";
+ (NSString *) requestPath
{
    return blobs;
}

static NSString *blobMimeType = @"application/octet-stream";
+ (NSString *)mimeType
{
    return blobMimeType;
}

- (void)savetoServerWithData:(NSData *)data callback:(BuddyCompletionCallback)callback
{
    NSDictionary *multipartParameters = @{@"data": BOXNIL(data)};
    
    NSDictionary *parameters = [self buildUpdateDictionary];
    
    [self.client MULTIPART_POST:[[self class] requestPath]
                parameters:parameters
                      data:multipartParameters
                  mimeType:[[self class] mimeType]
                  callback:^(id json, NSError *error)
     {
         if (!error) {
             [[JAGPropertyConverter converter] setPropertiesOf:self fromDictionary:json];
         }
         callback ? callback(error) : nil;
     }];
}

+ (void)createWithData:(NSData *)data parameters:(NSDictionary *)parameters client:(id<BPRestProvider, BPLocationProvider>)client callback:(BuddyObjectCallback)callback

{
    NSDictionary *multipartParameters = @{@"data": BOXNIL(data)};
    
    [client MULTIPART_POST:[[self class] requestPath]
                parameters:parameters
                      data:multipartParameters
                  mimeType:[[self class] mimeType]
                  callback:^(id json, NSError *error)
    {
        if(error){
            callback ? callback(nil, error) : nil;
            return;
        }
        
        BuddyObject *newObject = [[[self class] alloc] initBuddyWithClient:client];
        
        newObject.id = json[@"id"];
    
        [newObject refresh:^(NSError *error){
            callback ? callback(newObject, error) : nil;
        }];
        
    }];
}

- (void)getData:(BuddyDataResponse)callback
{
    [self getDataWithParameters:nil callback:^(NSData *data, NSError *error) {
        callback ? callback(data, error) : nil;
    }];
}

- (void)getDataWithParameters:(NSDictionary*)parameters callback:(BuddyDataResponse)callback
{
    NSString *resource = [NSString stringWithFormat:@"%@/%@/%@", [[self class] requestPath], self.id, @"file"];
    
    [self.client GET_FILE:resource parameters:parameters callback:^(id imageByes, NSError *error) {
        callback ? callback(imageByes, error) : nil;
    }];
}

@end
