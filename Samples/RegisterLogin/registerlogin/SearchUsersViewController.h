//
//  SearchUsersViewController.h
//  registerlogin
//
//  Created by devmania on 3/28/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SearchUsersViewController : UIViewController<MBProgressHUDDelegate>

@property (nonatomic,strong) NSMutableArray *allUsersList;
@property (nonatomic,strong) NSMutableArray *filteredUserList;

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBut;
@property (weak, nonatomic) IBOutlet UIButton *backBut;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)doSearch:(id)sender;


@end
