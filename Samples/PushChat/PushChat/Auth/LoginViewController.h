//
//  LoginViewController.h
//  PushChat
//
//  Created by Nick Ambrose on 5/30/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"


@interface LoginViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField *userNameTextField;
@property (nonatomic,weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic,weak) IBOutlet UIButton *loginBut;
@property (nonatomic,weak) IBOutlet UIButton *goRegisterBut;

@end
