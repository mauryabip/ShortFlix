//
//  RenewViewController.m
//  ShortFlix
//
//  Created by Virinchi Software on 12/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "RenewViewController.h"
#import "SerachCollectionViewController.h"

@interface RenewViewController ()

@end

@implementation RenewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    // Do any additional setup after loading the view.
    //self.title = NSLocalizedString(@"RENEW PACKAGE", nil);
    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search.png"]
                                                                        style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)searchAction{
    SerachCollectionViewController *searchViewController = [[ShortFlixInformation sharedInstance]Storyboard:SEARCHCOLLSTORYBOARDID];
    [self.navigationController pushViewController:searchViewController animated:YES];
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

@end
