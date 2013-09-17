//
//  MenuTopViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/28/13.
//
//

#import "MenuTopViewController.h"

@interface MenuTopViewController ()

@end

@implementation MenuTopViewController

@synthesize activityView, menuBtn, webView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(self.view.bounds.size.width/2 - activityView.bounds.size.width/2, 52, activityView.bounds.size.width, activityView.bounds.size.height);
    [self.view addSubview:activityView];
    [activityView startAnimating];
    
    self.slidingViewController.underRightViewController = NULL;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(4, 0, 44, 44);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    
    NSString *urlAddress = c_Menu;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview  {
    if (webview.isLoading)
        return;
    [activityView stopAnimating];
}

@end
