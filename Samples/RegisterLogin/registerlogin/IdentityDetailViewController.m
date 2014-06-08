//
//  IdentityDetailViewController.m
//  registerlogin
//
//  Created by devmania on 4/10/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>

#import <BuddySDK/Buddy.h>
#import <BuddySDK/BuddyCollection.h>

#import "IdentityDetailViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface IdentityDetailViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;

- (BuddyCompletionCallback) addIdentityCallback;
- (BuddyCompletionCallback) removeIdentityCallback;

@end

@implementation IdentityDetailViewController

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
    [self setTitle:@"Identity Details"];
    

    
    if (self.isNew)
    {
        [self.actionBut setTitle:@"Add" forState:UIControlStateNormal];
    }
    else
    {
        [self.actionBut setTitle:@"Delete" forState:UIControlStateNormal];
        self.identityProviderField.text = self.identityProviderString;
        self.valueField.text = self.valueString;
        self.identityProviderField.enabled = NO;
        self.valueField.enabled = NO;
    }
    
}



- (IBAction)doAction:(id)sender {
    if (self.isNew)
    {
        if ([self.identityProviderField.text length]==0)
        {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Notification"
                                       message: @"Please input Identity Provider"
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if ([self.valueField.text length]==0)
        {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Notification"
                                       message: @"Please input Value"
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [[Buddy user] addIdentity:self.identityProviderField.text value:self.valueField.text callback:[self addIdentityCallback]];
    }
    else
    {
        [[Buddy user] removeIdentity:self.identityProviderField.text value:self.valueField.text callback:[self removeIdentityCallback]];
    }
}

- (BuddyCompletionCallback) addIdentityCallback
{
    IdentityDetailViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Add identity - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Adding identity"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Add identity - success Called");
        [self goBack];
        
    };
}

- (BuddyCompletionCallback) removeIdentityCallback
{
    IdentityDetailViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Remove identity - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Removing identity"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Remove identity - success Called");
        [self goBack];
        
    };
}

- (IBAction)doBack:(id)sender {
    [self goBack];
}

-(void) goBack
{
    [[CommonAppDelegate navController] popViewControllerAnimated:YES];
}
@end
