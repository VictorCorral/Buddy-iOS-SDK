//
//  UserDetailViewController.m
//  registerlogin
//
//  Created by devmania on 3/28/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import "UserDetailViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface UserDetailViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation UserDetailViewController

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
    
    [self setTitle:@"User Details"];
    
    
    [self populateFields];
}

- (void) populateFields
{
    self.userNameField.text = self.user.userName;
    self.firstNameField.text = self.user.firstName;
    self.lastNameField.text = self.user.lastName;
    self.emailField.text = self.user.email;
    
    if (self.user.dateOfBirth)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        self.birthdayField.text = [formatter stringFromDate:self.user.dateOfBirth];
    }
    else
    {
        self.birthdayField.text = @"Not set";
    }
}




@end
