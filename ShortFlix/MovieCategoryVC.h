//
//  MovieCategoryVC.h
//  ShortFlix
//
//  Created by Virinchi Software on 15/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewActivityCollCell.h"
#import "SWRevealViewController/SWRevealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"



@interface MovieCategoryVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SWRevealViewControllerDelegate>{
    NSArray *showArr;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (nonatomic, strong) NSString *categoryName;
@end
