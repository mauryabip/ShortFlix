//
//  SerachCollectionViewController.m
//  ShortFlix
//
//  Created by Appy on 14/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SerachCollectionViewController.h"
#import "CollectionViewCell.h"

@interface SerachCollectionViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong) NSArray        *dataSource;
@property (nonatomic,strong) NSArray        *dataSourceForSearchResult;
@property (nonatomic)        BOOL           searchBarActive;
@property (nonatomic)        float          searchBarBoundsY;

@property (nonatomic,strong) UISearchBar        *searchBar;
@property (nonatomic,strong) UIRefreshControl   *refreshControl;
@property (nonatomic,strong) UILabel        *searchLbl;

@end

@implementation SerachCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];

    [self prepareUI];
    self.searchBar.showsCancelButton=true;
    
    UIView *searchLblView=[[UIView alloc]initWithFrame:CGRectMake(0,self.searchBar.frame.size.height+20+self.searchBar.frame.size.height,  SCREENWIDTH, 40)];
    self.searchLbl=[[UILabel alloc]initWithFrame:CGRectMake(10,10,SCREENWIDTH-20, 20)];
    searchLblView.backgroundColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.65f];
    self.searchLbl.text=@"Search result..";
    self.searchLbl.textColor=[UIColor whiteColor];
    self.searchLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    [searchLblView addSubview:self.searchLbl];
    [self.view addSubview:searchLblView];
    
    
     [self getSearchData];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    self.searchBar.showsCancelButton=YES;
        // Do any additional setup after loading the view.
    // datasource used when user search in collectionView
   // self.dataSourceForSearchResult = [NSArray new];
    nameArray=[NSMutableArray new];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
}
-(void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getSearchData{
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_token"];
    //[[ShortFlixInformation sharedInstance]ShowWaiting:HUDLOADING];
    
    [[ShortFlixNetworkEngine sharedInstance] searchAPI:@" " usertoken:savedValue1 callback:^(NSDictionary *responseObject, NSError *error) {
        dataArray=[responseObject objectForKey:@"Result"];
        if ([[dataArray  valueForKey:@"Message"] isEqual:@"Cannot Find the Show"]) {
            [[ShortFlixInformation sharedInstance]showAlertWithMessage:@"Please Login" withTitle:ALERT withCancelTitle:OK];
        }
        else{
            [self.collectionView reloadData];
        }
        //[[ShortFlixInformation sharedInstance]HideWaiting];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

-(void)dealloc{
    // remove Our KVO observer
    [self removeObservers];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - actions
-(void)refreashControlAction{
    [self cancelSearching];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // stop refreshing after 2 seconds
        [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
    });
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.searchBarActive) {
        return self.dataSourceForSearchResult.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (self.searchBarActive) {
        NSString *str1=[self.dataSourceForSearchResult objectAtIndex:indexPath.row];
        NSUInteger indexRow = [[dataArray valueForKey:@"show_title" ] indexOfObject:str1];
        NSDictionary *dataDic = indexRow != NSNotFound ? dataArray[indexRow] : nil;
        NSString  *path=[dataDic valueForKey:@"show_banner_horizontal"];
        NSURL *url = [NSURL URLWithString:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        [cell.imgView setImageWithURLRequest:request
                             placeholderImage:placeholderImage
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          cell.imgView.image = image;
                                          
                                      } failure:nil];
        
    }else{
        //show_banner_horizontal
      //  NSString *path=[[dataArray objectAtIndex:indexPath.row] valueForKey:@"show_banner_horizontal"];
        
//        NSString *name=[[dataArray objectAtIndex:indexPath.row] valueForKey:@"show_title"];
//        [nameArray addObject:name];
//        NSLog(@"%@",[dataArray valueForKey:@"show_title"]);

    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![[ShortFlixNetworkEngine sharedInstance] isNetworkRechable]){
        self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:nil cancelButtonTitle:OK otherButtonTitles:nil];
        [self.alertView show];
    }
    else{
        DetailsViewController *detailViewController = [[ShortFlixInformation sharedInstance]Storyboard:DETAILSSTORYBOARDID];
        NSString *str1=[self.dataSourceForSearchResult objectAtIndex:indexPath.row];
        NSUInteger indexRow = [[dataArray valueForKey:@"show_title" ] indexOfObject:str1];
        NSDictionary *dataDic = indexRow != NSNotFound ? dataArray[indexRow] : nil;
        detailViewController.imgUrlStr=[dataDic valueForKey:@"show_banner_horizontal"];
        detailViewController.Show_code=[dataDic valueForKey:@"show_code"];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark -  <UICollectionViewDelegateFlowLayout>
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(self.searchBar.frame.size.height+40, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDTH-15)/3.0f, 130);
}


#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate    = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    self.dataSourceForSearchResult  = [[dataArray valueForKey:@"show_title"] filteredArrayUsingPredicate:resultPredicate];
    if (!self.dataSourceForSearchResult || !self.dataSourceForSearchResult.count) {
        self.searchLbl.text=@"No result found";
    }
    else
    self.searchLbl.text=[self.dataSourceForSearchResult objectAtIndex:0];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // user did type something, check our datasource for text that looks the same
    self.dataSourceForSearchResult=nil;
    if (searchText.length>0) {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        [self.collectionView reloadData];
      }
    else{
        self.searchBarActive = NO;
        self.searchLbl.text=@"Search result..";
        [self.collectionView reloadData];
        // if text lenght == 0
        // we will consider the searchbar is not active
        
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearching];
    [self.collectionView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    self.searchBarActive = NO;
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching{
    
    self.searchBarActive = NO;
    self.searchLbl.text=@"Search result..";
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];

}
#pragma mark - prepareVC
-(void)prepareUI{
    [self addSearchBar];
   // [self addRefreshControl];
}
-(void)addSearchBar{
    if (!self.searchBar) {
        self.searchBarBoundsY = self.navigationController.navigationBar.frame.size.height+ [UIApplication sharedApplication].statusBarFrame.size.height;
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,self.searchBarBoundsY, [UIScreen mainScreen].bounds.size.width, 44)];
        self.searchBar.searchBarStyle       = UISearchBarStyleProminent;
        self.searchBar.tintColor            = [UIColor whiteColor];
        self.searchBar.barTintColor         = [UIColor colorWithRed:36/255.0f green:36/255.0f blue:36/255.0f alpha:1.0f];

        self.searchBar.delegate             = self;
        self.searchBar.placeholder          = @"Search";
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor darkGrayColor]];
        
        // add KVO observer.. so we will be informed when user scroll colllectionView
       // [self addObservers];
    }
    
    if (![self.searchBar isDescendantOfView:self.view]) {
        [self.view addSubview:self.searchBar];
    }
}

-(void)addRefreshControl{
    if (!self.refreshControl) {
        self.refreshControl                  = [UIRefreshControl new];
        self.refreshControl.tintColor        = [UIColor whiteColor];
        [self.refreshControl addTarget:self
                                action:@selector(refreashControlAction)
                      forControlEvents:UIControlEventValueChanged];
    }
    if (![self.refreshControl isDescendantOfView:self.collectionView]) {
        [self.collectionView addSubview:self.refreshControl];
    }
}
-(void)startRefreshControl{
    if (!self.refreshControl.refreshing) {
        [self.refreshControl beginRefreshing];
    }
}

#pragma mark - observer
- (void)addObservers{
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)removeObservers{
   // [self.collectionView removeObserver:self forKeyPath:@"contentOffset" context:Nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UICollectionView *)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self.collectionView ) {
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x,
                                          self.searchBarBoundsY + ((-1* object.contentOffset.y)-self.searchBarBoundsY),
                                          self.searchBar.frame.size.width,
                                          self.searchBar.frame.size.height);
    }
}

-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}


@end
