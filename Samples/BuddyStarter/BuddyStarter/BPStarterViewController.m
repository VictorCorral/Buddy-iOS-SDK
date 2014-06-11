//
//  BPStarterViewController.m
//
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import "BPStarterViewController.h"
#import "BuddySDK/Buddy.h"

@interface BPStarterViewController ()


@end

@implementation BPStarterViewController
@synthesize message;
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.message.text = @"Loading...";
    
}

-(void)checkUser {
    
    [[Buddy users] getUser:@"me" callback:^(id u, NSError *error) {
        BPUser* user = u;
        if (user && user.userName) {
            self.message.text = [[NSString alloc] initWithFormat:@"Hello, %@.", user.userName];
        }
       
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    
    message.text = @"Loading...";
    
    // load the current user's information
    //
    if ([Buddy user] != nil) {
        [[Buddy user] refresh:^(NSError *error) {
            self.message.text = [[NSString alloc] initWithFormat:@"Hello, %@.", [[Buddy user] userName]];
        }];
    }
    else {
        [self checkUser];
    }
    
}



- (IBAction)logoutWasClicked:(id)sender {
    __weak BPStarterViewController *weakSelf = self;

    self.message.text = @"";

    [Buddy logout:^(NSError *error) {
        
        // calling check user will cause the login dialog to pop
        // when user auth fails.
        [weakSelf checkUser];
    }];
}
@end
