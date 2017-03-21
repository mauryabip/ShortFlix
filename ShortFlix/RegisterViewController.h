//
//  RegisterViewController.h
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermVC.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    UITextField* activeField;

    NSMutableArray *statusArray;
}


- (IBAction)continueRegisterBtnAction:(id)sender;
- (IBAction)backToLoginBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIAlertView *alertView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTXT;
@property (weak, nonatomic) IBOutlet UITextField *emailTXT;
@property (weak, nonatomic) IBOutlet UITextField *passwordTXT;
@property (weak, nonatomic) IBOutlet UITextField *retypePassTXT;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTXT;


@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

//Plan Buttons outlet and action
@property (weak, nonatomic) IBOutlet UIButton *rm2Btn;

- (IBAction)agreeBtnAction:(id)sender;
- (IBAction)termBtnAction:(id)sender;

@end
