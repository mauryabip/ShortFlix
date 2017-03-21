//
//  SearchViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 13/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SearchViewController.h"
#import "ViewActivityCollCell.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
  // self.dataSource = [[NSArray alloc] init];
   for (int i=1; i<6; i++) {
    for (int i=1; i<6; i++) {
        NSString *str=[NSString stringWithFormat:@"img%d.jpg",i];
        //[imgArr addObject:str];
        self.dataSource = @[str];//[[NSArray alloc] initWithObjects:str, nil];
    }
   }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.itemSize = CGSizeMake((SCREENWIDTH-15)/3.0f, SCREENHEIGHT/4.0f);
    [self.collectionView setCollectionViewLayout:flowLayout];
    // Register the colleciton cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ViewActivityCollCell" bundle:nil] forCellWithReuseIdentifier:@"viewActivityCell"];

    // Do any additional setup after loading the view.
    // datasource used when user search in collectionView
    self.dataSourceForSearchResult = [NSArray new];
    
    // normal datasource
    //self.dataSource =@[@"Modesto",@"Rebecka",@"Andria",@"Sergio",@"Robby",@"Jacob",@"Lavera",@"Theola",@"Adella",@"Garry", @"Lawanda", @"Christiana", @"Billy", @"Claretta", @"Gina", @"Edna", @"Antoinette", @"Shantae", @"Jeniffer", @"Fred", @"Phylis", @"Raymon", @"Brenna", @"Gus", @"Ethan", @"Kimbery", @"Sunday", @"Darrin", @"Ruby", @"Babette", @"Latrisha", @"Dewey", @"Della", @"Dylan", @"Francina", @"Boyd", @"Willette", @"Mitsuko", @"Evan", @"Dagmar", @"Cecille", @"Doug", @"Jackeline", @"Yolanda", @"Patsy", @"Haley", @"Isaura", @"Tommye", @"Katherine", @"Vivian"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareUI];
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



#pragma mark UICollectiobViewDelegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.searchBarActive) {
        return self.dataSourceForSearchResult.count;
    }
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identifier = @"viewActivityCell";
    ViewActivityCollCell *viewActCell = (ViewActivityCollCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    // Configure the cell
    if (self.searchBarActive) {
        viewActCell.imgView.image=[UIImage imageNamed:[self.dataSourceForSearchResult objectAtIndex:indexPath.row]];
       // cell.laName.text = self.dataSourceForSearchResult[indexPath.row];
    }else{
        viewActCell.imgView.image=[UIImage imageNamed:[self.dataSource objectAtIndex:indexPath.row]];
        //cell.laName.text = self.dataSource[indexPath.row];
    }
   
    //viewActCell.imgView.image=[UIImage imageNamed:[self.dataSource objectAtIndex:indexPath.row]];
    
    return viewActCell;;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 10); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate    = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    self.dataSourceForSearchResult  = [self.dataSource filteredArrayUsingPredicate:resultPredicate];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0) {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        [self.collectionView reloadData];
    }else{
        // if text lenght == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
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
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
}
#pragma mark - prepareVC
-(void)prepareUI{
    [self addSearchBar];
    [self addRefreshControl];
}
-(void)addSearchBar{
    if (!self.searchBar) {
        self.searchBarBoundsY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,self.searchBarBoundsY, [UIScreen mainScreen].bounds.size.width, 44)];
        self.searchBar.searchBarStyle       = UISearchBarStyleMinimal;
        self.searchBar.tintColor            = [UIColor whiteColor];
        self.searchBar.barTintColor         = [UIColor whiteColor];
        self.searchBar.delegate             = self;
        self.searchBar.placeholder          = @"search here";
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
        
        // add KVO observer.. so we will be informed when user scroll colllectionView
        [self addObservers];
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
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset" context:Nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UICollectionView *)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self.collectionView ) {
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x,
                                          self.searchBarBoundsY + ((-1* object.contentOffset.y)-self.searchBarBoundsY),
                                          self.searchBar.frame.size.width,
                                          self.searchBar.frame.size.height);
    }
}

@end
