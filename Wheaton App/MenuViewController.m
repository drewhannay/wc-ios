//
//  MenuViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import "MenuViewController.h"
#import "MasterTabViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize activityView, webView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *urlAddress = c_Menu;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webview  {
    if (webview.isLoading)
        return;
    [activityView stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
