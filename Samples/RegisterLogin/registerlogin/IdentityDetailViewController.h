//
//  IdentityDetailViewController.h
//  registerlogin
//
//  Created by devmania on 4/10/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface IdentityDetailViewController : UIViewController<MBProgressHUDDelegate>

@property (assign) BOOL  isNew;
@property (weak, nonatomic) NSString *identityProviderString;
@property (weak, nonatomic) NSString *valueString;
@property (weak, nonatomic) IBOutlet UITextField *identityProviderField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;




@end
