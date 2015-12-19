#import <UIKit/UIKit.h>

@class BPUserList;

@interface ChannelViewController : UIViewController

@property (nonatomic,weak) IBOutlet UILabel *channelName;
@property (nonatomic,weak) IBOutlet UIButton *joinBut;
@property (nonatomic,weak) IBOutlet UIButton *leaveBut;
@property (nonatomic,weak) IBOutlet UIButton *deleteBut;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil channel:(BPUserList*)channel;

-(IBAction)join:(id)sender;
-(IBAction)leave:(id)sender;
-(IBAction)deleteList:(id)sender;
@end
