//
//  AppDelegate.m
//  ShortFlix
//
//  Created by Virinchi Software on 10/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "RearViewController.h"
#import "ShortFixNetworkEngine/ShortFlixNetworkEngine.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNetworkChnageNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
   // [NSThread sleepForTimeInterval:2.0];

    versionDic=[[NSMutableDictionary alloc]init];
    
    
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:66/255.0f green:66/255.0f blue:66/255.0f alpha:1.0f]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
       // [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window = window;
        SplashVC *homeViewController=[[ShortFlixInformation sharedInstance]Storyboard:SPLASHSTORYBOARD];
       // HomeViewController *homeViewController = [[ShortFlixInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
        RearViewController *rearViewController = [[ShortFlixInformation sharedInstance]Storyboard:REARSTORYBOARDID];
        
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        revealController.delegate = self;
    
        self.viewController = revealController;
        
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)receiveNetworkChnageNotification:(NSNotification *)notification
{
    if (![[ShortFlixNetworkEngine sharedInstance] isNetworkRechable])
    {
        self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:nil cancelButtonTitle:OK otherButtonTitles:nil];
        [self.alertView show];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"Internet connection is available on your device ";
        hud.detailsLabelFont = hud.labelFont;
        hud.margin = 10.f;
        hud.yOffset = 0;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
       // [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
       // [self getVersion];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
-(void)getVersion{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[ShortFlixNetworkEngine sharedInstance] versionAPI:version callback:^(NSDictionary *responceObject, NSError *error) {
        versionDic=[responceObject objectForKey:@"mobile_version"];
        NSString *str=[versionDic objectForKey:@"Default_Token"];
        
        NSString *str1=[versionDic objectForKey:@"Version"];
        if (![version isEqualToString:str1]) {
            [self doExit];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"user_token"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        
    }];
    
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.restrictRotation)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskAll;
}

@end
