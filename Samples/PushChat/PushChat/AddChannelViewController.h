//
//  AddChannelViewController.h
//  PushChat
//
//  Created by Nick Ambrose on 5/30/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddChannelViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITextField *channelName;
@property (nonatomic,weak) IBOutlet UIButton *addBut;

-(IBAction)addChannel:(id)sender;

@end
