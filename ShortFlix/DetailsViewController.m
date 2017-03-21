//
//  DetailsViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 11/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "DetailsViewController.h"
#import "EpisodeButtonCollCell.h"
#import "SerachCollectionViewController.h"



@implementation DetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self restrictRotation:YES];
    indexVal=0;
    count=0;
    string=@"";
    self.movieView.hidden=YES;
    self.episodeView.hidden=YES;
    self.movieBtnTop.constant=500;
    [self getData];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    
    // Register the colleciton cell
    [self.episodeCollVView registerNib:[UINib nibWithNibName:@"EpisodeButtonCollCell" bundle:nil] forCellWithReuseIdentifier:@"episodeCollCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.itemSize = CGSizeMake(80.0, 70.0);
    [self.episodeCollVView setCollectionViewLayout:flowLayout];
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search.png"]
                                                                        style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    NSURL *url = [NSURL URLWithString:_imgUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self.imgView setImageWithURLRequest:request
                        placeholderImage:placeholderImage
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                     self.imgView.image = image;
                                     
                                 } failure:nil];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self restrictRotation:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    NSString *notificationName = @"TestNotification";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useNotificationWithString:) name:notificationName object:nil];
    NSString *notificationName1 = @"touch";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchNotificationWithString:) name:notificationName1 object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getData{
    
    [[ShortFlixInformation sharedInstance]ShowWaiting:HUDLOADING];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_token"];
    [[ShortFlixNetworkEngine sharedInstance] episodeListAPI:_Show_code usertoken:savedValue callback:^(NSDictionary *responseCode, NSError *error) {
        NSString *failStr=[[responseCode objectForKey:@"Status"]valueForKey:@"Result"];
        
        if ([failStr isEqualToString:@"fail"]) {
            [[ShortFlixInformation sharedInstance]HideWaiting];
            NSString *msgString=[[responseCode objectForKey:@"Status"]valueForKey:@"Message"];
            self.alertView1 = [[UIAlertView alloc] initWithTitle:nil message:msgString delegate:self cancelButtonTitle:OK otherButtonTitles:nil];
            [self.alertView1 show];
        }
        else{
            
            episodeListDic=[responseCode objectForKey:@"Episode List"];
            // [self.episodeCollVView reloadData];
            [self episodeDetails];
        }
        
    }];
}
-(void)episodeDetails{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    [[ShortFlixNetworkEngine sharedInstance]showDetailAPI:savedValue show_code:_Show_code callback:^(NSDictionary *responceObject, NSError *error) {
        detailDic=[responceObject objectForKey:@"Show Detail"];
        
        NSString *str=[NSString stringWithFormat:@"%@ %@",[[detailDic objectAtIndex:0] valueForKey:@"show_view_unique"],VIEWS];
        self.showTitleLbl.text=[[detailDic objectAtIndex:0] valueForKey:@"show_title"];
        self.lbl.text=str;
        self.decLbl.numberOfLines = 0;
        self.decLbl.text=[[detailDic objectAtIndex:0] valueForKey:@"show_description"];
        [self.decLbl sizeToFit];
        self.lblHt.constant=self.decLbl.frame.size.height;
        self.episodeCollTop.constant=5;
        self.movieBtnTop.constant=5;
        float roundedup = ceil([episodeListDic count]/4.0f);
        self.epiCollHt.constant=roundedup*70;
        self.epiViewHt.constant=30+self.epiCollHt.constant;
        if ([[[detailDic valueForKey:@"show_type"]objectAtIndex:0] isEqualToString:@"Drama"]) {
            self.episodeView.hidden=NO;
            self.movieView.hidden=YES;
             contentInsets = UIEdgeInsetsMake(0.0, 0.0, (200+self.epiViewHt.constant+self.lblHt.constant)-480,0.0);
             self.scrollView.contentInset = contentInsets;
        }
        else{
            self.movieView.hidden=NO;
            self.episodeView.hidden=YES;
             contentInsets = UIEdgeInsetsMake(0.0, 0.0, (410+self.lblHt.constant)-480,0.0);
             self.scrollView.contentInset = contentInsets;
        }
        [self.view layoutIfNeeded];
        [self getHistory];
        
    
      
    }];
}
-(void)getHistory{
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    
    [[ShortFlixNetworkEngine sharedInstance]episodeClickedAPI:savedValue show_code:_Show_code callback:^(NSDictionary *responceObject, NSError *error) {
        NSArray *dic=[responceObject objectForKey:@"Episode Click History"];
        
        //Episode Click History
        NSString *str=@"";
        searchStr=@"";
        for (int i=0; i<[dic count]; i++) {
            str=[[dic valueForKey:@"click_episode_code"]objectAtIndex:i];
            searchStr=[searchStr stringByAppendingString:[NSString stringWithFormat:@"%@ ",str]];
        }
        [self.episodeCollVView reloadData];
        [[ShortFlixInformation sharedInstance]HideWaiting];
      
    }];

}
-(void)searchAction{
    SerachCollectionViewController *searchViewController = [[ShortFlixInformation sharedInstance]Storyboard:SEARCHCOLLSTORYBOARDID];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectiobViewDelegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [episodeListDic count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identifier = @"episodeCollCell";
    EpisodeButtonCollCell *episodeCell = (EpisodeButtonCollCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    episodeCell.labelCount.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_package"];
    NSString *type=[[detailDic valueForKey:@"show_type"]objectAtIndex:0];
    //type = Free;
    NSString *videoType=[[episodeListDic valueForKey:@"type"]objectAtIndex:indexPath.row];
    
    if ([videoType isEqualToString:@"Free"]) {
        if ([type isEqualToString:@"Drama"]) {
            NSString *episode_code=[NSString stringWithFormat:@"%@ ",[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexPath.row]];
            if ([searchStr rangeOfString:episode_code].location == NSNotFound) {
                episodeCell.imgView.image=[UIImage imageNamed:@"key-bttn.png"];
            } else {
                episodeCell.imgView.image=[UIImage imageNamed:@"key-bttn-un.png"];
            }

        }
        else{
            self.episodeView.hidden=YES;
            self.movieView.hidden=NO;
        }
    }
    else{
        if ([type isEqualToString:@"Drama"]) {
            if ([savedValue1 isEqualToString:@"No Package"] || [savedValue1 length]==0){
                if (indexPath.row==0) {
                    
                    episodeCell.imgView.image=[UIImage imageNamed:@"key-bttn.png"];
                }
                else
                    episodeCell.imgView.image=[UIImage imageNamed:@"key-bttn-un.png"];
            }
            else{
                
                NSString *episode_code=[NSString stringWithFormat:@"%@ ",[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexPath.row]];
                if ([searchStr rangeOfString:episode_code].location == NSNotFound) {
                    episodeCell.imgView.image=[UIImage imageNamed:@"key-bttn.png"];
                } else {
                    episodeCell.imgView.image=[UIImage imageNamed:@"key-bttn-un.png"];
                }
            }
        }
        else{
            if ([savedValue1 isEqualToString:@"Premium"]){
                
                self.episodeView.hidden=YES;
                self.movieView.hidden=NO;
            }
            else{
                self.episodeView.hidden=YES;
                self.movieView.hidden=YES;
            }
        }
    }
    
    
    return episodeCell;;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self restrictRotation:NO];
    indexVal=(int)indexPath.row;
    NSString *strUrl=[[episodeListDic valueForKey:@"episode_url_m3u8"]objectAtIndex:indexVal];
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_package"];
    NSString *type=[[detailDic valueForKey:@"show_type"]objectAtIndex:0];
    NSString *videoType=[[episodeListDic valueForKey:@"type"]objectAtIndex:indexPath.row];
    
    if ([videoType isEqualToString:@"Free"]) {
        if ([type isEqualToString:@"Drama"]){
            
            ////////////************ normal and premium *************////////////
            if ([strUrl length]==0) {
                msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:OK, nil];
                [alert show];
                
            }
            else{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
                self.episodeshowCodeString=[[episodeListDic valueForKey:@"show_code"]objectAtIndex:indexPath.row];
                self.episodeCodeString=[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexPath.row];
                
                //log API calling
                [self logAPI];
                
                [self.navigationController setNavigationBarHidden:YES];
                self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
                [self.view addSubview:self.player];
                self.player.tintColor = [UIColor redColor];
                
                [self.player.nextButton addTarget:self action:@selector(startNextPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self.player.backButton addTarget:self action:@selector(startBackPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                // if ([savedValue1 isEqualToString:@"Premium"]) {
                [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
                //            }else{
                //                [self.player.videoTypeButton addTarget:self action:@selector(videoTypeNormalPressed:) forControlEvents:UIControlEventTouchUpInside];
                //            }
                
                [self.player play];
            }
            
            
        }
    }
    
    else{
        
        if ([type isEqualToString:@"Drama"]) {
            if ([savedValue1 isEqualToString:@"No Package"]|| [savedValue1 length]==0) {
                if (indexPath.row==0) {
                    [[UIApplication sharedApplication] setStatusBarHidden:YES];
                    [self.navigationController setNavigationBarHidden:YES];
                    NSString *str1Url=[[episodeListDic valueForKey:@"episode_url_m3u8"]objectAtIndex:indexPath.row];
                    self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:str1Url]];
                    [self.view addSubview:self.player];
                    [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    self.player.tintColor = [UIColor redColor];
                    [self.player play];
                    
                }
                
                else{
                    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                            stringForKey:@"user_status"];//message = "Please Login";
                    msg=@"";
                    if (![savedValue isEqualToString:@"Active"]) {
                        msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
                    }
                    else{
                        msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
                    }
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                                    message:msg
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:OK, nil];
                    [alert show];
                    
                }
                
            }
            else {
                
                ////////////************ normal and premium *************////////////
                if ([strUrl length]==0) {
                    msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                                    message:msg
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:OK, nil];
                    [alert show];
                    
                }
                else{
                    [[UIApplication sharedApplication] setStatusBarHidden:YES];
                    self.episodeshowCodeString=[[episodeListDic valueForKey:@"show_code"]objectAtIndex:indexPath.row];
                    self.episodeCodeString=[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexPath.row];
                    
                    //log API calling
                    [self logAPI];
                    
                    [self.navigationController setNavigationBarHidden:YES];
                    self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
                    [self.view addSubview:self.player];
                    self.player.tintColor = [UIColor redColor];
                    
                    [self.player.nextButton addTarget:self action:@selector(startNextPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.player.backButton addTarget:self action:@selector(startBackPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    // if ([savedValue1 isEqualToString:@"Premium"]) {
                    [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
                    //            }else{
                    //                [self.player.videoTypeButton addTarget:self action:@selector(videoTypeNormalPressed:) forControlEvents:UIControlEventTouchUpInside];
                    //            }
                    
                    [self.player play];
                }
                
                
            }
        }
        else{
            if ([savedValue1 isEqualToString:@"Premium"]) {
                
                //            self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
                //            [self.view addSubview:self.player];
                //            self.player.tintColor = [UIColor redColor];
                //            [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                //            [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
                //            [self.player play];
            }
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
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

- (void)touchNotificationWithString:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    NSString *str=[info valueForKey:@"touchmsg"];
    if ([str isEqualToString:@"hide"]) {
        [self hide];
        self.player.videoTypeButton.selected=NO;
    }
    else{
       // [self hide];
    }
}
-(void)logAPI{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    [[ShortFlixNetworkEngine sharedInstance]viewLogAPI:savedValue episode_code:self.episodeCodeString show_code:self.episodeshowCodeString callback:^(NSDictionary *responceObject, NSError *error) {
        arry=[responceObject objectForKey:@"5 Second Checker"];
    }];
}
- (void)useNotificationWithString:(NSNotification*) notification
{
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSString *str=[info valueForKey:@"timer"];
    string = [string stringByAppendingString:str];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"00:05" options:NSRegularExpressionCaseInsensitive error:&error];
      numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    if ([[info valueForKey:@"timer"]isEqualToString:@"00:05"]) {
        
        if (numberOfMatches==1+count) {
             NSLog(@"Found %lu",(unsigned long)numberOfMatches);
            NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"user_token"];
          
                NSString *str=[[arry valueForKey:@"log_episode_id"]objectAtIndex:0];
                [[ShortFlixNetworkEngine sharedInstance]mobileAfter5SecAPI:savedValue log_episode_id:str callback:^(NSDictionary *responceObject, NSError *error) {
                    [self getHistory];
                    // [self.episodeCollVView reloadData];
                    
                }];
        }
    }
    
   else if ([[info valueForKey:@"timer"] isEqualToString:[info valueForKey:@"totaltimer"]]) {
       indexVal=indexVal+1;
       count=numberOfMatches;
       if (indexVal>=[episodeListDic count]) {
           [self getHistory];
           [self restrictRotation:YES];
           [self.navigationController setNavigationBarHidden:NO];
           [[UIApplication sharedApplication] setStatusBarHidden:NO];
           [self.player pause];
           [self.player removeFromSuperview];
           self.player = nil;
           [self devicePortrait];
       }
       else{
           [self getHistory];
           NSString *type=[[detailDic valueForKey:@"show_type"]objectAtIndex:0];
           NSString *strUrl;
           if ([type isEqualToString:@"Drama"]) {
                strUrl=[[episodeListDic valueForKey:@"episode_url_m3u8"]objectAtIndex:indexVal];
           }
          
           if ([strUrl length]==0) {
               [self restrictRotation:YES];
               [self.navigationController setNavigationBarHidden:NO];
               [[UIApplication sharedApplication] setStatusBarHidden:NO];
               [self.player pause];
               [self.player removeFromSuperview];
               self.player = nil;
               [self devicePortrait];
               msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
               UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                               message:msg
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:OK, nil];
               [alert show];
           }
           else{
               [self.player pause];
               [self.player removeFromSuperview];
               self.player = nil;
               self.episodeshowCodeString=[[episodeListDic valueForKey:@"show_code"]objectAtIndex:indexVal];
               self.episodeCodeString=[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexVal];
               
               //log API calling
               [self logAPI];

               
               self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
               [self.view addSubview:self.player];
               self.player.tintColor = [UIColor redColor];
               [self.player.nextButton addTarget:self action:@selector(startNextPressed:) forControlEvents:UIControlEventTouchUpInside];
               [self.player.backButton addTarget:self action:@selector(startBackPressed:) forControlEvents:UIControlEventTouchUpInside];
               [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
               [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
               [self.player play];
           }
           
       }
        
    }
    
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight ) {
            self.player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        }
        else if (toInterfaceOrientation== UIInterfaceOrientationUnknown){
              self.player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        }
//        if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
//            self.player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//        }
        else {
            self.player.frame = CGRectMake(0, 0, height, width);
        }
    } completion:^(BOOL finished) {//toInterfaceOrientation	UIInterfaceOrientation	UIInterfaceOrientationUnknown
        
    }];
}
-(void)doneButtonAction:(UIButton*)sender
{
    [self getHistory];
    count=numberOfMatches;
    [self restrictRotation:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.player pause];
    [self.player removeFromSuperview];
    self.player = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self devicePortrait];
    
}
-(void)startBackPressed:(UIButton*)sender{
   
    indexVal=indexVal-1;
    count= numberOfMatches;
    if (indexVal==-1) {
        [self restrictRotation:YES];
        [self.navigationController setNavigationBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.player pause];
        [self.player removeFromSuperview];
        self.player = nil;
        [self devicePortrait];
    }
    else{
        NSString *strUrl=[[episodeListDic valueForKey:@"episode_url_m3u8"]objectAtIndex:indexVal];
        if ([strUrl length]==0) {
            [self restrictRotation:YES];
            [self.navigationController setNavigationBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self.player pause];
            [self.player removeFromSuperview];
            self.player = nil;
            [self devicePortrait];
            
        }
        else{
            [self.player pause];
            [self.player removeFromSuperview];
            self.player = nil;
            self.episodeshowCodeString=[[episodeListDic valueForKey:@"show_code"]objectAtIndex:indexVal];
            self.episodeCodeString=[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexVal];
            
            //log API calling
            [self logAPI];
            
            self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
            [self.view addSubview:self.player];
            self.player.tintColor = [UIColor redColor];
            [self.player.nextButton addTarget:self action:@selector(startNextPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.player.backButton addTarget:self action:@selector(startBackPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.player play];
        }
        
    }

    
}
-(void)startNextPressed:(UIButton*)sender
{

    indexVal=indexVal+1;
   count= numberOfMatches;
    if (indexVal==[episodeListDic count]) {
        [self getHistory];
        [self restrictRotation:YES];
        [self.navigationController setNavigationBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.player pause];
        [self.player removeFromSuperview];
        self.player = nil;
        [self devicePortrait];
    }
    else{
        [self getHistory];
        NSString *strUrl=[[episodeListDic valueForKey:@"episode_url_m3u8"]objectAtIndex:indexVal];
        if ([strUrl length]==0) {
            [self restrictRotation:YES];
            [self.navigationController setNavigationBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self.player pause];
            [self.player removeFromSuperview];
            self.player = nil;
            [self devicePortrait];
            msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:OK, nil];
            [alert show];

        }
        else{
            [self.player pause];
            [self.player removeFromSuperview];
            self.player = nil;
            self.episodeshowCodeString=[[episodeListDic valueForKey:@"show_code"]objectAtIndex:indexVal];
            self.episodeCodeString=[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexVal];
            
            //log API calling
            [self logAPI];
            
            self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
            [self.view addSubview:self.player];
            self.player.tintColor = [UIColor redColor];
            [self.player.nextButton addTarget:self action:@selector(startNextPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.player.backButton addTarget:self action:@selector(startBackPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.player play];
        }
        
    }
    
}
-(void)videoTypePressed:(UIButton*)sender{
   
    
    if ([self.player.touchMsg isEqualToString:@"hide"]) {
        //[self hide];
        
    }
    if (!self.player.videoTypeButton.selected) {
         [self show];

        UIImage *imagVideo = [UIImage imageNamed:@"sd"];
        self.videoType1Button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.videoType1Button.tintColor=[UIColor clearColor];
        self.videoType1Button.frame = CGRectMake(self.player.videoTypeButton.frame.origin.x-42,self.view.frame.size.height-60,35,19);
        [self.videoType1Button addTarget:self action:@selector(playSD:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoType1Button setBackgroundImage:imagVideo forState:UIControlStateNormal];
        [self.player addSubview:self.videoType1Button];
        
        UIImage *imagVideo1 = [UIImage imageNamed:@"auto"];
        self.videoType2Button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.videoType2Button.tintColor=[UIColor clearColor];
        self.videoType2Button.frame = CGRectMake(self.player.videoTypeButton.frame.origin.x-85,self.view.frame.size.height-60,35,19);
        [self.videoType2Button addTarget:self action:@selector(playAuto:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoType2Button setBackgroundImage:imagVideo1 forState:UIControlStateNormal];
        [self.player addSubview:self.videoType2Button];
        
        UIImage *imagVideo2 = [UIImage imageNamed:@"hd"];
        self.videoType3Button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.videoType3Button.tintColor=[UIColor clearColor];
        self.videoType3Button.frame = CGRectMake(self.player.videoTypeButton.frame.origin.x,self.view.frame.size.height-60,35,19);
        [self.videoType3Button addTarget:self action:@selector(playHD:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoType3Button setBackgroundImage:imagVideo2 forState:UIControlStateNormal];
         NSString *strUrl=[[episodeListDic valueForKey:@"episode_url_hd"]objectAtIndex:indexVal];
        if ([strUrl length]==0) {
            
        }
        else
        [self.player addSubview:self.videoType3Button];
        
        self.player.videoTypeButton.selected=YES;
       [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(targetMethod:)
                                       userInfo:nil
                                        repeats:NO];
       // [tm fire];
    }
    else{
        [self hide];
//        [self.videoType1Button removeFromSuperview];
//        [self.videoType2Button removeFromSuperview];
//        [self.videoType3Button removeFromSuperview];

         self.player.videoTypeButton.selected=NO;
    }
}

-(void)playAuto:(UIButton*)sender{
    
    [self.player pause];
    [self.player removeFromSuperview];
    self.player = nil;
    //[self devicePortrait];
    
    NSString *strUrl=[[episodeListDic valueForKey:@"episode_url_m3u8"]objectAtIndex:indexVal];
    if ([strUrl length]==0) {
        msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:OK, nil];
        [alert show];
        
    }
    else{
    self.episodeshowCodeString=[[episodeListDic valueForKey:@"show_code"]objectAtIndex:indexVal];
    self.episodeCodeString=[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexVal];
    [self.player pause];
    self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
    [self.view addSubview:self.player];
    self.player.tintColor = [UIColor redColor];
    [self.player.nextButton addTarget:self action:@selector(startNextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.player.backButton addTarget:self action:@selector(startBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.player play];
    [self.player.videoTypeButton setBackgroundImage:[UIImage imageNamed:@"auto-24"] forState:UIControlStateNormal];
    }
    
}
-(void)playSD:(UIButton*)sender{
    [self.player pause];
    [self.player removeFromSuperview];
    self.player = nil;
    //[self devicePortrait];
    
    NSString *strUrl=[[episodeListDic valueForKey:@"episode_url_sd"]objectAtIndex:indexVal];
    if ([strUrl length]==0) {
        msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:OK, nil];
        [alert show];
        
    }
    else{
    self.episodeshowCodeString=[[episodeListDic valueForKey:@"show_code"]objectAtIndex:indexVal];
    self.episodeCodeString=[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexVal];
    [self.player pause];
    self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
    [self.view addSubview:self.player];
    self.player.tintColor = [UIColor redColor];
    [self.player.nextButton addTarget:self action:@selector(startNextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.player.backButton addTarget:self action:@selector(startBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.player play];
    [self.player.videoTypeButton setBackgroundImage:[UIImage imageNamed:@"sd-icon-24"] forState:UIControlStateNormal];
    }
    
}
-(void)playHD:(UIButton*)sender{
    
    [self.player pause];
    [self.player removeFromSuperview];
    self.player = nil;
   // [self devicePortrait];
   
    NSString *strUrl=[[episodeListDic valueForKey:@"episode_url_hd"]objectAtIndex:indexVal];
    if ([strUrl length]==0) {
//        msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
//                                                        message:msg
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel"
//                                              otherButtonTitles:OK, nil];
//        [alert show];

    }
    else{
        self.episodeshowCodeString=[[episodeListDic valueForKey:@"show_code"]objectAtIndex:indexVal];
        self.episodeCodeString=[[episodeListDic valueForKey:@"episode_code"]objectAtIndex:indexVal];
        [self.player pause];
        self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
        [self.view addSubview:self.player];
        self.player.tintColor = [UIColor redColor];
        [self.player.nextButton addTarget:self action:@selector(startNextPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.player.backButton addTarget:self action:@selector(startBackPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.player play];
        [self.player.videoTypeButton setBackgroundImage:[UIImage imageNamed:@"hd-video-icon24"] forState:UIControlStateNormal];
    }

}
-(void)viewDidLayoutSubviews
{
    //   NSLog(@"layout subviews called");
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    
    // NSLog(@"%d x %d",width, height);
}

- (IBAction)closeMovieAction:(id)sender {
}

- (IBAction)shareAction:(id)sender {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_token"];
    [[ShortFlixNetworkEngine sharedInstance]shareAPI:savedValue show_code:_Show_code callback:^(NSDictionary *responceObject, NSError *error) {
        
    }];
    
    NSString *textToShare = SHARELINK;
    NSArray *objectsToShare = @[self.imgView.image, textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityVC animated:YES completion:nil];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==self.alertView1) {
        if (buttonIndex == 0)  // 0 == the cancel button
        {
            
            NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"user_status"];
            
            if ([savedValue isEqualToString:@"Active"]) {
                NSString *str=@"";
                NSString *savedValue2 = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"user_token"];
                NSString *savedValue3 = DUMMY;
                savedValue2=savedValue3;
                [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"user_image"];
                [[NSUserDefaults standardUserDefaults] setObject:@"No Package" forKey:@"user_package"];
                [[NSUserDefaults standardUserDefaults] setObject:savedValue2 forKey:@"user_token"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:str] forKey:@"user_status"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIViewController *Roottocontroller;
                LoginViewController *loginViewController = [[ShortFlixInformation sharedInstance]Storyboard:LOGINSTORYBOARDID];
                Roottocontroller=loginViewController;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            }
            else{
                UIViewController *Roottocontroller;
                ProfileViewController *profileVC = [[ShortFlixInformation sharedInstance]Storyboard:PROFILESTORYBOARDID];
                Roottocontroller=profileVC;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            }

            
        }
        
    }
    else{
        if (buttonIndex == 1)  // 0 == the cancel button
        {
            
            NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"user_status"];
            
            if (![savedValue isEqualToString:@"Active"]) {
                LoginViewController *loginViewController = [[ShortFlixInformation sharedInstance]Storyboard:LOGINSTORYBOARDID];
                
                [self.navigationController pushViewController:loginViewController animated:YES];
            }
            else{
                UIViewController *Roottocontroller;
                ProfileViewController *profileVC = [[ShortFlixInformation sharedInstance]Storyboard:PROFILESTORYBOARDID];
                Roottocontroller=profileVC;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
                [navController setViewControllers: @[Roottocontroller] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
            }
            
        }

    }
}
-(void)targetMethod:(NSTimer *)timer {
    [self hide];
    self.player.videoTypeButton.selected=NO;
}
-(void)devicePortrait{
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}
-(void)hide{
            [self.videoType1Button removeFromSuperview];
            [self.videoType2Button removeFromSuperview];
            [self.videoType3Button removeFromSuperview];

//    self.videoType1Button.hidden=YES;
//    self.videoType2Button.hidden=YES;
//    self.videoType3Button.hidden=YES;
   
}
-(void)show{
//    self.videoType1Button.hidden=NO;
//    self.videoType2Button.hidden=NO;
//    self.videoType3Button.hidden=NO;
    
}


- (IBAction)playMovieAction:(id)sender {
    
    NSString *strUrl=[[episodeListDic valueForKey:@"episode_url_m3u8"]objectAtIndex:0];
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_package"];
    NSString *type=[[detailDic valueForKey:@"show_type"]objectAtIndex:0];
    NSString *videoType=[[episodeListDic valueForKey:@"type"]objectAtIndex:0];
    
    if ([videoType isEqualToString:@"Free"]) {
        [self restrictRotation:NO];
        [self.navigationController setNavigationBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
        [self.view addSubview:self.player];
        self.player.tintColor = [UIColor redColor];
        [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.player play];

    }
    else{
        if (![type isEqualToString:@"Drama"] || [videoType isEqualToString:@"Free"]) {
            if ([savedValue1 isEqualToString:@"Premium"]) {
                [self restrictRotation:NO];
                [self.navigationController setNavigationBarHidden:YES];
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
                
                self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:[NSURL URLWithString:strUrl]];
                [self.view addSubview:self.player];
                self.player.tintColor = [UIColor redColor];
                [self.player.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.player.videoTypeButton addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventTouchUpInside];
                [self.player play];
                
            }
            else{
                msg=[[episodeListDic valueForKey:@"message"]objectAtIndex:indexVal];
                if ([msg length]==0) {
                    msg=@"Please Subscribe Premium";
                }
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:OK, nil];
                [alert show];
            }
        }
    }
 
}
@end
