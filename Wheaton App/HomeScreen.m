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
#import "Map.h"

@implementation HomeScreen

@synthesize loadingView;
@synthesize stalkernetHome;
@synthesize diningMenu;
@synthesize chapel;
@synthesize map;
@synthesize links;
@synthesize stalkernetButton;
@synthesize diningMenuButton;
@synthesize chapelButton;
@synthesize mapButton;
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
    else if(button == diningMenuButton)
    {
        if(self.diningMenu == nil)
        {
            DiningMenu *dMenu = [[DiningMenu alloc]
                                     initWithNibName:@"DiningMenu" bundle:[NSBundle mainBundle]];
            self.diningMenu = dMenu;
            [dMenu release];
        }
        
        // TODO: Check if we've already cached the menu before loading the spinner
        
        //---Start our loading spinner---
        [NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
        
        // TODO: Load the menu from Dropbox
        
        //--This line is just for testing how the spinner looks---
        [NSThread sleepForTimeInterval:3];
        
        //---Stop the spinner and continue on with launching the view---
        [NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];
        
        
        diningMenu.navigationItem.title = @"Bon Appétit";
        [self.navigationController pushViewController:self.diningMenu animated:YES];
    }
    else if(button == chapelButton)
    {
        if(self.chapel == nil)
        {
            Chapel *chap = [[Chapel alloc]
                                 initWithNibName:@"Chapel" bundle:[NSBundle mainBundle]];
            self.chapel = chap;
            [chap release];
        }
        
        // TODO: Check if we've already cached the menu before loading the spinner
        
        //---Start our loading spinner---
        [NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
        
        // TODO: Load the menu from Dropbox
        
        //--This line is just for testing how the spinner looks---
        [NSThread sleepForTimeInterval:3];
        
        //---Stop the spinner and continue on with launching the view---
        [NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];
        
        
        chapel.navigationItem.title = @"Chapel Schedule";
        [self.navigationController pushViewController:self.chapel animated:YES];
    }
    else if(button == mapButton)
    {
        if(self.map == nil)
        {
            Map *m = [[Map alloc]
                            initWithNibName:@"Map" bundle:[NSBundle mainBundle]];
            self.map = m;
            [m release];
        }
        map.navigationItem.title = @"Campus Map";
        [self.navigationController pushViewController:self.map animated:YES];
    }
    else if(button == linksButton)
    {
        if(self.links == nil)
        {
            Links *linkView = [[Links alloc]
                            initWithNibName:@"Links" bundle:[NSBundle mainBundle]];
            self.links = linkView;
            [linkView release];
        }
        links.navigationItem.title = @"Links";
        [self.navigationController pushViewController:self.links animated:YES];
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
    [loadingView release];
    [stalkernetHome release];
    [diningMenu release];
    [chapel release];
    [map release];
    [links release];
    [stalkernetButton release];
    [diningMenuButton release];
    [chapelButton release];
    [mapButton release];
    [linksButton release];
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

-(void) spinBegin
{
    [loadingView startAnimating];
}

-(void) spinEnd
{
    [loadingView stopAnimating];
}

@end
