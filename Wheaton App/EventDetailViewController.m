//
//  EventDetailViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 12/6/13.
//
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize webView, activityView, urlString;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *urlAddress = urlString;
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
