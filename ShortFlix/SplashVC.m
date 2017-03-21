//
//  SplashVC.m
//  ShortFlix
//
//  Created by Virinchi Software on 23/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SplashVC.h"


int const kLoadingTime = 5;
NSString* const kMessage = @"Checking version...";
NSString* const kImageName = @"icon";

@interface SplashVC ()
@property (nonatomic, strong) LoadingAnimationView *loadingAnimationView;

@end

@implementation SplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];
    
    versionDic=[[NSMutableDictionary alloc]init];
    [self getVersion];
    if (_loadingAnimationView == nil) {
        _loadingAnimationView = [LoadingAnimationView new];
    }
    [NSTimer scheduledTimerWithTimeInterval:kLoadingTime target:self selector:@selector(stopLoadingAnimationViewDemo) userInfo:nil repeats:NO];
    [_loadingAnimationView showWithImage:[UIImage imageNamed:kImageName] andMessage:kMessage inView:self.view];
        // Do any additional setup after loading the view.
}
- (void)stopLoadingAnimationViewDemo
{
    
    [_loadingAnimationView hide];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    // [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
    // [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getVersion{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [[ShortFlixNetworkEngine sharedInstance] versionAPI:version callback:^(NSDictionary *responceObject, NSError *error) {
        versionDic=[responceObject objectForKey:@"mobile_version"];
        NSString *str=[versionDic objectForKey:@"Default_Token"];
        
        NSString *str1=[versionDic objectForKey:@"Version"];
        if (![version isEqualToString:str1]) {
            [self doExit];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"user_token"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                              target:self
                                                            selector:@selector(handleTimer:)
                                                            userInfo:responceObject repeats:NO];
        }
        
        
        
    }];
}
- (void)handleTimer:(NSTimer*)theTimer {
    HomeViewController *homeViewController = [[ShortFlixInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
    RearViewController *rearViewController = [[ShortFlixInformation sharedInstance]Storyboard:REARSTORYBOARDID];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    [self.navigationController presentViewController:revealController animated:NO completion:nil];
    self.viewController = revealController;
    
    
}

-(void)doExit
{
    //show confirmation message to user
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ALERT
                                                    message:VERSIONUPDATE
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:OK, nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)  // 0 == the cancel button
    {
        //home button press programmatically
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:2.0];
        
        //exit app when app is in background
        exit(0);
    }
}
-(void) restrictRotation:(BOOL) restriction{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}


@end
