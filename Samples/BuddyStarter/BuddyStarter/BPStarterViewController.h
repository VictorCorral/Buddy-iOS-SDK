//
//  BPStarterViewController.h
//  BuddyStafrter
//
//  Created by Shawn Burke on 6/8/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPStarterViewController : UIViewController
- (IBAction)logoutWasClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end
