//
//  ChangeProfileViewController.h
//  registerlogin
//
//  Created by devmania on 3/21/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ChangeProfilePictureViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIButton *choosePhotoBut;

@property (weak, nonatomic) IBOutlet UIButton *deletePhotoBut;


@property (nonatomic,strong) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

- (IBAction)showCamera:(id)sender;
- (IBAction)doDeletePhoto:(id)sender;

@end
