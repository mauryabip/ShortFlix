//
//  HomeViewController.h
//  ShortFlix
//
//  Created by Virinchi Software on 10/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SerachCollectionViewController.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate>{
    //NSArray *arr;
    NSInteger start;
    NSIndexPath *myIP;
   // NSArray *menuArray;
     NSArray *menu1Array;
    NSMutableArray *bannerArray;
    int sectionNo;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) UIAlertView *alertView1;
@property (strong, nonatomic) NSArray *sampleData;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *dataArray1;
@property (strong, nonatomic) NSMutableArray *dataArray2;
@property (strong, nonatomic) NSMutableArray *dataArray3;

@property (weak, nonatomic) IBOutlet UICollectionView *imgScrollCollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

