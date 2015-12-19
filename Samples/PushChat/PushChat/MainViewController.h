#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MainViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic,weak) IBOutlet UITableView *channelTable;
@property (nonatomic,weak) IBOutlet UITableViewCell *tableCell;

@property (nonatomic,weak) IBOutlet UIButton *addChannelButton;
@property (nonatomic,weak) IBOutlet UIButton *sendMessageButton;
@property (nonatomic,weak) IBOutlet UIButton *viewMessagesButton;

- (void) doLogout;
- (IBAction)addChannel:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (IBAction)boxChecked:(id)sender;
- (IBAction)viewMessages:(id)sender;
@end
