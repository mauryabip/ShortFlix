//
//  LoginViewController.h
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    UITextField* activeField;
 
}
- (IBAction)loginBtnAction:(id)sender;
- (IBAction)registerBtnAction:(id)sender;

@property (strong, nonatomic) UIAlertView *alertView;
@property (weak, nonatomic) IBOutlet UITextField *userTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *loginDic;
@property (weak, nonatomic) IBOutlet UITextField *usernameORemailTXT;
@property (weak, nonatomic) IBOutlet UITextField *passwordTXT;
- (IBAction)forgotPassBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *forgotPassView;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)resetBtnAction:(id)sender;

@end
