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
@synthesize whosWhoButton;
@synthesize diningMenuButton;
@synthesize chapelButton;
@synthesize openFloorButton;
@synthesize mapButton;
@synthesize linksButton;
@synthesize aboutButton;

NSString *const CHAPEL_URL = @"http://dl.dropbox.com/u/36045671/chapel.json";
NSString *const MAP_PINS_URL = @"http://dl.dropbox.com/u/36045671/mapPins.json";
NSString *const MENU_URL = @"http://www.cafebonappetit.com/print-menu/cafe/339/menu/13292/days/not-today/pgbrks/0/";
NSString *const OPEN_FLOOR_URL = @"http://cs.wheaton.edu/~drew.hannay/wheatonapp/GetFloorJson.php";
NSString *const WHOS_WHO_PREFIX = @"https://webapp.wheaton.edu/whoswho/person/searchJson?page_size=100&q=";

-(IBAction) launchPage:(UIButton *)button
{
    if(button == whosWhoButton)
    {
        if(whosWhoSearch == nil)
            whosWhoSearch = [[WhosWhoSearch alloc] initWithNibName:@"WhosWhoSearch" bundle:[NSBundle mainBundle]];

        whosWhoSearch.navigationItem.title = @"Who's Who";
        [self.navigationController pushViewController:whosWhoSearch animated:YES];
    }
    else if(button == diningMenuButton)
    {
        if(diningMenu == nil)
            diningMenu = [[DiningMenu alloc] initWithNibName:@"DiningMenu" bundle:[NSBundle mainBundle]];

        diningMenu.navigationItem.title = @"Bon Appétit";
        [self.navigationController pushViewController:diningMenu animated:YES];
    }
    else if(button == chapelButton)
    {
        Chapel *chapel = [[Chapel alloc] initWithNibName:@"Chapel" bundle:[NSBundle mainBundle]];
        chapel.navigationItem.title = @"Chapel Schedule";
        [self.navigationController pushViewController:chapel animated:YES];
    }
    else if(button == openFloorButton)
    {
        OpenFloor *openFloor = [[OpenFloor alloc] initWithNibName:@"OpenFloor" bundle:[NSBundle mainBundle]];
        openFloor.navigationItem.title = @"Open Floors";
        [self.navigationController pushViewController:openFloor animated:YES];
    }
    else if(button == mapButton)
    {
        Map *map = [[Map alloc] initWithNibName:@"Map" bundle:[NSBundle mainBundle]];
        map.navigationItem.title = @"Campus Map";
        [self.navigationController pushViewController:map animated:YES];
    }
    else if(button == linksButton)
    {
        if(links == nil)
            links = [[Links alloc] initWithNibName:@"Links" bundle:[NSBundle mainBundle]];

        links.navigationItem.title = @"Links";
        [self.navigationController pushViewController:links animated:YES];
    }
    else if(button == aboutButton)
    {
        if(about == nil)
            about = [[About alloc] init];
        [about setModalTransitionStyle:UIModalTransitionStylePartialCurl];
        [self presentModalViewController:about animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [scrollView setContentSize:CGSizeMake(320,560)];
}

@end
