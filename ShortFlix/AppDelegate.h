//
//  AppDelegate.h
//  ShortFlix
//
//  Created by Virinchi Software on 10/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortFlixInformation.h"
#import "ShortFlixNetworkEngine.h"
#import "UIImageView+AFNetworking.h"
#import "CookiesVC.h"
#import "MovieCategoryVC.h"
#import "ProfileViewController.h"
#import "SplashVC.h"

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,UIAlertViewDelegate>{
    NSMutableDictionary *versionDic;
}
@property () BOOL restrictRotation;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) SWRevealViewController *viewController;


@end

