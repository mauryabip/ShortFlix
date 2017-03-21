//
//  CookiesVC.h
//  ShortFlix
//
//  Created by Virinchi Software on 15/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController/SWRevealViewController.h"
#import "AppDelegate.h"
#import "NJKWebViewProgress.h"

@interface CookiesVC : UIViewController<UIWebViewDelegate,SWRevealViewControllerDelegate,NJKWebViewProgressDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
