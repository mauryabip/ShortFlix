
#import "RearViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "ShortFlixNetworkEngine.h"

@interface RearViewController()

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [ShortFlixInformation sharedInstance].string=@"";
    [self getData];
    
    //array
    lblArr=[[NSArray alloc]initWithObjects:HOME, nil];
    lblArr3=[[NSArray alloc]initWithObjects:@"",MYPROFILE,COOKIES,CALLCENTER, nil];
    lblArr31=[[NSArray alloc]initWithObjects:@"",COOKIES,CALLCENTER, nil];
    lblArr4=[[NSArray alloc]initWithObjects:SIGNOUT, nil];
    lblArr5=[[NSArray alloc]initWithObjects:LOGIN, nil];
    
    _rearTableView.backgroundColor=[UIColor colorWithRed:45/255.0f green:45/255.0f blue:45/255.0f alpha:1.0f];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [self.rearTableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
   // [[UIApplication sharedApplication] setStatusBarHidden:NO];

}
-(void)getData{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    [[ShortFlixNetworkEngine sharedInstance] mobileCatAPI:savedValue callback:^(NSDictionary *responceObject, NSError *error) {
         lblArr2=[responceObject objectForKey:@"Category"];
        
         [self.rearTableView reloadData];
    }];
}
#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if(section==1){
        return [lblArr2 count];
    }
    else if(section==2){
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"user_status"];
        
        if ([savedValue isEqualToString:@"Active"]){
            return [lblArr3 count];
        }
        else
        return [lblArr31 count];
    }
    else{
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"user_status"];
        
        if ([savedValue isEqualToString:@"Active"]){
            return [lblArr4 count];
        }
        else
            return [lblArr5 count];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor=[UIColor whiteColor];
    
    //section
    if (indexPath.section==0) {
        colorChangedStr=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.row,(long)indexPath.section];
        if ([colorChangedStr isEqualToString:[ShortFlixInformation sharedInstance].string]) {
            
            cell.backgroundColor = [UIColor colorWithRed:136/255.0f green:35/255.0f blue:35/255.0f alpha:1.0f];
        }
        else{
            
            cell.backgroundColor = [UIColor clearColor];
        }
        if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Chinese"]) {
            cell.textLabel.text=[ShortFlixInformation sharedInstance].home;
        }
        else if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Malay"]){
            cell.textLabel.text=[ShortFlixInformation sharedInstance].home;
        }
        else
            cell.textLabel.text = [lblArr objectAtIndex:indexPath.row];
    }
    else if (indexPath.section==1){
        colorChangedStr=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.row,(long)indexPath.section];
        if ([colorChangedStr isEqualToString:[ShortFlixInformation sharedInstance].string]) {
            
            cell.backgroundColor = [UIColor colorWithRed:136/255.0f green:35/255.0f blue:35/255.0f alpha:1.0f];
        }
        else{
            
            cell.backgroundColor = [UIColor clearColor];
        }
        if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Chinese"]) {
             cell.textLabel.text = [[lblArr2 objectAtIndex:indexPath.row]valueForKey:@"category_name_CN"];
        }
        else if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Malay"]){
             cell.textLabel.text = [[lblArr2 objectAtIndex:indexPath.row]valueForKey:@"category_name_BM"];
        }
        else
        cell.textLabel.text = [[lblArr2 objectAtIndex:indexPath.row]valueForKey:@"category_name"];
        
        //[ShortFlixInformation sharedInstance].language
    }
    
    else if (indexPath.section==2){
        colorChangedStr=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.row,(long)indexPath.section];
        if ([colorChangedStr isEqualToString:[ShortFlixInformation sharedInstance].string] && ![[ShortFlixInformation sharedInstance].string isEqualToString:@"02"] ) {
            
            cell.backgroundColor = [UIColor colorWithRed:136/255.0f green:35/255.0f blue:35/255.0f alpha:1.0f];
        }
        else{
            
            cell.backgroundColor = [UIColor clearColor];
        }

       
        if (indexPath.row==0) {
            if (!lblArr2 || !lblArr2.count){
                
            }
            else{
                UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 14, self.rearTableView.frame.size.width, 2)];
                vv.backgroundColor=[UIColor blackColor];
                [cell addSubview:vv];
            }
           
        }
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"user_status"];
        
        if ([savedValue isEqualToString:@"Active"]){
            if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Chinese"]) {
                if (indexPath.row==1) {
                     cell.textLabel.text=[ShortFlixInformation sharedInstance].myprofile;
                }
                else if (indexPath.row==2){
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].privacy;

                }
                else if (indexPath.row==3){
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].callcenter;
                }
            }
            else if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Malay"]){
                if (indexPath.row==1) {
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].myprofile;
                }
                else if (indexPath.row==2){
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].privacy;
                    
                }
                else if (indexPath.row==3){
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].callcenter;
                }
            }
            else
                cell.textLabel.text = [lblArr3 objectAtIndex:indexPath.row];
        }
        else{
            if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Chinese"]) {
                if (indexPath.row==1) {
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].privacy;
                }
                else if (indexPath.row==1){
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].callcenter;
                }
               
            }
            else if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Malay"]){
                if (indexPath.row==1) {
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].privacy;
                }
                else if (indexPath.row==2){
                    cell.textLabel.text=[ShortFlixInformation sharedInstance].callcenter;
                }
 
            }
            else
                cell.textLabel.text = [lblArr31 objectAtIndex:indexPath.row];
        }
        
        
      }
    
    else{
        colorChangedStr=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.row,(long)indexPath.section];
        if ([colorChangedStr isEqualToString:[ShortFlixInformation sharedInstance].string]) {
            
            cell.backgroundColor = [UIColor colorWithRed:136/255.0f green:35/255.0f blue:35/255.0f alpha:1.0f];
        }
        else{
            
            cell.backgroundColor = [UIColor clearColor];
        }

        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"user_status"];
        
        if ([savedValue isEqualToString:@"Active"]){
            if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Chinese"]) {
                cell.textLabel.text=[ShortFlixInformation sharedInstance].signOut;
            }
            else if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Malay"]){
                cell.textLabel.text=[ShortFlixInformation sharedInstance].signOut;
            }
            else
            cell.textLabel.text = [lblArr4 objectAtIndex:indexPath.row];
        }
        else{
            if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Chinese"]) {
                cell.textLabel.text=[ShortFlixInformation sharedInstance].logIn;
            }
            else if ([[ShortFlixInformation sharedInstance].language isEqualToString:@"Malay"]){
                cell.textLabel.text=[ShortFlixInformation sharedInstance].logIn;
            }
            else
            cell.textLabel.text = [lblArr5 objectAtIndex:indexPath.row];
            
        }
    }

    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 68, tableView.frame.size.width, 2)];
        view1.backgroundColor=[UIColor blackColor];
        [view setBackgroundColor:[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65, 25, tableView.frame.size.width, 20)];
        [label setFont:[UIFont systemFontOfSize:15]];
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)] ;
        imgView.layer.cornerRadius = imgView.frame.size.width / 2;
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *imgName = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_image"];
        if ([imgName length]==0) {
             imgView.image=[UIImage imageNamed:@"user"];
        }else
        imgView.image=[UIImage imageNamed:imgName];
       
        label.textColor=[UIColor whiteColor];
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"user_status"];
        if ([savedValue isEqualToString:@"Active"]) {
            
            label.text=[[NSUserDefaults standardUserDefaults]
                        stringForKey:@"user_name"];
        }
        else{
            label.text=MYPROFILE;
        }
        
        [view addSubview:label];
        [view addSubview:imgView];
        [view addSubview:view1];
        
        return view;

    }
    return nil;

}
- (void) gestureHandler:(UIGestureRecognizer *)gestureRecognizer{
        UIViewController *Roottocontroller;
    
        ProfileViewController *profileVC = [[ShortFlixInformation sharedInstance]Storyboard:PROFILESTORYBOARDID];
        Roottocontroller=profileVC;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
        [navController setViewControllers: @[Roottocontroller] animated: YES];
    
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (indexPath.section==2){
        if (indexPath.row==0) {
                return 30;
        }
         else
             return 45;
     }
     else
        return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 70;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
   
    
    [ShortFlixInformation sharedInstance].string=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.row,(long)indexPath.section];
    if ([[ShortFlixInformation sharedInstance].string isEqualToString:@"02"]) {
        cell.backgroundColor = [UIColor clearColor];
    }
    else
        cell.backgroundColor = [UIColor colorWithRed:136/255.0f green:35/255.0f blue:35/255.0f alpha:1.0f];

    UIViewController *Roottocontroller;
    
    if (indexPath.section==0) {
                HomeViewController *homeViewController = [[ShortFlixInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
                Roottocontroller=homeViewController;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];

        
    }
    else if (indexPath.section==1){
            
                MovieCategoryVC *mVC = [[ShortFlixInformation sharedInstance]Storyboard:MOVIECATEGORYSTORYBOARDID];
                mVC.categoryName=[[lblArr2 objectAtIndex:indexPath.row]valueForKey:@"category_name"];
                Roottocontroller=mVC;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
    }
    else if (indexPath.section==2){
        if (indexPath.row==0) {
            cell.backgroundColor = [UIColor clearColor];
        }
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"user_status"];
        if ([savedValue isEqualToString:@"Active"]) {
            if (indexPath.row==[lblArr3 count]-1) {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TELEPHONE]];
                }
           else if (indexPath.row==[lblArr3 count]-2) {
                UIViewController *Roottocontroller;
                CookiesVC *cVC = [[ShortFlixInformation sharedInstance]Storyboard:COOKIESSTORYBOARDID];
                Roottocontroller=cVC;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
                }
            else if (indexPath.row==[lblArr3 count]-3){
                NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"user_status"];
                if ([savedValue isEqualToString:@"Active"]) {
                    
                ProfileViewController *profileVC = [[ShortFlixInformation sharedInstance]Storyboard:PROFILESTORYBOARDID];
                Roottocontroller=profileVC;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
                }
            }
        }
        else{
            if (indexPath.row==[lblArr31 count]-1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TELEPHONE]];
                }
                else if (indexPath.row==[lblArr31 count]-2) {
                UIViewController *Roottocontroller;
                CookiesVC *cVC = [[ShortFlixInformation sharedInstance]Storyboard:COOKIESSTORYBOARDID];
                Roottocontroller=cVC;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
                }
            
            }
        
        }

    else {
            NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"user_status"];
            NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"user_email"];
            if ([savedValue isEqualToString:@"Active"]){
                [[ShortFlixNetworkEngine sharedInstance] logoutAPI:savedValue1 callback:^(NSDictionary *VehicleDetail, NSError *error) {
               
                    NSString *str=@"";
                    NSString *savedValue2 = [[NSUserDefaults standardUserDefaults]
                                             stringForKey:@"user_token"];
                    NSString *savedValue3 = DUMMY;
                    savedValue2=savedValue3;
                    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"user_image"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"No Package" forKey:@"user_package"];
                    [[NSUserDefaults standardUserDefaults] setObject:savedValue2 forKey:@"user_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:str] forKey:@"user_status"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                     UIViewController *Roottocontroller;
                    LoginViewController *loginViewController = [[ShortFlixInformation sharedInstance]Storyboard:LOGINSTORYBOARDID];
                    Roottocontroller=loginViewController;
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                    [navController setViewControllers: @[Roottocontroller] animated: YES];
                    
                    [self.revealViewController setFrontViewController:navController];
                    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                    }];
                }
            else{
                LoginViewController *loginViewController = [[ShortFlixInformation sharedInstance]Storyboard:LOGINSTORYBOARDID];
                Roottocontroller=loginViewController;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                }
        }
    [self.rearTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
}



@end