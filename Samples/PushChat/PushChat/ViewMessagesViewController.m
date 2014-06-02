//
//  ViewMessagesViewController.m
//  PushChat
//
//  Created by Nick Ambrose on 6/2/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewMessagesViewController.h"

#import "Constants.h"
#import "AppDelegate.h"
#import "ReceivedMessage.h"
#import "ReceivedMessageTable.h"
@interface ViewMessagesViewController ()

@end

@implementation ViewMessagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReceivedTableRow";
    
    ReceivedMessage *message = [[CommonAppDelegate receivedMessages] itemAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(nil==cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(message!=nil)
    {
        cell.textLabel.text = message.message;
        cell.detailTextLabel.text = message.channel;
    }
    else
    {
        cell.textLabel.text =@"An Error occurred";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

-(IBAction)doClear:(id)sender
{
    [[CommonAppDelegate receivedMessages] clear];
    [self.messagesTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[CommonAppDelegate navController] setNavigationBarHidden:NO];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[CommonAppDelegate receivedMessages] count];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearButton.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.clearButton.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.clearButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.clearButton.clipsToBounds = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
