//
//  ChangeNameBirthdayVC.h
//  registerlogin
//
//  Created by devmania on 3/27/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ChangeNameBirthdayVC : UIViewController<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPicker;



@end
