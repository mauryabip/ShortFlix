//
//  ShortFlixNetworkEngine.m
//  ShortFlix
//
//  Created by Appy on 14/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "ShortFlixNetworkEngine.h"


@implementation ShortFlixNetworkEngine

+ (ShortFlixNetworkEngine *)sharedInstance {
    static ShortFlixNetworkEngine *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[ShortFlixNetworkEngine alloc] init];
    });
    return __instance;
}

- (BOOL)isNetworkRechable {
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi)
            NSLog(@"Network reachable via WWAN");
        else
            NSLog(@"Network reachable via Wifi");
        
        return YES;
    }
    else {
        
        NSLog(@"Network is not reachable");
        return NO;
    }
}

- (void) getAPI:(NSString *) urlString
                 params: (NSDictionary *)params
      completionHandler:(void (^)(id responseObject,NSError *error))completionHandler {
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Progress........");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
       // NSLog(@"Success: %@", responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
          // NSLog(@"Error: %@", error);

    }];
}

- (void) postAPI:(NSString *) urlString
                 params: (NSDictionary *)params
      completionHandler:(void (^)(id responseObject,NSError *error))completionHandler {
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [[AFHTTPSessionManager manager] setResponseSerializer:responseSerializer];
    
    [[AFHTTPSessionManager manager] POST:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Progress........");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
        
    }];

}


- (void) putAPI:(NSString *) urlString
                 params: (NSDictionary *)params
      completionHandler:(void (^)(id responseObject,NSError *error))completionHandler {
    
    [[AFHTTPSessionManager manager] PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
    }];
}


- (void) deleteAPI:(NSString *) urlString
                 params: (NSDictionary *)params
      completionHandler:(void (^)(id responseObject,NSError *error))completionHandler {
    
    [[AFHTTPSessionManager manager] DELETE:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
    }];

}


-(void)registerAPI :(NSString *)user_email  userpassword:(NSString *)user_password username:(NSString *)user_name userimei:(NSString *)user_imei usermsisdn:(NSString *)user_msisdn callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
   
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_email, @"user_email",user_password, @"user_password", user_name,@"user_name",user_imei,@"user_imei",user_msisdn,@"user_msisdn", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,Register];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
         callback(responseObject,error);
        
    }];
}
-(void)loginAPI :(NSString *)user_email  userpassword:(NSString *)user_password  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_email, @"user_email",user_password, @"user_password", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,Login];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
       
        callback(responseObject,error);
        
    }];
}

-(void)loginValidationAPI :(NSString *)user_email  usertoken:(NSString *)user_token  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_email, @"user_email",user_token, @"user_token", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,LoginValidation];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)logoutAPI :(NSString *)user_email  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_email, @"user_email", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,Logout];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)versionAPI :(NSString *)version  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:version, @"version", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,VersionCheker];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)newShowAPI :(NSString *)user_token  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,New];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}

-(void)specicalCatNameAPI :(NSString *)user_token  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,SpecialCategoryName];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)specicalCatAPI :(NSString *)special_name   usertoken:(NSString *)user_token callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token",special_name,@"special_name", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,SpecialCategory];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}



-(void)bannerAPI :(NSString *)user_token  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,Promo_Banner];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}

-(void)searchAPI :(NSString *)show_title   usertoken:(NSString *)user_token callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token",show_title,@"show_title", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,Search];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}

-(void)episodeListAPI :(NSString *)show_code   usertoken:(NSString *)user_token callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
//    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSData *data = ...;
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
//        // ... }]; [uploadTask resume];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:show_code,@"show_code",user_token, @"user_token", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,EpisodeList];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)viewActivityAPI :(NSString *)user_token callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,ViewActivity];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)editProfileAPI :(NSString *)user_token  useremail:(NSString *)user_email userpassword:(NSString *)user_password  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token",user_email, @"user_email",user_password, @"user_password", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,EditProfile];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)mobileCatAPI :(NSString *)user_token    callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,MobileCategory];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)mobileCatShowAPI :(NSString *)category_name user_token:(NSString *)user_token    callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:category_name,@"category_name",user_token, @"user_token", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,MobileCategoryShow];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}

-(void)forgotPassAPI :(NSString *)user_email   callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_email, @"user_email", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,ForgotPassword];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)shareAPI :(NSString *)user_token   show_code:(NSString *)show_code callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token",show_code,@"show_code", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,Share];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}

-(void)showDetailAPI :(NSString *)user_token   show_code:(NSString *)show_code callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token",show_code,@"show_code", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,MobileShowDetail];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}
-(void)episodeClickedAPI :(NSString *)user_token   show_code:(NSString *)show_code callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token",show_code,@"show_code", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,EpisodeClicked];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}

-(void)viewLogAPI :(NSString *)user_token episode_code:(NSString*)episode_code  show_code:(NSString *)show_code callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token",episode_code,@"episode_code",show_code,@"show_code", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,View_Log];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}

-(void)mobileAfter5SecAPI :(NSString *)user_token log_episode_id:(NSString*)log_episode_id  callback:(void (^)(NSDictionary *responceObject, NSError *error))callback
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_token, @"user_token",log_episode_id,@"log_episode_id", nil];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",BASE_URL,MobileAfter_5_Sec];
    [[ShortFlixNetworkEngine sharedInstance] postAPI:urlString params:parameters completionHandler:^(id responseObject, NSError *error) {
        
        callback(responseObject,error);
        
    }];
}




@end
