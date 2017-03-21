//
//  HomeViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 10/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "HomeTableViewCell.h"
#import "DetailsViewController.h"
#import "ShortFlixNetworkEngine.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];
    self.menuArray=[[NSMutableArray alloc]init];

    [self getData];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];

    [NSTimer scheduledTimerWithTimeInterval: 3.0 target: self
                                   selector: @selector(callAftertenySecond:) userInfo: nil repeats: YES];
    start=0;
    
    _imgScrollCollView.pagingEnabled = YES;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.imgScrollCollView setCollectionViewLayout:flowLayout];
    
    // Register the table cell
    [self.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"HomeTableViewCell"];
    
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search.png"]
                                                                        style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)searchAction:(UIButton *)sender{
    SerachCollectionViewController *searchViewController = [[ShortFlixInformation sharedInstance]Storyboard:SEARCHCOLLSTORYBOARDID];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self restrictRotation:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.imgScrollCollView.frame.size.width;
    float currentPage = self.imgScrollCollView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        self.pageControl.currentPage = currentPage + 1;
    }
    else
    {
        self.pageControl.currentPage = currentPage;
    }
    start=self.pageControl.currentPage;
}
-(void) callAftertenySecond:(NSTimer*)time{
    
    if (start<[bannerArray count]) {
        myIP=[NSIndexPath indexPathForRow:start inSection:0];
        self.pageControl.currentPage=start;
        start=start+1;
    }
    else
        start=0;
    
    [self.imgScrollCollView scrollToItemAtIndexPath:myIP
                                   atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                           animated:YES];
}

- (void)didReceiveMemoryWarning{
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
    
- (void)dealloc{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return [self.menuArray count];
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
}
    
    // Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        HomeTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
        
        NSArray *articleData = self.dataArray;
        if (indexPath.section==0) {
            [cell setCollectionData:articleData];
        }
        else if (indexPath.section==1){
            [cell setCollectionData:self.dataArray1];
        }
        else if (indexPath.section==2){
            [cell setCollectionData:self.dataArray2];
        }
        else{
            [cell setCollectionData:self.dataArray3];
        }
        
        cell.backgroundColor=[UIColor colorWithRed:66/255.0f green:66/255.0f blue:66/255.0f alpha:1.0f];
        
        return cell;
}
    
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
        // Return NO if you do not want the specified item to be editable.
        return NO;
    }
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        
        // This code is commented out in order to allow users to click on the collection view cells.
        //    if (!self.detailViewController) {
        //        self.detailViewController = [[ORGDetailViewController alloc] initWithNibName:@"ORGDetailViewController" bundle:nil];
        //    }
        //    NSDate *object = _objects[indexPath.row];
        //    self.detailViewController.detailItem = object;
        //    [self.navigationController pushViewController:self.detailViewController animated:YES];
}
    
#pragma mark UITableViewDelegate methods
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:  (NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)] ;
     headerView.backgroundColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, self.tableView.bounds.size.width, 20)] ;
    lbl.textColor=[UIColor whiteColor];
    lbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
    if (!self.menuArray || !self.menuArray.count){
        
    }else{
        
     lbl.text   =[[self.menuArray objectAtIndex:section] objectForKey:@"special_name"];
    }
    [headerView addSubview:lbl];
    return headerView;
}

    - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
    {
        return 30.0;
    }
    
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        return 135.0;
    }
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark - NSNotification to select table cell
- (void) didSelectItemFromCollectionView:(NSNotification *)notification{
        NSDictionary *cellData = [notification object];
    if (cellData)
        {
            if (![[ShortFlixNetworkEngine sharedInstance] isNetworkRechable]){
                self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:nil cancelButtonTitle:OK otherButtonTitles:nil];
                [self.alertView show];
            }
            else{
            DetailsViewController *detailViewController = [[ShortFlixInformation sharedInstance]Storyboard:DETAILSSTORYBOARDID];
            detailViewController.imgUrlStr=[cellData objectForKey:@"show_banner_horizontal"];
            detailViewController.Show_code=[cellData objectForKey:@"show_code"];
            [self.navigationController pushViewController:detailViewController animated:YES];
            }
        }
}

#pragma mark UICollectiobViewDelegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [bannerArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"flickerCell";
    UICollectionViewCell *flickerCell = (UICollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    flickerCell.backgroundColor = [UIColor whiteColor];
    UIImageView *imgflikerView = (UIImageView *)[flickerCell viewWithTag:100];
    
    NSString *path=[[bannerArray objectAtIndex:indexPath.row] valueForKey:@"banner_url"];
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    [imgflikerView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       imgflikerView.image = image;
                                  } failure:nil];
    imgflikerView.contentMode = UIViewContentModeScaleAspectFill;
    imgflikerView.clipsToBounds = YES;
    int pages =floor(self.imgScrollCollView.contentSize.width/self.imgScrollCollView.frame.size.width);
    [self.pageControl setNumberOfPages:pages];
    
    
    return flickerCell;;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![[ShortFlixNetworkEngine sharedInstance] isNetworkRechable])
    {
        self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:nil cancelButtonTitle:OK otherButtonTitles:nil];
        [self.alertView show];
    }
    else
    {
        DetailsViewController *detailViewController = [[ShortFlixInformation sharedInstance]Storyboard:DETAILSSTORYBOARDID];
        detailViewController.imgUrlStr=[[bannerArray valueForKey:@"banner_url"]objectAtIndex:indexPath.row];
        detailViewController.Show_code=[[bannerArray valueForKey:@"banner_show_code"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    CGFloat itemht = CGRectGetHeight(self.imgScrollCollView.frame);
    return CGSizeMake(screenWidth, itemht-44);
    
}


-(void)getData{
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    [[ShortFlixInformation sharedInstance]ShowWaiting:HUDLOADING];
    if (savedValue==nil) {
        savedValue=DUMMY;
    }
    [[ShortFlixNetworkEngine sharedInstance] bannerAPI:savedValue callback:^(NSDictionary *responseObject, NSError *error) {
       
         NSString *failStr=[[responseObject objectForKey:@"Status"]valueForKey:@"Result"];
        
        if ([failStr isEqualToString:@"fail"]) {
             [[ShortFlixInformation sharedInstance]HideWaiting];
             NSString *msgString=[[responseObject objectForKey:@"Status"]valueForKey:@"Message"];
            self.alertView1 = [[UIAlertView alloc] initWithTitle:nil message:msgString delegate:self cancelButtonTitle:OK otherButtonTitles:nil];
            [self.alertView1 show];
        }
        else{
            bannerArray=[responseObject objectForKey:@"Banner"];
            [self.imgScrollCollView reloadData];
            [self getTableSectionData];
        }
        
    }];
    
    
}
-(void)getTableSectionData{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    if (savedValue==nil) {
        savedValue=DUMMY;
    }
    
    
    [[ShortFlixNetworkEngine sharedInstance] specicalCatNameAPI:savedValue callback:^(NSDictionary *responseObject, NSError *error) {
            self.menuArray = [(NSDictionary *)responseObject objectForKey:@"Special Main Menu Category"];
        
            [self.tableView reloadData];
            
            NSString *name=[[self.menuArray objectAtIndex:0] objectForKey:@"special_name"];
            [[ShortFlixNetworkEngine sharedInstance]specicalCatAPI:name usertoken:savedValue callback:^(NSDictionary *responseObject, NSError *error) {
                self.dataArray=[(NSDictionary *)responseObject objectForKey:@"Home Show List"];
                [self.tableView reloadData];
            }];
            NSString *name1=[[self.menuArray objectAtIndex:1] objectForKey:@"special_name"];
            [[ShortFlixNetworkEngine sharedInstance]specicalCatAPI:name1 usertoken:savedValue callback:^(NSDictionary *responseObject, NSError *error) {
                self.dataArray1=[(NSDictionary *)responseObject objectForKey:@"Home Show List"];
                [self.tableView reloadData];
            }];
            NSString *name2=[[self.menuArray objectAtIndex:2] objectForKey:@"special_name"];
            [[ShortFlixNetworkEngine sharedInstance]specicalCatAPI:name2 usertoken:savedValue callback:^(NSDictionary *responseObject, NSError *error) {
                self.dataArray2=[(NSDictionary *)responseObject objectForKey:@"Home Show List"];
                [self.tableView reloadData];
            }];
            NSString *name3=[[self.menuArray objectAtIndex:3] objectForKey:@"special_name"];
            [[ShortFlixNetworkEngine sharedInstance]specicalCatAPI:name3 usertoken:savedValue callback:^(NSDictionary *responseObject, NSError *error) {
                self.dataArray3=[(NSDictionary *)responseObject objectForKey:@"Home Show List"];
                [self.tableView reloadData];
                
            }];
        
       [[ShortFlixInformation sharedInstance]HideWaiting];
        
    }];
    
    
}
-(void) restrictRotation:(BOOL) restriction{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==self.alertView1) {
        if (buttonIndex == 0)  // 0 == the cancel button
        {
           
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
            
        }

    }
}


@end
