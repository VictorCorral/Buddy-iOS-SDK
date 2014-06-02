//
//  MainViewController.m
//  registerlogin
//
//  Created by Nick Ambrose on 1/15/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "MBProgressHUD.h"

#import <BuddySDK/Buddy.h>

#import "Constants.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "ChangeProfilePictureViewController.h"
#import "ResetPasswordViewController.h"
#import "ChangeNameBirthdayVC.h"
#import "SearchUsersViewController.h"
#import "IdentitiesViewController.h"

#import <BuddySDK/Buddy.h>

@interface MainViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;

- (BuddyCompletionCallback) getRefreshCallback;
- (BuddyCompletionCallback) getClearUserCallback;
- (BuddyCompletionCallback) getDeleteCallback;

@end

@implementation MainViewController

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
    
    [[CommonAppDelegate navController] setNavigationBarHidden:YES];
    
    UIBarButtonItem *backButton =[[UIBarButtonItem alloc] initWithTitle:@"Logout"  style:UIBarButtonItemStylePlain target:self action:@selector(doLogout)];
    
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.refreshBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.refreshBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.refreshBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.refreshBut.clipsToBounds = YES;

    self.clearUserBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.clearUserBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.clearUserBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.clearUserBut.clipsToBounds = YES;
    
    self.changeNameBirthdayBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.changeNameBirthdayBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.changeNameBirthdayBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.changeNameBirthdayBut.clipsToBounds = YES;
    
    self.changeProfilePictureBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.changeProfilePictureBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.changeProfilePictureBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.changeProfilePictureBut.clipsToBounds = YES;
    
    self.resetPasswordBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.resetPasswordBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.resetPasswordBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.resetPasswordBut.clipsToBounds = YES;
    
    self.searchUserBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.searchUserBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.searchUserBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.searchUserBut.clipsToBounds = YES;
    
    self.deleteUserBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.deleteUserBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.deleteUserBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.deleteUserBut.clipsToBounds = YES;
    
    self.identitiesBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.identitiesBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.identitiesBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.identitiesBut.clipsToBounds = YES;
}

- (void) updateFields
{
    [[CommonAppDelegate navController] setNavigationBarHidden:YES];
    self.mainLabel.text = [NSString stringWithFormat:@"Hi %@ %@",
                           Buddy.user.firstName, Buddy.user.lastName];
    
}

- (BuddyCompletionCallback) getRefreshCallback
{
    MainViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        self.HUD=nil;
    };
}

- (BuddyCompletionCallback) getClearUserCallback
{
    MainViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        self.HUD=nil;
    };
}

- (void)doLogout
{
    [Buddy logout:^(NSError *error)
     {
         NSLog(@"Logout Callback Called");
     }];
 
    [CommonAppDelegate authorizationNeedsUserLogin];
}

- (IBAction)doRefresh:(id)sender
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Refresh";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    [Buddy.user refresh:[self getRefreshCallback]];
    
}

- (IBAction)doClearUser:(id)sender
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Clear User";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;

    [Buddy logout:[self getClearUserCallback]];
    [CommonAppDelegate authorizationNeedsUserLogin];
}

- (IBAction)doChangeProfilePicture:(id)sender
{
    ChangeProfilePictureViewController *subVC = [[ChangeProfilePictureViewController alloc]
                                            initWithNibName:@"ChangeProfilePictureViewController" bundle:nil];
    
    [ [CommonAppDelegate navController] pushViewController:subVC animated:YES];
}

- (IBAction)doResetPassword:(id)sender
{
    ResetPasswordViewController *subVC = [[ResetPasswordViewController alloc]
                                                      initWithNibName:@"ResetPasswordViewController" bundle:nil];
    
    [ [CommonAppDelegate navController] pushViewController:subVC animated:YES];
}

- (IBAction)doChangeNameBirthday:(id)sender
{
    ChangeNameBirthdayVC *subVC = [[ChangeNameBirthdayVC alloc]
                                                 initWithNibName:@"ChangeNameBirthdayVC" bundle:nil];
    
    [ [CommonAppDelegate navController] pushViewController:subVC animated:YES];
}

- (IBAction)doSearchUsers:(id)sender
{
    SearchUsersViewController *subVC = [[SearchUsersViewController alloc]
                                   initWithNibName:@"SearchUsersViewController" bundle:nil];
    
    [ [CommonAppDelegate navController] pushViewController:subVC animated:YES];
}

- (IBAction)doDeleteUser:(id)sender
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Deleting...";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    [[Buddy user] destroy:[self getDeleteCallback]];
}

- (IBAction)doIdentities:(id)sender {
    IdentitiesViewController *subVC = [[IdentitiesViewController alloc]
                                        initWithNibName:@"IdentitiesViewController" bundle:nil];
    
    [ [CommonAppDelegate navController] pushViewController:subVC animated:YES];
}

- (BuddyCompletionCallback) getDeleteCallback
{
    MainViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Deleting user - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Deleting user"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Deleting user - success Called");
        [CommonAppDelegate authorizationNeedsUserLogin];
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateFields];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(self.HUD!=nil)
    {
        [self.HUD hide:TRUE afterDelay:0.1];
        self.HUD=nil;
    }
    if (self.isMovingFromParentViewController)
    {
        [Buddy logout:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
