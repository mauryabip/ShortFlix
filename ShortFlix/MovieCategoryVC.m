//
//  MovieCategoryVC.m
//  ShortFlix
//
//  Created by Virinchi Software on 15/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "MovieCategoryVC.h"
#import "ShortFixNetworkEngine/ShortFlixNetworkEngine.h"

@interface MovieCategoryVC ()

@end

@implementation MovieCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];

    [self getData];
    self.lbl.text=self.categoryName;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.itemSize = CGSizeMake((SCREENWIDTH-15)/3.0f, self.collectionView.frame.size.height/3.0f);
    [self.collectionView setCollectionViewLayout:flowLayout];
    // Register the colleciton cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ViewActivityCollCell" bundle:nil] forCellWithReuseIdentifier:@"viewActivityCell"];
    
    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}
-(void)getData{
    [[ShortFlixInformation sharedInstance]ShowWaiting:HUDLOADING];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    [[ShortFlixNetworkEngine sharedInstance] mobileCatShowAPI:_categoryName user_token:savedValue callback:^(NSDictionary *responceObject, NSError *error) {
        showArr=[responceObject objectForKey:@"Showlist"];
        
        [self.collectionView  reloadData];
        [[ShortFlixInformation sharedInstance]HideWaiting];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectiobViewDelegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [showArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identifier = @"viewActivityCell";
    ViewActivityCollCell *viewActCell = (ViewActivityCollCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
   // viewActCell.imgView.image=[UIImage imageNamed:@"img1.jpg"];
    NSString *path=[[showArr objectAtIndex:indexPath.row] valueForKey:@"show_banner_horizontal"];
    
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

    DetailsViewController *detailViewController = [[ShortFlixInformation sharedInstance]Storyboard:DETAILSSTORYBOARDID];
    detailViewController.imgUrlStr=[[showArr valueForKey:@"show_banner_horizontal"]objectAtIndex:indexPath.row];
    detailViewController.Show_code=[[showArr valueForKey:@"show_code"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 5); // top, left, bottom, right
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
