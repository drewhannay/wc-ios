//
//  OpenFloor.m
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenFloor.h"


@implementation OpenFloor

@synthesize loadingView;
@synthesize webView;
@synthesize todayButton;
@synthesize prevButton;
@synthesize nextButton;
@synthesize results;

-(void) loadData
{
    NSMutableArray *temp = [NSMutableArray array];
    todayIndex = -1;
    @try{
    NSError *error;
    //NSString *stuff = [NSString stringWithContentsOfFile:@"/Users/lemongirl/Downloads/openfloor.txt" encoding:NSUTF8StringEncoding error:&error];
    
    NSString *stuff = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/36045671/openfloor.txt"] encoding:NSUTF8StringEncoding error:&error];
    //array populated with URL contents - one line per array entry    
    NSArray *array = [stuff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    int length = [array count];
    //i is a counter, to keep track of where we are in the array.
    int i = 0;
    NSString *line = [array objectAtIndex:i++];
    
    //skip example text
    while(i<length&&[line rangeOfString:@"-----"].location == NSNotFound){
        line = [array objectAtIndex:i++];
    }
    line = [array objectAtIndex:i++];
    line = [array objectAtIndex:i++];
    line = [array objectAtIndex:i++];
   
    int j = 0;
    
    while(i<length){
        NSString *text = @"<head><style type=\"text/css\"> h1 { font-size: 1.1em; font-weight: bold;text-align: center; color:#CC6600; } h2 { font-size: 0.9em; } h3 { font-style:italic; font-size: 0.8em;}p { font-size: 0.7em; } </style></head>";
        while([line isEqualToString:@""]||[line rangeOfString:@"-----"].location!=NSNotFound&&i<length){
            line = [array objectAtIndex:i++];
        }
        line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //get the current date for reference
        NSDate *currentDateTime = [NSDate date];
        // Instantiate a NSDateFormatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Set the dateFormatter format
        [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
        // Get the date time in NSString
        NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
        // Release the dateFormatter
        [dateFormatter release];
        if([dateInString isEqualToString:line]){
            todayIndex = j;
        }
        
        text = [text stringByAppendingFormat:@"<h1>%@</h1>",line];
        while(i<length&&[line rangeOfString:@"Open Fischer Floors:"].location == NSNotFound){
            line = [array objectAtIndex:i++];
        }
        text = [text stringByAppendingFormat:@"<h2>%@</h2>",[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        line = [array objectAtIndex:i++];
        while(i<length&&[line rangeOfString:@"Open Smith/Traber Floors:"].location == NSNotFound){
            line =[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(![line isEqualToString:@""])
                text = [text stringByAppendingFormat:@"%@<br />",line];
            line = [array objectAtIndex:i++];
        }
        text = [text stringByAppendingFormat:@"<h2>%@</h2>",[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        line = [array objectAtIndex:i++];
        
        while(i<length&&[line rangeOfString:@"-----"].location == NSNotFound){
            if(![[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
                // NSLog(@"*%@*",[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
                text = [text stringByAppendingFormat:@"%@<br />",[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                
            }
            line = [array objectAtIndex:i++];
        }
        text = [text stringByAppendingString:@"</body></html>"];
        [temp addObject:text];
        j++;
        
        
    }
    }@catch (NSException *e) {
        
    }
    //todayIndex = -1; uncomment this line for error-checking
    if(todayIndex == -1){
        self.results = [NSArray arrayWithObject:@"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold;text-align: center; }</style></head><body><br/><br/><br/><br/><h1>The open floor schedule is not yet available. Check back soon!</h1></body></html>"];
        todayIndex = 0;
    }
    else
        self.results = [NSArray arrayWithArray:temp];
    
    //todayIndex = 0;
    
   // for(NSString *mine in results)
     //   NSLog(@"%@",mine);
    
}

-(IBAction) switchPage:(UIButton *)button
{
    if(button==nextButton)
    {
        viewIndex++;
        [webView loadHTMLString:[results objectAtIndex:viewIndex] baseURL:nil];
        
        prevButton.hidden = false;
        
        if(viewIndex==([results count]-1))
            nextButton.hidden = true;
        
    }
    else if(button==prevButton)
    {
        viewIndex--;
        [webView loadHTMLString:[results objectAtIndex:viewIndex] baseURL:nil];
        
        nextButton.hidden = false;
        
        if(viewIndex==0)
            prevButton.hidden = true;
        
    }
    else if(button==todayButton)
    {        
        viewIndex = todayIndex;
        
        [webView loadHTMLString:[results objectAtIndex:viewIndex] baseURL:nil];
        
        if(viewIndex==0)
            prevButton.hidden = true;
        else
            prevButton.hidden = false;
        if(viewIndex==([results count]-1))
            nextButton.hidden = true;
        else
            nextButton.hidden = false;
        
    }
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
    [webView release];
    [todayButton release];
    [prevButton release];
    [nextButton release];
    [results release];
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
    
    //Hide both the buttons. We'll set them to visible later if needed.
    prevButton.hidden = true;
    nextButton.hidden = true;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Hide both the buttons. We'll set them to visible later if needed.
    prevButton.hidden = true;
    nextButton.hidden = true;
    
    //---Start our loading spinner---
    [NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
    
    if(self.results == nil)
        [self loadData];
    
    //---Stop the spinner and continue on with launching the view---
    [NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];
    
    viewIndex = todayIndex;
    
    [webView loadHTMLString:[results objectAtIndex:viewIndex] baseURL:nil];
    if(viewIndex==0)
        prevButton.hidden = true;
    else
        prevButton.hidden = false;
    if(viewIndex==([results count]-1))
        nextButton.hidden = true;
    else
        nextButton.hidden = false;
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
