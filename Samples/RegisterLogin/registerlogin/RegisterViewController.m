//
//  RegisterViewController.m
//  registerlogin
//
//  Created by Nick Ambrose on 1/14/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"


#import <BuddySDK/Buddy.h>
#import <BuddySDK/BPUser.h>

#import "Constants.h"

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"


@interface RegisterViewController ()
@property (nonatomic,strong) MBProgressHUD *HUD;
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Register"];
        
}


-(BuddyObjectCallback) getLoginCallback
{
    RegisterViewController * __weak weakSelf = self;
    
    return ^(id newBuddyObject, NSError *error)
    {
        [weakSelf.HUD hide:YES afterDelay:0.1];
        
        if(error!=nil)
        {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Login Error"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        // Save username and password for next time
        [CommonAppDelegate storeUsername:weakSelf.userNameTextField.text
                           andPassword:weakSelf.passwordTextField.text];
        [CommonAppDelegate setLoginPresented:FALSE];
        [[[CommonAppDelegate navController] topViewController] dismissViewControllerAnimated:FALSE completion:nil];
    };
}

-(IBAction) doRegister:(id)sender
{
    
    
    [self resignTextFields];
    
    if( [self.userNameTextField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                            message: @"Username Cannot be empty"
                            delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if( [self.emailTextField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Email Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if( [self.passwordTextField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Password Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if( [self.firstNameTextField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"First Name Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if( [self.lastNameTextField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Last Name Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @" Registering";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    BPUser *user = [BPUser new];
    user.firstName = self.firstNameTextField.text;
    user.lastName = self.lastNameTextField.text;
    user.gender = BPUserGender_Unknown;
    user.dateOfBirth= nil;
    user.email = self.emailTextField.text;
    user.userName = self.userNameTextField.text;

    __weak RegisterViewController *weakSelf = self;

    [Buddy createUser:user
          password:self.passwordTextField.text
          callback:^(NSError *error) {
              [Buddy login:weakSelf.userNameTextField.text
                      password:weakSelf.passwordTextField.text
                      callback:[weakSelf getLoginCallback]];
              
          }];
}

-(IBAction) goLogin:(id)sender
{
    
    LoginViewController *registerView = [[LoginViewController alloc] initWithNibName:
                                            @"LoginViewController" bundle:nil];
    
    [[[CommonAppDelegate navController] topViewController] dismissViewControllerAnimated:FALSE completion:nil];
    
    [[[CommonAppDelegate navController] topViewController] presentViewController:registerView animated:FALSE completion:nil];
    
}

-(void) resignTextFields
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textBoxName {
	[textBoxName resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
