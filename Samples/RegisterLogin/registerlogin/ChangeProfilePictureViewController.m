//
//  ChangeProfileViewController.m
//  registerlogin
//
//  Created by devmania on 3/21/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <BuddySDK/Buddy.h>

#import "ChangeProfilePictureViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ChangeProfilePictureViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;



-(BuddyCompletionCallback) getSavePhotoCallback;
-(BuddyCompletionCallback) getDeletePhotoCallback;

@end

@implementation ChangeProfilePictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Change Profile Picture"];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doSave:)];
    [[self navigationItem] setRightBarButtonItem:saveButton];
    
  
    [self populateUI];
}

-(void) populateUI
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Loading...";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    NSString *picId = [NSURL URLWithString:Buddy.user.profilePictureID];
    
    if (picId==nil)
    {
        [self.HUD hide:YES];
        return;
    }
    
    [[Buddy pictures] getPicture:picId callback:^(id newBuddyObject, NSError *error) {
        if (!error && newBuddyObject) {
            BPPicture* pic = newBuddyObject;
            [self.captionField setText:pic.caption];
            [self.choosePhotoBut setTitle:@"Loading..." forState:UIControlStateNormal];
            
            BPSize* size = BPSizeMake(150, 0);
        
            [pic getImageWithSize:size callback:^(UIImage *img, NSError *error) {
               
                        UIGraphicsBeginImageContext(CGSizeMake(1,1));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [img CGImage]);
                        UIGraphicsEndImageContext();
                        [self.choosePhotoBut setTitle:@"" forState:UIControlStateNormal];
                
                        if(img!=nil)
                        {
                            [self.choosePhotoBut setImage:img forState:UIControlStateNormal];
                        }
                        else
                        {
                            [self.choosePhotoBut setBackgroundColor:[UIColor blackColor]];
                        }
            }];
        }
    }];
    
    
    
    [self.HUD hide:YES];
}



- (IBAction)showCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerCamera =[[UIImagePickerController alloc] init];
        imagePickerCamera.delegate = self;
        imagePickerCamera.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePickerCamera.allowsEditing = YES;
        imagePickerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerCamera  animated:YES completion:nil];
    }
    
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePickerAlbum =[[UIImagePickerController alloc] init];
        imagePickerAlbum.delegate = self;
        imagePickerAlbum.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePickerAlbum.allowsEditing = YES;
        imagePickerAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerAlbum animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    CGSize newSize = CGSizeMake(150, 150);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [chosenImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    self.selectedImage = chosenImage;
    [self.choosePhotoBut setTitle:@"" forState:UIControlStateNormal];
    [self.choosePhotoBut setImage:newImage forState: UIControlStateNormal];
    [self.choosePhotoBut setImage:newImage forState:UIControlStateSelected];
    [self.choosePhotoBut setContentMode:UIViewContentModeScaleToFill];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.choosePhotoBut setImage:nil forState: UIControlStateNormal];
    [self.choosePhotoBut setTitle:@"Choose Photo" forState:UIControlStateNormal];
    
}


- (void)doSave:(id)sender
{
    if (self.selectedImage==nil)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Notification"
                                   message: @"Please select photo"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    self.HUD.labelText= @"Saving...";
    [self.HUD show:YES];

    NSString *photoCaption = self.captionField.text;
    [Buddy.user setUserProfilePicture:self.selectedImage caption:photoCaption callback: [self getSavePhotoCallback]];
}

- (IBAction)doDeletePhoto:(id)sender
{
    self.HUD.labelText= @"Deleting Photo...";
    [self.HUD show:YES];
    
    [Buddy.user deleteUserProfilePicture:[self getDeletePhotoCallback]];
}

-(BuddyCompletionCallback) getSavePhotoCallback
{
    ChangeProfilePictureViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Save User profile picture - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Saving Profile Photo"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Save User profile picture - success Called");
        [[self navigationController] popViewControllerAnimated:YES];
        
    };
    
}

-(BuddyCompletionCallback) getDeletePhotoCallback
{
    ChangeProfilePictureViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Delete User profile picture - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Deleting Profile Photo"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Delete User profile picture - success Called");
        [[self navigationController] popViewControllerAnimated:YES];
        
    };
    
}
@end
