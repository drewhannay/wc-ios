//
//  HomeScreen.m
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeScreen.h"
#import "StalkernetHome.h"
#import "DiningMenu.h"
#import "Chapel.h"
#import "Links.h"

@implementation HomeScreen

@synthesize stalkernetHome;
@synthesize diningMenu;
@synthesize chapel;
@synthesize links;
@synthesize stalkernetButton;
@synthesize diningMenuButton;
@synthesize chapelButton;
@synthesize linksButton;

-(IBAction) launchPage:(UIButton *)button
{
    if(button == stalkernetButton)
    {
        if(self.stalkernetHome == nil)
        {
            StalkernetHome *sHome = [[StalkernetHome alloc]
                                     initWithNibName:@"StalkernetHome" bundle:[NSBundle mainBundle]];
            self.stalkernetHome = sHome;
            [sHome release];
        }
        stalkernetHome.navigationItem.title = @"Who's Who";
        [self.navigationController pushViewController:self.stalkernetHome animated:YES];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

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

@end
