//
//  ResetPasswordViewController.m
//  registerlogin
//
//  Created by devmania on 3/22/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <BuddySDK/Buddy.h>

#import "ResetPasswordViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ResetPasswordViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;


- (BOOL) isPasswordValid;

@end

@implementation ResetPasswordViewController

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
    
    [self setTitle:@"Reset Password"];
    

    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doReset:)];
    [[self navigationItem] setRightBarButtonItem:saveButton];
    
        
}



- (void) resignTextFields
{
    [self.passwordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
}

- (BOOL) isPasswordValid
{
    [self resignTextFields];
    
    if( [self.passwordField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Password Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    if( [self.confirmPasswordField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Confirm Password Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text])
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Mismatch field"
                                   message: @"Password field doesn't match"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    return YES;
}



- (IBAction)doReset:(id)sender
{
    if (![self isPasswordValid])
    {
        return;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Reseting";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    NSString *oldPassword = [CommonAppDelegate fetchPassword];
    NSString *newPassword = self.passwordField.text;
    [Buddy.user resetPassword:oldPassword newPassword:newPassword callback:[self getPasswordResetCallback]];
    
}

-(BuddyCompletionCallback) getPasswordResetCallback
{
    ResetPasswordViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Reset password - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Reseting password"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Reset password - success Called");
       [[self navigationController ] popViewControllerAnimated:YES];
        
    };
}

- (IBAction)doRequestSent:(id)sender
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Reseting";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    
    [[Buddy user] requestPasswordResetWithSubject:@"Your new password"
                                             body:@"Here is your reset code: @ResetCode"
                                         callback:[self getPasswordResetRequestCallback]];
}

-(BuddyObjectCallback) getPasswordResetRequestCallback
{
    ResetPasswordViewController * __weak weakSelf = self;
    
    return ^(id newBuddyObject, NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Reset password request - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Reset password request"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Reset password request - success Called");
        [[self navigationController] popViewControllerAnimated:YES];
        
    };
}



@end
