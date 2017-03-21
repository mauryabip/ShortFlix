//
//  ShortFlixInformation.h
//  ShortFlix
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ShortFlixInformation : NSObject

@property (nonatomic, strong) UIAlertView *alertview;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *home;
@property (nonatomic, strong) NSString *signOut;
@property (nonatomic, strong) NSString *logIn;
@property (nonatomic, strong) NSString *myprofile;
@property (nonatomic, strong) NSString *privacy;
@property (nonatomic, strong) NSString *callcenter;
@property (nonatomic, strong) NSDictionary *profileDic;
@property (nonatomic, strong) NSDictionary *languageDic;

@property MBProgressHUD *HUD;



-(void)showAlertWithMessage:(NSString *)message withTitle:(NSString *)title withCancelTitle:(NSString *)cancelTitle;
- (MBProgressHUD *)ShowWaiting:(NSString *)title;
- (void)HideWaiting;
-(id)Storyboard :(NSString*)ControllerId;
+ (ShortFlixInformation *)sharedInstance;
@end
