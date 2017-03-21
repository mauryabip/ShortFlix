//
//  SerachCollectionViewController.h
//  ShortFlix
//
//  Created by Appy on 14/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SerachCollectionViewController : UICollectionViewController<UIAlertViewDelegate>{
    NSArray *dataArray;
    NSMutableArray *nameArray;
    NSUInteger index;
   
}
@property (strong, nonatomic) UIAlertView *alertView;

@end
