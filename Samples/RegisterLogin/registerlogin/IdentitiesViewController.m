//
//  IdentitiesViewController.m
//  registerlogin
//
//  Created by devmania on 4/9/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>

#import <BuddySDK/Buddy.h>
#import <BuddySDK/BuddyCollection.h>

#import "IdentitiesViewController.h"
#import "IdentityDetailViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface IdentitiesViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;

-(BuddyCollectionCallback) getIdentitiesCallback;

@end

@implementation IdentitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _identityList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Manage Identities"];
    
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAddIdentity:)];
    [[self navigationItem] setRightBarButtonItem:saveButton];
    

  }

- (void)viewWillAppear:(BOOL)animated
{
    [self doSearch:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.identityList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    BPIdentityValue *aValue = [self.identityList objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text =
    [NSString stringWithFormat:@"%@  = %@",
     aValue.identityProviderName, aValue.identityProviderID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BPIdentityValue *aValue = [self.identityList objectAtIndex:indexPath.row];
    
    IdentityDetailViewController *subVC = [[IdentityDetailViewController alloc]
                                           initWithNibName:@"IdentityDetailViewController" bundle:nil];
    subVC.identityProviderString = aValue.identityProviderName;
    subVC.valueString = aValue.identityProviderID;
    subVC.isNew = NO;
    [ [CommonAppDelegate navController] pushViewController:subVC animated:YES];
}



- (IBAction)doSearch:(id)sender {
    if ([self.searchField.text length]==0)
    {
        [self.identityList removeAllObjects];
        [self.tableView reloadData];
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Searching...";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    [[Buddy user] getIdentities:self.searchField.text callback:[self getIdentitiesCallback]];
}

-(BuddyCollectionCallback) getIdentitiesCallback
{
    IdentitiesViewController * __weak weakSelf = self;
    
    return ^(NSArray *buddyObjects, NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD = nil;
        
        if(error!=nil)
        {
            NSLog(@"getIdentitiesCallback - error: %@", [error description]);
            return;
        }
        
        NSLog(@"getIdentitiesCallback - success Called");
        
        [self.identityList removeAllObjects];
        self.identityList = [buddyObjects mutableCopy];
        [self.tableView reloadData];
    };
}


- (IBAction)doAddIdentity:(id)sender {
    IdentityDetailViewController *subVC = [[IdentityDetailViewController alloc]
                                       initWithNibName:@"IdentityDetailViewController" bundle:nil];
    
    subVC.isNew = YES;
    [ [CommonAppDelegate navController] pushViewController:subVC animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
