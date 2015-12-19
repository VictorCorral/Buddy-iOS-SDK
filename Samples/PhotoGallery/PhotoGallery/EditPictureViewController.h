#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@class BPPicture;

@interface EditPictureViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic,weak) IBOutlet UIImageView *mainImage;
@property (nonatomic,weak) IBOutlet UITextField *commentText;
@property (nonatomic,weak) IBOutlet UITextField *tagText;
@property (nonatomic,weak) IBOutlet UIButton *deleteButton;
@property (nonatomic,weak) IBOutlet UIButton *saveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPicture:(BPPicture*) picture;

-(IBAction)doDelete:(id)sender;
-(IBAction)doSave:(id)sender;


@end
