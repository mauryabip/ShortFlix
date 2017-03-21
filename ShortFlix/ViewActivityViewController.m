//
//  ViewActivityViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 13/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "ViewActivityViewController.h"
#import "SerachCollectionViewController.h"

@interface ViewActivityViewController ()

@end

@implementation ViewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];

    [self getData];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.itemSize = CGSizeMake((SCREENWIDTH-15)/3.0f, SCREENHEIGHT/4.0f);
    [self.CollectionView setCollectionViewLayout:flowLayout];
    // Register the colleciton cell
    [self.CollectionView registerNib:[UINib nibWithNibName:@"ViewActivityCollCell" bundle:nil] forCellWithReuseIdentifier:@"viewActivityCell"];
      
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search.png"]
                                                                        style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)getData{
    [[ShortFlixInformation sharedInstance]ShowWaiting:HUDLOADING];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    [[ShortFlixNetworkEngine sharedInstance] viewActivityAPI:savedValue callback:^(NSDictionary *responseObject, NSError *error) {
         bannerArray=[responseObject objectForKey:@"Recent 30 Activity"];
        NSString *lblStr=[NSString stringWithFormat:@"%@ %lu %@",LAST,(unsigned long)[bannerArray count],TITLES];
        self.lbl.text=lblStr;
        [self.CollectionView reloadData];
        [[ShortFlixInformation sharedInstance]HideWaiting];
    }];

}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchAction{
    SerachCollectionViewController *searchViewController = [[ShortFlixInformation sharedInstance]Storyboard:SEARCHCOLLSTORYBOARDID];
    [self.navigationController pushViewController:searchViewController animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
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
#pragma mark UICollectiobViewDelegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [bannerArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identifier = @"viewActivityCell";
    ViewActivityCollCell *viewActCell = (ViewActivityCollCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *path=[[bannerArray objectAtIndex:indexPath.row] valueForKey:@"show_banner_horizontal"];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak ViewActivityCollCell *weakCell = viewActCell;
    [viewActCell.imgView setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakCell.imgView.image = image;
                                            
                                        } failure:nil];
    
    return viewActCell;;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![[ShortFlixNetworkEngine sharedInstance] isNetworkRechable]){
        self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:nil cancelButtonTitle:OK otherButtonTitles:nil];
        [self.alertView show];
    }
    else{
        DetailsViewController *detailViewController = [[ShortFlixInformation sharedInstance]Storyboard:DETAILSSTORYBOARDID];
        detailViewController.imgUrlStr=[[bannerArray valueForKey:@"show_banner_horizontal"]objectAtIndex:indexPath.row];
        detailViewController.Show_code=[[bannerArray valueForKey:@"click_show_code"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
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

-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}
@end
