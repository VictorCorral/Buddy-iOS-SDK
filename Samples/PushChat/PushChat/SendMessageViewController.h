//
//  SendMessageViewController.h
//  PushChat
//
//  Created by Nick Ambrose on 5/30/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessageViewController : UIViewController

@property (nonatomic,weak) IBOutlet UILabel *channelList;
@property (nonatomic,weak) IBOutlet UITextField *message;
@property (nonatomic,weak) IBOutlet UIButton *sendButton;

-(IBAction)sendMessage:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lists:(NSArray*)sendTo;

@end
