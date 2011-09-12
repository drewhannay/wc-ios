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
@synthesize updateMessage;
@synthesize stalkernetButton;
@synthesize diningMenuButton;
@synthesize chapelButton;
@synthesize openFloorButton;
@synthesize mapButton;
@synthesize linksButton;
@synthesize aboutButton;

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
            [open release];
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
    else if(button == aboutButton)
    {
        if(self.about == nil)
        {
            About *ab = [[About alloc] init];
            self.about = ab;
            [ab release];
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

- (void)dealloc
{
    [versionCode release];
    [scrollView release];
    [loadingView release];
    [stalkernetHome release];
    [diningMenu release];
    [chapel release];
    [openFloor release];
    [map release];
    [links release];
    [about release];
    [updateMessage release];
    [stalkernetButton release];
    [diningMenuButton release];
    [chapelButton release];
    [openFloorButton release];
    [mapButton release];
    [linksButton release];
    [aboutButton release];
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
    
    [scrollView setContentSize:CGSizeMake(320,560)];
    
    versionCode = @"1.4";
    NSError *error = nil;
    NSString *stuff = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/36045671/update.txt"] encoding:NSUTF8StringEncoding error:&error];
    if(stuff == nil|| [stuff isEqualToString:@""])
        return;
    //array populated with URL contents - one line per array entry    
    NSMutableArray *array = [[[stuff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy] autorelease];
    if(error != nil || [versionCode isEqualToString:[array objectAtIndex:0]])
        return;

    [array removeObjectAtIndex:0];
    
    UpdateMessage *um = [[UpdateMessage alloc] init];
    self.updateMessage = um;
    [um release];
        
    NSString *temp = [array componentsJoinedByString:@"\n"];

    
    updateMessage.updateText = temp;
    
    
    [self.updateMessage setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentModalViewController:self.updateMessage animated:YES];
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
