//
//  TermVC.m
//  ShortFlix
//
//  Created by Virinchi Software on 18/06/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "TermVC.h"
#import "NJKWebViewProgressView.h"

@interface TermVC ()

@end

@implementation TermVC{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:YES];

      self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self loadGoogle];


}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
     [self.navigationController.navigationBar addSubview:_progressView];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     self.revealViewController.panGestureRecognizer.enabled=YES;
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (IBAction)searchButtonPushed:(id)sender
{
    [self loadGoogle];
}

- (IBAction)reloadButtonPushed:(id)sender
{
    [_webView reload];
}

-(void)loadGoogle
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:TERMSANDCONDITIONSURL]];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

@end
