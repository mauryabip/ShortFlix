//
//  EditProfileViewController.h
//  ShortFlix
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController/SWRevealViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface EditProfileViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UITextField* activeField;


}
- (IBAction)imagePicBtnAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTXT;
@property (weak, nonatomic) IBOutlet UITextField *nwPasswordTXT;
@property (weak, nonatomic) IBOutlet UITextField *retypePasswordTXT;

@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

@property (weak, nonatomic) IBOutlet UIImageView *userProfile;

@end
