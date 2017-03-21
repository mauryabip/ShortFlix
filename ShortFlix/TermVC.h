//
//  TermVC.h
//  ShortFlix
//
//  Created by Virinchi Software on 18/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NJKWebViewProgress.h"

@interface TermVC : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
