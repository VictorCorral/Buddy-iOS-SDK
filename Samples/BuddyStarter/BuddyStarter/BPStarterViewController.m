#import "BPStarterViewController.h"
#import <BuddySDK/Buddy.h>

@interface BPStarterViewController ()

-(void) greetUser:(BPUser*)user;

@end

@implementation BPStarterViewController

@synthesize message;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.message.text = @"Loading...";
    
}

-(void) greetUser:(BPUser*)user {
    if (user && user.userName) {
        self.message.text = [[NSString alloc] initWithFormat:@"Hello, %@.", user.userName];
    }
    else {
        self.message.text = @"";
    }
}

-(void)refreshUser {
    
    [Buddy GET:@"users/me" parameters:nil class:[BPUser class] callback:^(id u, NSError *error) {
        BPUser *user = u;
        [self greetUser:user];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.message.text = @"Loading...";
    
    BPUser *user = [Buddy user];

    [self greetUser:user];

    if (user != nil) {
        [self refreshUser];
    }
}

- (IBAction)logoutWasClicked:(id)sender {
    self.message.text = @"";

    [Buddy logoutUser:^(NSError *error) {
        
        // Accessing the user will cause the login dialog to pop
        // since there is no current user.
        [Buddy user];
    }];
}
@end
