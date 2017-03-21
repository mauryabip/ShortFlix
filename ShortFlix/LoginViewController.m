//
//  LoginViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "SWRevealViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    self.loginDic=[[NSMutableDictionary alloc]init ];
    self.usernameORemailTXT.delegate=self;
    self.passwordTXT.delegate=self;


    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    self.scrollView.contentInset = contentInsets;
    
    self.revealViewController.panGestureRecognizer.enabled=YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextFieldDelegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
   // [textField setEnablesReturnKeyAutomatically:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}

- (IBAction)loginBtnAction:(id)sender {
    if (![[ShortFlixNetworkEngine sharedInstance] isNetworkRechable]){
        self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:nil cancelButtonTitle:OK otherButtonTitles:nil];
        [self.alertView show];
    }
    else{
    
        if (!(self.usernameORemailTXT.hasText && self.passwordTXT.hasText)) {
            [[ShortFlixInformation sharedInstance]showAlertWithMessage:PLEASEENTEREMAILIDANDPASSWORD withTitle:ALERT withCancelTitle:OK];
        }
        else{
        [[ShortFlixInformation sharedInstance]ShowWaiting:HUDLOADING];
            
        [[ShortFlixNetworkEngine sharedInstance] loginAPI:self.usernameORemailTXT.text userpassword:self.passwordTXT.text callback:^(NSDictionary *responseobject, NSError *error) {
                NSArray *arr=[responseobject objectForKey:@"Status"];
            NSLog(@"%@",arr);
            if ([[arr  valueForKey:@"Message"] isEqual:@"login failed"]) {
                [[ShortFlixInformation sharedInstance]showAlertWithMessage:PLEASEENTERCORRECTEMAILIDANDPASSWORD withTitle:ALERT withCancelTitle:OK];
            }
            else{
                NSString *str=[[arr objectAtIndex:0] valueForKey:@"user_status"];
                NSString *str1=[[arr objectAtIndex:0] valueForKey:@"user_token"];
                NSString *str2=[[arr objectAtIndex:0] valueForKey:@"user_name"];
                NSString *str3=[[arr objectAtIndex:0] valueForKey:@"user_email"];
                NSString *str4=[[arr objectAtIndex:0] valueForKey:@"user_package"];
                NSString *str5=[[arr objectAtIndex:0] valueForKey:@"user_expired_date"];
                    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"user_status"];
                    [[NSUserDefaults standardUserDefaults] setObject:str1 forKey:@"user_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:str2 forKey:@"user_name"];
                    [[NSUserDefaults standardUserDefaults] setObject:str3 forKey:@"user_email"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTXT.text forKey:@"user_password"];
                    [[NSUserDefaults standardUserDefaults] setObject:str4 forKey:@"user_package"];
                    [[NSUserDefaults standardUserDefaults] setObject:str5 forKey:@"user_expired_date"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
            if ([str isEqualToString:@"Active"]) {
                NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"user_token"];
                [[ShortFlixNetworkEngine sharedInstance] loginValidationAPI:self.usernameORemailTXT.text usertoken:savedValue1 callback:^(NSDictionary *responseobject, NSError *error) {
                    NSLog(@"login validation    ........    %@",responseobject);
                    
                    UIViewController *Roottocontroller;
                    HomeViewController *homeViewController = [[ShortFlixInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
                    Roottocontroller=homeViewController;
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                    [navController setViewControllers: @[Roottocontroller] animated:YES];
                    [self.revealViewController setFrontViewController:navController];
                    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
                    [[ShortFlixInformation sharedInstance]HideWaiting];

                }];
                
            }
            
            else{
                [[ShortFlixInformation sharedInstance]HideWaiting];
                [[ShortFlixInformation sharedInstance]showAlertWithMessage:PLEASEENTERCORRECTEMAILIDANDPASSWORD withTitle:ALERT withCancelTitle:OK];
                }
            }
             [[ShortFlixInformation sharedInstance]HideWaiting];
        }];
            
        }
    }
}

- (IBAction)registerBtnAction:(id)sender {
    RegisterViewController *regViewController = [[ShortFlixInformation sharedInstance]Storyboard:REGISTERSTORYBOARDID];
    
    [self.navigationController pushViewController:regViewController animated:YES];
}
- (IBAction)forgotPassBtnAction:(id)sender {
    self.forgotPassView.hidden=NO;
}
- (IBAction)cancelBtnAction:(id)sender {
    self.userTxt.text=@"";
    self.forgotPassView.hidden=YES;
}

- (IBAction)resetBtnAction:(id)sender {
    if (self.userTxt.hasText) {
       
        [[ShortFlixNetworkEngine sharedInstance]forgotPassAPI:self.userTxt.text callback:^(NSDictionary *responceObject, NSError *error) {
            NSDictionary *dic=[responceObject objectForKey:@"Status"];
            NSString* msg=[dic valueForKey:@"Message"];
            NSString *result=[dic valueForKey:@"Result"];
            if ([result isEqualToString:@"fail"]) {
                 [[ShortFlixInformation sharedInstance]showAlertWithMessage:msg withTitle:nil withCancelTitle:OK];
            }
            else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabelText = msg;
                hud.detailsLabelFont = hud.labelFont;
                hud.margin = 10.f;
                hud.yOffset = 0;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:3];
                self.userTxt.text=@"";
                [self.userTxt resignFirstResponder];
                self.forgotPassView.hidden=YES;
            }
            
        }];
    }
    else{
        [[ShortFlixInformation sharedInstance]showAlertWithMessage:PLEASEENTERREGISTEREMAILID withTitle:ALERT withCancelTitle:OK];
    }
}
-(void) restrictRotation:(BOOL) restriction{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}
@end
