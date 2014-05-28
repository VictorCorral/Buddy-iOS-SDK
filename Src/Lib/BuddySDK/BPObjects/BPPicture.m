//
//  BPPicture.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "BPPicture.h"
#import "BuddyObject+Private.h"

@implementation BPSearchPictures

@synthesize caption, size, watermark;

@end

@implementation BPPicture

@synthesize caption = _caption;
@synthesize size = _size;
@synthesize watermark = _watermark;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(caption)];
    [self registerProperty:@selector(size)];
    [self registerProperty:@selector(watermark)];
}


static NSString *pictures = @"pictures";
+ (NSString *) requestPath
{
    return pictures;
}

static NSString *pictureMimeType = @"image/png";
+ (NSString *)mimeType
{
    return pictureMimeType;
}

- (void)savetoServerWithImage:(UIImage *)image client:(id<BPRestProvider>)client callback:(BuddyCompletionCallback)callback
{
    NSData *data = UIImagePNGRepresentation(image);
    
    [self savetoServerWithData:data client:client callback:callback];
}

- (void)getImage:(BuddyImageResponse)callback
{
    [self getData:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        callback ? callback(image, error) : nil;
    }];
}

@end
