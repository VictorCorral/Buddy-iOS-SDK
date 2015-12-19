#import <UIKit/UIKit.h>

@interface ViewMessagesViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITableView *messagesTable;
@property (nonatomic,weak) IBOutlet UIButton *clearButton;

-(IBAction)doClear:(id)sender;

@end
