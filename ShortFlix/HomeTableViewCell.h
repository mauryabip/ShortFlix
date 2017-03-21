//
//  HomeTableViewCell.h
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeContainerCellView.h"

@interface HomeTableViewCell : UITableViewCell
- (void)setCollectionData:(NSArray *)collectionData;
@property (strong, nonatomic) HomeContainerCellView *collectionView;
@end
