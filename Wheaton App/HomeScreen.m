//
//  HomeScreen.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "HomeScreen.h"

@implementation HomeScreen

@synthesize scrollView;
@synthesize loadingView;
@synthesize stalkernetHome;
@synthesize diningMenu;
@synthesize chapel;
@synthesize openFloor;
@synthesize map;
@synthesize links;
@synthesize about;
@synthesize stalkernetButton;
@synthesize diningMenuButton;
@synthesize chapelButton;
@synthesize openFloorButton;
@synthesize mapButton;
@synthesize linksButton;
@synthesize aboutButton;

NSString *const CHAPEL_URL = @"http://dl.dropbox.com/u/36045671/chapel.json";
NSString *const MAP_PINS_URL = @"http://dl.dropbox.com/u/36045671/mapPins.json";
NSString *const MENU_URL = @"http://www.cafebonappetit.com/print-menu/cafe/339/menu/13292/days/not-today/pgbrks/0/";

-(IBAction) launchPage:(UIButton *)button
{
    if(button == stalkernetButton)
    {
        if(self.stalkernetHome == nil)
        {
            StalkernetHome *sHome = [[StalkernetHome alloc]
                                     initWithNibName:@"StalkernetHome" bundle:[NSBundle mainBundle]];
            self.stalkernetHome = sHome;
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
        }
        
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
        }
        
        chapel.navigationItem.title = @"Chapel Schedule";
        [self.navigationController pushViewController:self.chapel animated:YES];
    }
    else if(button == openFloorButton)
    {
        if(self.openFloor == nil)
        {
            OpenFloor *open = [[OpenFloor alloc]
                            initWithNibName:@"OpenFloor" bundle:[NSBundle mainBundle]];
            self.openFloor = open;
        }
        
        openFloor.navigationItem.title = @"Open Floors";
        [self.navigationController pushViewController:self.openFloor animated:YES];
    }
    else if(button == mapButton)
    {
        if(self.map == nil)
        {
            Map *m = [[Map alloc]
                            initWithNibName:@"Map" bundle:[NSBundle mainBundle]];
            self.map = m;
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
        }
        links.navigationItem.title = @"Links";
        [self.navigationController pushViewController:self.links animated:YES];
    }
    else if(button == aboutButton)
    {
        if(self.about == nil)
        {
            About *ab = [[About alloc] init];
            self.about = ab;
        }
        [about setModalTransitionStyle:UIModalTransitionStylePartialCurl];
        [self presentModalViewController:about animated:YES];
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
    
    [scrollView setContentSize:CGSizeMake(320,560)];
    
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
