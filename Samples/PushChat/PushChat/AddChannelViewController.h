#import <UIKit/UIKit.h>

@interface AddChannelViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITextField *channelName;
@property (nonatomic,weak) IBOutlet UIButton *addBut;

-(IBAction)addChannel:(id)sender;

@end
