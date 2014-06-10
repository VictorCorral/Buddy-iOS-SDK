//
//  BPStarterViewController.h
//
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPStarterViewController : UIViewController
- (IBAction)logoutWasClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end
