//
//  SocialLoginViewController.m
//  registerlogin
//
//  Created by devmania on 4/4/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import "SocialLoginViewController.h"

#import <QuartzCore/QuartzCore.h>

#import <BuddySDK/Buddy.h>

#import "AppDelegate.h"

#import "Constants.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainViewController.h"

@interface SocialLoginViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;
-(BuddyObjectCallback) getSocialLoginCallback;

@end

@implementation SocialLoginViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BuddyObjectCallback) getSocialLoginCallback
{
    SocialLoginViewController * __weak weakSelf = self;
    
    return ^(id newBuddyObject, NSError *error)
    {
        [weakSelf.HUD hide:YES afterDelay:0.1];
        if(error!=nil)
        {
            NSLog(@"Social Login Callback(error) Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Social Login Error"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Social Login Callback(Good) Called");
        
        [CommonAppDelegate setLoginPresented:FALSE];
        [[[CommonAppDelegate navController] topViewController] dismissViewControllerAnimated:FALSE completion:nil];
    };
}

- (IBAction)doLogin:(id)sender {
    [self resignTextFields];
    
    if( [self.providerTextField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Provider field Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if( [self.providerIdTextField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Provider Id field Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if( [self.tokenTextField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Token field Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    self.HUD.labelText= @"Login";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    [Buddy socialLogin:self.providerTextField.text
            providerId:self.providerIdTextField.text
                 token:self.tokenTextField.text
               success:[self getSocialLoginCallback]];
}

-(void) resignTextFields
{
    [self.providerTextField resignFirstResponder];
    [self.providerIdTextField resignFirstResponder];
    [self.tokenTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textBoxName
{
	[textBoxName resignFirstResponder];
	return YES;
}

- (IBAction)doBack:(id)sender {
    LoginViewController *registerView = [[LoginViewController alloc] initWithNibName:
                                            @"LoginViewController" bundle:nil];
    
    [[[CommonAppDelegate navController] topViewController] dismissViewControllerAnimated:FALSE completion:nil];
    
    [[[CommonAppDelegate navController] topViewController] presentViewController:registerView animated:FALSE completion:nil];
}

- (IBAction)doRegister:(id)sender {
    RegisterViewController *registerView = [[RegisterViewController alloc] initWithNibName:
                                            @"RegisterViewController" bundle:nil];
    
    [[[CommonAppDelegate navController] topViewController] dismissViewControllerAnimated:FALSE completion:nil];
    
    [[[CommonAppDelegate navController] topViewController] presentViewController:registerView animated:FALSE completion:nil];
}
@end
