#import "MBProgressHUD.h"

#import <UIKit/UIKit.h>



@interface RegisterViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic,weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic,weak) IBOutlet UITextField *lastNameTextField;
@property (nonatomic,weak) IBOutlet UITextField *userNameTextField;
@property (nonatomic,weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic,weak) IBOutlet UITextField *emailTextField;

@property (nonatomic,weak) IBOutlet UIButton *registerBut;
@property (nonatomic,weak) IBOutlet UIButton *goLoginBut;

-(IBAction) doRegister:(id)sender;
-(IBAction) goLogin:(id)sender;

@end
