//
//  ProfileViewController.h
//  ShortFlix
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "EditProfileViewController.h"
#import "RenewViewController.h"

@interface ProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *langArr;
}
@property (weak, nonatomic) IBOutlet UIButton *langBtn;
- (IBAction)editProfileBtnAction:(id)sender;
- (IBAction)renewBtnAction:(id)sender;
- (IBAction)langBtnAction:(id)sender;
- (IBAction)viewActBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastViewTop;
@property (weak, nonatomic) IBOutlet UILabel *planLbl;
@property (weak, nonatomic) IBOutlet UILabel *expiryLbl;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *renewBtn;
@property (weak, nonatomic) IBOutlet UIButton *renewNoPackBtn;
@property (weak, nonatomic) IBOutlet UILabel *expirydatelbl;
@property (weak, nonatomic) IBOutlet UILabel *faltuLbl;

@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;

@end
