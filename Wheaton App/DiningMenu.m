//
//  DiningMenu.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "DiningMenu.h"
#import "HomeScreen.h"

@implementation DiningMenu

@synthesize loadingView;
@synthesize webView;

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];

    [loadingView startAnimating];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MENU_URL]]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingView stopAnimating];
}

@end
