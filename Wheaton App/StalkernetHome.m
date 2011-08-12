//
//  StalkernetHome.m
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StalkernetHome.h"


@implementation StalkernetHome

@synthesize searchBox;
@synthesize searchButton;
@synthesize resultScreen;
@synthesize loadingView;

-(IBAction) runSearch
{
    StalkernetResults *rScreen = [[StalkernetResults alloc]
                                  initWithNibName:@"StalkernetResults" bundle:[NSBundle mainBundle]];
    self.resultScreen = rScreen;
    [rScreen release];
    
    NSString *temp = [searchBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    resultScreen.navigationItem.title = temp;
    
    temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if([temp isEqualToString:@""])
    {
        [[[iToast makeText:NSLocalizedString(@"Please enter a search term", @"")] setDuration:3000] show];
        return;
    }
        
    //---Start our loading spinner---
    [NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
    
    //--This line is just for testing how the spinner looks---
    //[NSThread sleepForTimeInterval:3];
    
    resultScreen.searchParam = temp;
    BOOL exception = FALSE;
    @try {
        [self.resultScreen loadData];
    }
    @catch (NSException *e) {
        [[[iToast makeText:@"You must connect to the Wheaton College campus internet to use this feature."] setDuration:3000] show];
        exception = TRUE;
    }

    
    //---Stop the spinner and continue on with launching the view---
    [NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];
    
    if(!exception&&[resultScreen.resultsList count]>0)
    {
        [self.navigationController pushViewController:self.resultScreen animated:YES];
    }
    else if(!exception)
    {
        [[[iToast makeText:NSLocalizedString(@"No results", @"")] setDuration:3000] show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self runSearch];
    return NO;
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
    [resultScreen release];
    [loadingView release];
    [searchBox release];
    [searchButton release];
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
