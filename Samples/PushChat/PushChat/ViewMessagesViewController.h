//
//  ViewMessagesViewController.h
//  PushChat
//
//  Created by Nick Ambrose on 6/2/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewMessagesViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITableView *messagesTable;
@property (nonatomic,weak) IBOutlet UIButton *clearButton;

-(IBAction)doClear:(id)sender;

@end
