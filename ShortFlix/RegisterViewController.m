//
//  RegisterViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SWRevealViewController.h"


@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.usernameTXT.delegate=self;
    self.emailTXT.delegate=self;
    self.passwordTXT.delegate=self;
    self.retypePassTXT.delegate=self;
    self.phoneNoTXT.delegate=self;
    
    // Do any additional setup after loading the view.
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark UITextFieldDelegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if(textField ==self.phoneNoTXT)
//    {
//        NSUInteger newLength = [self.phoneNoTXT.text length] + [string length] - range.length;
//        return newLength <= 10;
//    }
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
    
    activeField = textField;
    
    // [textField setEnablesReturnKeyAutomatically:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}

-(IBAction)termBtnAction:(id)sender{
    TermVC *tVC=[[ShortFlixInformation sharedInstance]Storyboard:TERMSTORYBOARD];
    [self.navigationController pushViewController:tVC animated:YES];
    
}

- (IBAction)agreeBtnAction:(id)sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
        
        if (sender == self.rm2Btn) {
            
            [self.rm2Btn setSelected:NO];
            [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"uncheckd"] forState:UIControlStateNormal];
            
        }
    }
    else{
        [sender setSelected:YES];
        
        if (sender == self.agreeBtn && !([self.usernameTXT.text isEqualToString:@""] && [self.emailTXT.text isEqualToString:@""] && [self.passwordTXT.text isEqualToString:@""]&& [self.retypePassTXT.text isEqualToString:@""] && [self.phoneNoTXT.text isEqualToString:@""])) {
            if ([self.passwordTXT.text isEqualToString:self.retypePassTXT.text]) {
                [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"checkd"] forState:UIControlStateSelected];
            }
            else{
                [[ShortFlixInformation sharedInstance]showAlertWithMessage:PASSWORDDONOTMATCH withTitle:ALERT withCancelTitle:OK];
            }
            
        }
        else{
            [[ShortFlixInformation sharedInstance]showAlertWithMessage:ENTERALLFIELDS withTitle:ALERT withCancelTitle:OK];
        }
    }
    
}



- (IBAction)continueRegisterBtnAction:(id)sender {
    
    if (self.agreeBtn.isSelected) {
        
        NSString *UUID = [[NSUUID UUID] UUIDString];
        [[ShortFlixNetworkEngine sharedInstance] registerAPI:self.emailTXT.text userpassword:self.passwordTXT.text username:self.usernameTXT.text userimei:UUID usermsisdn:self.phoneNoTXT.text callback:^(NSDictionary *responseObject, NSError *error) {
            NSArray *arr=[responseObject objectForKey:@"Status"];
            NSLog(@"%@",arr);
            if ([[arr  valueForKey:@"Message"] isEqual:@"this email already been used"]) {
                [[ShortFlixInformation sharedInstance]showAlertWithMessage:THISEMAILIDALREADYUSED withTitle:ALERT withCancelTitle:OK];
            }
            else{
        
                if (![[ShortFlixNetworkEngine sharedInstance] isNetworkRechable]){
                    self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:nil cancelButtonTitle:OK otherButtonTitles:nil];
                    [self.alertView show];
                }
                else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    
                    // Configure for text only and offset down
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText =@"register success";
                    hud.detailsLabelFont = hud.labelFont;
                    hud.margin = 10.f;
                    hud.yOffset = 0;
                    hud.removeFromSuperViewOnHide = YES;
                    
                    [hud hide:YES afterDelay:1];
                    [NSThread sleepForTimeInterval:2.0];
                    
                  //API FOR LOGIN VALIDATION AND LOGIN  ----> SEND FOR RM
                    
                    [[ShortFlixNetworkEngine sharedInstance] loginAPI:self.emailTXT.text userpassword:self.passwordTXT.text callback:^(NSDictionary *responseobject, NSError *error) {
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
                                 [[ShortFlixInformation sharedInstance]ShowWaiting:HUDLOADING];
                                [[ShortFlixNetworkEngine sharedInstance] loginValidationAPI:self.emailTXT.text usertoken:savedValue1 callback:^(NSDictionary *responseobject, NSError *error) {
                                    NSLog(@"login validation    ........    %@",responseobject);
                                   
                                    
                                    NSString *uslStr=[NSString stringWithFormat:@"%@%@",RENEWLINK,savedValue1];
                                    NSURL *url = [NSURL URLWithString:uslStr];
                                    [[UIApplication sharedApplication] openURL:url];
                                    [[ShortFlixInformation sharedInstance]HideWaiting];
                                    
                                    //HOME PAGE
                                    UIViewController *Roottocontroller;
                                    HomeViewController *homeViewController = [[ShortFlixInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
                                    Roottocontroller=homeViewController;
                                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                                    [navController setViewControllers: @[Roottocontroller] animated:YES];
                                    [self.revealViewController setFrontViewController:navController];
                                    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];

                                    
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
        }];
        }
        else{
            [[ShortFlixInformation sharedInstance]showAlertWithMessage:PLEASESELECTTERMSANDCONDITIONS withTitle:ALERT withCancelTitle:OK];
            }
}

- (IBAction)backToLoginBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

@end
