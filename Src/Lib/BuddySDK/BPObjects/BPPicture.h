//
//  BPPicture.h
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import <UIKit/UIKit.h>
#import "BPBlob.h"
#import "BPSize.h"

@protocol BPPictureProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *watermark;
@property (nonatomic, strong) BPSize *size;

@end

@class BPPicture;

@interface BPSearchPictures : BPObjectSearch<BPPictureProperties>

@end

typedef void(^BuddyImageResponse)(UIImage *image, NSError *error);

@interface BPPicture : BPBlob<BPPictureProperties>

- (void)savetoServerWithImage:(UIImage *)image client:(id<BPRestProviderOld>)client callback:(BuddyCompletionCallback)callback;

- (void)getImage:(BuddyImageResponse)callback;
- (void)getImageWithSize:(BPSize*)size callback:(BuddyImageResponse)callback;

@end
