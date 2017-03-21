//
//  DetailsViewController.h
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ShortFixNetworkEngine/ShortFlixNetworkEngine.h"
#import "KSVideoPlayerView.h"

@import AVFoundation;

@interface DetailsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate,UIScrollViewDelegate,playerViewDelegate,UIAlertViewDelegate>{
    NSMutableArray *episodeListArray;
    NSArray *episodeListDic;
    NSArray *detailDic;
    UIEdgeInsets contentInsets;
    NSString *searchStr;
    int indexVal;
    int width;
    int height;
    NSString *string;
    NSString *msg;
    NSUInteger count;
    NSUInteger numberOfMatches;
    NSArray *arry;
}

@property (strong, nonatomic) UIAlertView *alertView1;


@property (strong, nonatomic)  NSString *episodeshowCodeString;
@property (strong, nonatomic)  NSString *episodeCodeString;

@property (weak, nonatomic)  NSString *imgUrlStr;
@property (weak, nonatomic)  NSString *Show_code;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
- (IBAction)closeMovieAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeMovieBtn;

- (IBAction)shareAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UICollectionView *episodeCollVView;
@property (weak, nonatomic) IBOutlet UILabel *showTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *decLbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl;

// Create a object of MPMoviePlayerViewController
@property (strong, nonatomic) MPMoviePlayerViewController *playerVC;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) KSVideoPlayerView* player;
@property (retain, nonatomic) UIButton *videoType1Button;
@property (retain, nonatomic) UIButton *videoType2Button;
@property (retain, nonatomic) UIButton *videoType3Button;


@property (weak, nonatomic) IBOutlet UIView *movieView;

@property (weak, nonatomic) IBOutlet UIView *episodeView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *episodeCollTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblHt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *epiViewHt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *epiCollHt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)playMovieAction:(id)sender;

@end
