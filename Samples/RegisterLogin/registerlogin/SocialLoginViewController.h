#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"


@interface SocialLoginViewController : UIViewController <MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITextField *providerTextField;
@property (weak, nonatomic) IBOutlet UITextField *providerIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBut;
@property (weak, nonatomic) IBOutlet UIButton *backBut;
@property (weak, nonatomic) IBOutlet UIButton *registerBut;

- (IBAction)doLogin:(id)sender;
- (IBAction)doBack:(id)sender;
- (IBAction)doRegister:(id)sender;

@end
