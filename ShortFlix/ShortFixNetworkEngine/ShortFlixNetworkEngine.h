//
//  ShortFlixNetworkEngine.h
//  ShortFlix
//
//  Created by Appy on 14/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface ShortFlixNetworkEngine : NSObject

+ (ShortFlixNetworkEngine *)sharedInstance;

- (BOOL)isNetworkRechable;

- (void) getAPI:(NSString *) urlString
      params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler;

- (void) postAPI:(NSString *) urlString
      params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler;

- (void) putAPI:(NSString *) urlString
      params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler;

- (void) deleteAPI:(NSString *) urlString
      params: (NSDictionary *)params
 completionHandler:(void (^)(id responseObject,NSError *error))completionHandler;



-(void)registerAPI :(NSString *)user_email  userpassword:(NSString *)user_password username:(NSString *)user_name userimei:(NSString *)user_imei usermsisdn:(NSString *)user_msisdn callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)loginAPI :(NSString *)user_email  userpassword:(NSString *)user_password  callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)loginValidationAPI :(NSString *)user_email  usertoken:(NSString *)user_token  callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)logoutAPI :(NSString *)user_email  callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)versionAPI :(NSString *)version  callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)newShowAPI :(NSString *)user_token  callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)specicalCatNameAPI :(NSString *)user_token  callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)specicalCatAPI :(NSString *)special_name   usertoken:(NSString *)user_token callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)bannerAPI :(NSString *)user_token  callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)searchAPI :(NSString *)show_title   usertoken:(NSString *)user_token callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)episodeListAPI :(NSString *)show_code   usertoken:(NSString *)user_token callback:(void (^)(NSDictionary *VehicleDetail, NSError *error))callback;
-(void)viewActivityAPI :(NSString *)user_token callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)editProfileAPI :(NSString *)user_token  useremail:(NSString *)user_email userpassword:(NSString *)user_password  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)mobileCatAPI :(NSString *)user_token    callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)mobileCatShowAPI :(NSString *)category_name user_token:(NSString *)user_token    callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)forgotPassAPI :(NSString *)user_email   callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)shareAPI :(NSString *)user_token   show_code:(NSString *)show_code callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)showDetailAPI :(NSString *)user_token   show_code:(NSString *)show_code callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)episodeClickedAPI :(NSString *)user_token   show_code:(NSString *)show_code callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)viewLogAPI :(NSString *)user_token episode_code:(NSString*)episode_code  show_code:(NSString *)show_code callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
-(void)mobileAfter5SecAPI :(NSString *)user_token log_episode_id:(NSString*)log_episode_id  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback;
@end
