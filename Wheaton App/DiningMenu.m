//
//  DiningMenu.m
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiningMenu.h"


@implementation DiningMenu

@synthesize webView;
@synthesize todayButton;
@synthesize prevButton;
@synthesize nextButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSString *content = @"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold; text-align: center; }</style></head><body><br/><br/><br/><br/><h1>No current cafe menu available</h1></body></html>";
    [webView loadHTMLString:content baseURL:nil];
    //NSURL *url = [NSURL URLWithString:@"http://www.wheaton.edu"];
    //NSURLRequest *req = [NSURLRequest requestWithURL:url];
    //[webView loadRequest:req];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) switchPage:(UIButton *)id
{
    
}

@end
