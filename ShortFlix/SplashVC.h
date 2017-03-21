//
//  SplashVC.h
//  ShortFlix
//
//  Created by Virinchi Software on 23/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "RearViewController.h"
#import "ShortFlixInformation.h"
#import "ShortFlixNetworkEngine.h"
#import "LoadingAnimationView.h"


@class SWRevealViewController;

@interface SplashVC : UIViewController<SWRevealViewControllerDelegate,UIAlertViewDelegate>{
    NSMutableDictionary *versionDic;
}
@property (strong, nonatomic) SWRevealViewController *viewController;
@property (strong, nonatomic) UIAlertView *alertView;

@end
