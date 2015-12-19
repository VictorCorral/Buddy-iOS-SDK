#import <UIKit/UIKit.h>

@interface BPStarterViewController : UIViewController
- (IBAction)logoutWasClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end
