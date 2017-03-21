//
//  ViewActivityViewController.h
//  ShortFlix
//
//  Created by Virinchi Software on 13/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewActivityCollCell.h"
#import "AppDelegate.h"

@interface ViewActivityViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>{
    NSArray *bannerArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (strong, nonatomic) UIAlertView *alertView;

@end
