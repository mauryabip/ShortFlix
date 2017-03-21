//
//  ProfileViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "ProfileViewController.h"
#import "ViewActivityViewController.h"
#import "SerachCollectionViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];

    langArr=[[NSArray alloc]initWithObjects:ENGLISH,CHINESE,MALAY, nil];
    //self.title = NSLocalizedString(@"MY PROFILE", nil);
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search.png"]
//                                                                        style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
//    
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self restrictRotation:YES];
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_name"];
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_package"];
    
    NSString *savedValue2 = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_expired_date"];
    if ([savedValue1 isEqualToString:@"No Package"]) {
        self.renewNoPackBtn.hidden=NO;
        self.faltuLbl.hidden=NO;
        self.renewBtn.hidden=YES;
        self.userNameLbl.hidden=YES;
        self.planLbl.hidden=YES;
        self.expirydatelbl.hidden=YES;
        self.expiryLbl.hidden=YES;
    }
    else{
        self.expirydatelbl.hidden=NO;
        self.renewNoPackBtn.hidden=YES;
        self.faltuLbl.hidden=YES;
        self.renewBtn.hidden=NO;
        self.userNameLbl.hidden=NO;
        self.planLbl.hidden=NO;
        self.expiryLbl.hidden=NO;
        self.userNameLbl.text=savedValue;
        self.planLbl.text=savedValue1;
        self.expiryLbl.text=savedValue2;
    }
    
    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2.0f;
    self.imageProfile.clipsToBounds = YES;
    self.imageProfile.contentMode = UIViewContentModeScaleAspectFill;

    
    NSString *imgName = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"user_image"];
    if ([imgName length]==0) {
        self.imageProfile.image=[UIImage imageNamed:@"user"];
    }
    else
        self.imageProfile.image=[UIImage imageNamed:imgName];
    
    self.revealViewController.panGestureRecognizer.enabled=YES;

}
-(void)searchAction{
    SerachCollectionViewController *searchViewController = [[ShortFlixInformation sharedInstance]Storyboard:SEARCHCOLLSTORYBOARDID];
    [self.navigationController pushViewController:searchViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [langArr count];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
   
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    label.text=[langArr objectAtIndex:indexPath.row];
        if ([[ShortFlixInformation sharedInstance].language isEqualToString:CHINESE]) {
            if (indexPath.row==1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
           
        }
        else if ([[ShortFlixInformation sharedInstance].language isEqualToString:MALAY]){
            if (indexPath.row==2) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
             cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else{
            if (indexPath.row==0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
                cell.accessoryType = UITableViewCellAccessoryNone;

            
        }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.hidden=YES;
    self.langBtn.selected=NO;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSString *langName = [langArr objectAtIndex:indexPath.row];
    [ShortFlixInformation sharedInstance].language=langName;
   
    if (indexPath.row==1) {
         [ShortFlixInformation sharedInstance].home=@"家";
        [ShortFlixInformation sharedInstance].signOut=@"退出";
        [ShortFlixInformation sharedInstance].logIn=@"登录";
        [ShortFlixInformation sharedInstance].myprofile=@"我的简历";
        [ShortFlixInformation sharedInstance].privacy=@"隐私/饼干";
        [ShortFlixInformation sharedInstance].callcenter=@"呼叫帮助中心";
    }
    else if (indexPath.row==2){
         [ShortFlixInformation sharedInstance].home=@"Laman";
        [ShortFlixInformation sharedInstance].signOut=@"log keluar";
        [ShortFlixInformation sharedInstance].logIn=@"log masuk";
        [ShortFlixInformation sharedInstance].myprofile=@"profil saya";
        [ShortFlixInformation sharedInstance].privacy=@"privasi / cookies";
        [ShortFlixInformation sharedInstance].callcenter=@"panggilan pusat bantuan";
    }
    
    
    self.lastViewTop.constant=2;
    [self.view layoutIfNeeded];
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}


- (IBAction)editProfileBtnAction:(id)sender {
    EditProfileViewController *editVC = [[ShortFlixInformation sharedInstance]Storyboard:EDITPROFILESTORYBOARDID];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (IBAction)renewBtnAction:(id)sender {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    NSString *uslStr=[NSString stringWithFormat:@"%@%@",RENEWLINK,savedValue];
    NSURL *url = [NSURL URLWithString:uslStr];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)langBtnAction:(id)sender {
    if (self.langBtn.selected) {
        self.tableView.hidden=YES;
        self.lastViewTop.constant=2;
        self.langBtn.selected=NO;
    }
    else{
        self.tableView.hidden=NO;
        self.lastViewTop.constant=self.tableView.frame.size.height;
        self.langBtn.selected=YES;
    }
     [self.view layoutIfNeeded];
   
}

- (IBAction)viewActBtnAction:(id)sender {
    
    ViewActivityViewController *viewVC = [[ShortFlixInformation sharedInstance]Storyboard:VIEWACTIVITYSTORYBOARDID];
    [self.navigationController pushViewController:viewVC animated:YES];
}
-(void) restrictRotation:(BOOL) restriction{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

- (IBAction)reloadButtonPushed:(id)sender{
    NSString *email = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_email"];
    NSString *password = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_password"];
     [[ShortFlixInformation sharedInstance]ShowWaiting:HUDLOADING];
    [[ShortFlixNetworkEngine sharedInstance] loginAPI:email userpassword:password callback:^(NSDictionary *responseobject, NSError *error) {
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
            [[NSUserDefaults standardUserDefaults] setObject:str4 forKey:@"user_package"];
            [[NSUserDefaults standardUserDefaults] setObject:str5 forKey:@"user_expired_date"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if ([str isEqualToString:@"Active"]) {
                NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"user_token"];
               
                [[ShortFlixNetworkEngine sharedInstance] loginValidationAPI:email usertoken:savedValue1 callback:^(NSDictionary *responseobject, NSError *error) {
                    NSLog(@"login validation    ........    %@",responseobject);
                    [self viewWillAppear:YES];
                    
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
@end
