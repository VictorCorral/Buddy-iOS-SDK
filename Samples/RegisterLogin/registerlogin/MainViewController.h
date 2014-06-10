//
//  MainViewController.h
//  registerlogin
//
//  Created by Nick Ambrose on 1/15/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BuddySDK/BuddyObject.h"

@interface MainViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic,weak) IBOutlet UILabel *mainLabel;

@property (nonatomic,weak) IBOutlet UILabel *emailLabel;

@property (nonatomic,weak) IBOutlet UIButton *refreshBut;
@property (nonatomic,weak) IBOutlet UIButton *clearUserBut;
@property (weak, nonatomic) IBOutlet UIButton *changeProfilePictureBut;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBut;
@property (weak, nonatomic) IBOutlet UIButton *changeNameBirthdayBut;
@property (weak, nonatomic) IBOutlet UIButton *searchUserBut;
@property (weak, nonatomic) IBOutlet UIButton *deleteUserBut;
@property (weak, nonatomic) IBOutlet UIButton *identitiesBut;

- (void)updateFields;

- (IBAction)doRefresh:(id)sender;
- (IBAction)doClearUser:(id)sender;
- (IBAction)doChangeProfilePicture:(id)sender;
- (IBAction)doResetPassword:(id)sender;
- (IBAction)doChangeNameBirthday:(id)sender;
- (IBAction)doSearchUsers:(id)sender;
- (IBAction)doDeleteUser:(id)sender;
- (IBAction)doIdentities:(id)sender;
- (void)doLogout;



@end
