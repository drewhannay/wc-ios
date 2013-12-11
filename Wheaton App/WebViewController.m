//
//  WebViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 12/6/13.
//
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

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

- (void)viewDidLayoutSubviews {
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
