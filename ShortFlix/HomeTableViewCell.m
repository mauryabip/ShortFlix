//
//  HomeTableViewCell.m
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _collectionView = [[NSBundle mainBundle] loadNibNamed:@"HomeContainerCellView" owner:self options:nil][0];
        _collectionView.frame = self.bounds;
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCollectionData:(NSArray *)collectionData {
    [_collectionView setCollectionData:collectionData];
}

@end
