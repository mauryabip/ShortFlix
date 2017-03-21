//
//  EditProfileViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "EditProfileViewController.h"
#import "HomeViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];


    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user_name"];
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"user_email"];
    self.userProfile.layer.cornerRadius = self.userProfile.frame.size.width / 2;
    self.userProfile.clipsToBounds = YES;
    self.userProfile.contentMode = UIViewContentModeScaleAspectFill;
    NSString *imgName = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"user_image"];
    if ([imgName length]==0) {
        self.userProfile.image=[UIImage imageNamed:@"user"];
    }
    else
        self.userProfile.image=[UIImage imageNamed:imgName];
    //NSString *savedValue2 = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_token"];
    
    self.userNameLbl.text=savedValue;
    self.userEmailLbl.text=savedValue1;
   // self.phoneLbl.text=savedValue2;

    self.oldPasswordTXT.delegate=self;
    self.nwPasswordTXT.delegate=self;
    self.retypePasswordTXT.delegate=self;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    self.scrollView.contentInset = contentInsets;

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    // Do any additional setup after loading the view.
   // self.title = NSLocalizedString(@"EDIT PROFILE", nil);
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(backButton)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search.png"]
                                                                        style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchAction{
    SerachCollectionViewController *searchViewController = [[ShortFlixInformation sharedInstance]Storyboard:SEARCHCOLLSTORYBOARDID];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark UITextFieldDelegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}


- (IBAction)saveBtnAction:(id)sender {
    if (self.nwPasswordTXT.hasText && self.retypePasswordTXT.hasText) {
        if ([self.nwPasswordTXT.text isEqualToString:self.retypePasswordTXT.text]) {
            NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"user_token"];
            NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"user_email"];
            [[ShortFlixNetworkEngine sharedInstance] editProfileAPI:savedValue useremail:savedValue1 userpassword:self.retypePasswordTXT.text callback:^(NSDictionary *responseObject, NSError *error) {
                HomeViewController *homeVC = [[ShortFlixInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
                [self.navigationController pushViewController:homeVC animated:YES];
                
                //  NSLog(@"dfkjghdfjhkgdf   sdjhgdfhj  shfdgvdjhfg  %@",responseObject);
            }];
        }
        else{
            [[ShortFlixInformation sharedInstance]showAlertWithMessage:PASSWORDDONOTMATCH withTitle:ALERT withCancelTitle:OK];
        }

    }
    else{
         [[ShortFlixInformation sharedInstance]showAlertWithMessage:ENTERALLFIELDS withTitle:nil withCancelTitle:OK];
    }
}
- (IBAction)imagePicBtnAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage* image;
    
    if([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
    {
        
        image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        self.userProfile.image = image;
        
        NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"New Folder"];
        
        // New Folder is your folder name
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
        
        NSString *fileName = [stringPath stringByAppendingFormat:@"/image.jpg"];
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [[NSUserDefaults standardUserDefaults] setObject:fileName forKey:@"user_image"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [data writeToFile:fileName atomically:YES];
        
    }
    //    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //
    //    self.imageProfile.image = chosenImage;
    //    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    //
    //    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"ProfileImage"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    //
    //    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    //
    //    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    //    {
    //        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
    //        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
    //
    //        NSString *imgName=[imageRep filename];
    //        [[NSUserDefaults standardUserDefaults] setObject:imgName forKey:@"user_image"];
    //
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //    };
    //
    //    // get the asset library and fetch the asset based on the ref url
    //    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    //    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    //
    //
    //    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}


@end
