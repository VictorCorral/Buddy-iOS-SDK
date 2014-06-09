//
//  IdentitiesViewController.h
//  registerlogin
//
//  Created by devmania on 4/9/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface IdentitiesViewController : UIViewController<MBProgressHUDDelegate, UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *identityList;

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBut;
@property (weak, nonatomic) IBOutlet UIButton *backBut;
@property (weak, nonatomic) IBOutlet UIButton *addIdentityBut;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)doSearch:(id)sender;



@end
