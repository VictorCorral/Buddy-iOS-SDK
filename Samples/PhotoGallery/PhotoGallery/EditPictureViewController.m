//
//  EditPictureViewController.m
//  PhotoGallery
//
//  Created by Nick Ambrose on 1/24/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import <BuddySDK/BuddyObject.h>
#import <BuddySDK/BPPicture.h>
#import <BuddySDK/BPMetadataItem.h>

#import "Constants.h"
#import "AppDelegate.h"
#import "PictureList.h"

#import "EditPictureViewController.h"

#define TAG_META_KEY @"TAG"

@interface EditPictureViewController ()
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) BPPicture *picture;
@property (nonatomic,strong) NSString *tagString;
-(void) goBack;

-(void) populateUI;

-(void) resignTextFields;
-(BuddyCompletionCallback) getSavePhotoCallback;
-(BuddyCompletionCallback) getSaveTagCallback;
-(BuddyCompletionCallback) getDeletePhotoCallback;
-(BPMetadataCallback) getFetchMetadataCallback;

-(void) loadMetaData;
@end

@implementation EditPictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPicture:(BPPicture*) picture
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _picture=picture;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.deleteButton.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.deleteButton.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.deleteButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.deleteButton.clipsToBounds = YES;
    
    self.saveButton.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.saveButton.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.saveButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.saveButton.clipsToBounds = YES;
    
    self.mainImage.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.mainImage.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.mainImage.layer.borderColor = [UIColor blackColor].CGColor;
    self.mainImage.clipsToBounds = YES;

    
    [self loadMetaData];
    [self populateUI];
}

-(BuddyCompletionCallback) getSavePhotoCallback
{
    EditPictureViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        if(error!=nil)
        {
            NSLog(@"SavePhotoCallback - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Saving Photo"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        
        BPMetadataItem *i = [BPMetadataItem new];
        i.value = weakSelf.tagString;
        i.key = TAG_META_KEY;
        i.visibility = BPPermissionsApp;
        NSLog(@"SavePhotoCallback - success Called");
        [weakSelf.picture setMetadata:i callback:[weakSelf getSaveTagCallback]];
        
    };
    
}
-(BuddyCompletionCallback) getDeletePhotoCallback
{
    EditPictureViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        if(error!=nil)
        {
            NSLog(@"DeletePhotoCallback - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Saving Photo"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [[CommonAppDelegate userPictures] removePicture:self.picture andImage:TRUE];
        
        NSLog(@"DeletePhotoCallback - success Called");
        [self goBack];
    };

}

-(BuddyCompletionCallback) getSaveTagCallback
{
    EditPictureViewController * __weak weakSelf = self;
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        if(error!=nil)
        {
            NSLog(@"SaveTagCallback - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Saving Photo"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"SaveTagCallback - success Called");
        [self goBack];
    };

}

-(BPMetadataCallback) getFetchMetadataCallback
{
    EditPictureViewController * __weak weakSelf = self;
    return ^(id newBuddyObject, NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error==nil)
        {
            BPMetadataItem *metaData = newBuddyObject;
            self.tagString = metaData.value;
            [self populateUI];
        }
    };
}

-(void) goBack
{
    [[CommonAppDelegate navController] popViewControllerAnimated:YES];
}

-(void) resignTextFields
{
    [self.commentText resignFirstResponder];
    [self.tagText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textBoxName
{
	[textBoxName resignFirstResponder];
	return YES;
}

-(void) populateUI
{
    if(self.picture==nil)
    {
        return;
    }
    
    UIImage *pictureImage = [[CommonAppDelegate userPictures] getImageByPictureID:self.picture.id];
    if(pictureImage!=nil)
    {
        [self.mainImage setImage:pictureImage];
    }
    else
    {
        [self.mainImage setBackgroundColor:[UIColor blackColor]];
    }
    
    self.commentText.text = self.picture.caption;
    self.tagText.text = self.tagString;
    
}

-(IBAction)doDelete:(id)sender
{
    if(self.picture==nil)
    {
        return;
    }
    
    [self.picture destroy:[self getDeletePhotoCallback]];

}

-(IBAction)doSave:(id)sender
{
    if(self.picture==nil)
    {
        return;
    }
    
    self.picture.caption = self.commentText.text;
    self.tagString = self.tagText.text;
    
    [self.picture save:[self getSavePhotoCallback]];
    
}

-(void) loadMetaData
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Loading Tag Info";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    [self.picture getMetadataWithKey:TAG_META_KEY visibility:BPPermissionsApp callback:[self getFetchMetadataCallback]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
