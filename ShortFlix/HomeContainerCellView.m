//
//  HomeContainerCellView.m
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "HomeContainerCellView.h"
#import "HomeCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeContainerCellView () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;
@end
@implementation HomeContainerCellView

- (void)awakeFromNib {
     
     self.collectionView.backgroundColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
     
     UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
     flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
     flowLayout.itemSize = CGSizeMake(130.0, 130.0);
     [self.collectionView setCollectionViewLayout:flowLayout];
     
     // Register the colleciton cell
     [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCellID"];
     
}



#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData {
    _collectionData = collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCellID" forIndexPath:indexPath];
   // NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
   // cell.articleTitle.text = [cellData objectForKey:@"title"];//show_banner_horizontal
    NSString *path=[[self.collectionData objectAtIndex:indexPath.row] valueForKey:@"show_banner_horizontal"];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    //__weak UICollectionViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request
                   placeholderImage:placeholderImage
                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                
                                cell.imageView.image = image;
                                [cell setNeedsLayout];
                                
                            } failure:nil];
//
//    NSURL *url = [NSURL URLWithString:path];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *img = [[UIImage alloc] initWithData:data];
//    cell.imageView.image=img;//[UIImage imageNamed:[cellData objectForKey:@"title"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"%ld",(long)indexPath.row);
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
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
    
    CGFloat itemht = CGRectGetHeight(self.collectionView.frame);
    return CGSizeMake(screenWidth/3.0f, itemht);
    
}

@end
