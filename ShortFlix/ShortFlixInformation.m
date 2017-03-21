//
//  ShortFlixInformation.m
//  ShortFlix
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "ShortFlixInformation.h"

@implementation ShortFlixInformation
+ (ShortFlixInformation *)sharedInstance {
    static ShortFlixInformation *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[ShortFlixInformation alloc] init];
    });
    return __instance;
}
-(id)Storyboard :(NSString*)ControllerId
{
    UIViewController *vv=  [[UIStoryboard storyboardWithName:STORYBOARD bundle:nil] instantiateViewControllerWithIdentifier:ControllerId];
    return vv;
}
-(void)showAlertWithMessage:(NSString *)message withTitle:(NSString *)title withCancelTitle:(NSString *)cancelTitle {
    
    self.alertview = nil;
    
    if (!self.alertview) {
        
        self.alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        
        [self.alertview show];
    }
}

- (MBProgressHUD *)ShowWaiting:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    return hud;
}
- (void)HideWaiting {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

@end
