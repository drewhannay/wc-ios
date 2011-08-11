//
//  DiningMenu.m
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiningMenu.h"


@implementation DiningMenu

@synthesize loadingView;
@synthesize webView;
@synthesize todayButton;
@synthesize prevButton;
@synthesize nextButton;
@synthesize results;

-(void) loadData
{
    NSError *error;
    NSString *stuff = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/36045671/menu.txt"] encoding:NSUTF8StringEncoding error:&error];
    //array populated with URL contents - one line per array entry    
    NSArray *array = [stuff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    //i is a counter, to keep track of where we are in the array.
    int i = 0;
        NSString *line = [array objectAtIndex:i++];
    NSMutableArray *days = [NSMutableArray arrayWithCapacity:7];
    todayIndex = -1;
    for(int j = 0;j<7;j++){
        while([line rangeOfString:@"Date:"].location == NSNotFound){
            line = [array objectAtIndex:i++];
        }
        line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
        NSString *day = [NSString stringWithFormat: @"<html><head><style type=\"text/css\"> h1 { font-size: 1.1em; font-weight: bold;text-align: center; color:#CC6600; } h2 { font-size: 0.9em; } h3 { font-style:italic; font-size: 0.8em;}p { font-size: 0.7em; } </style></head><body><h1>%@</h1><h2><center><strong><u>Lunch</u></strong></center></h2>",line];
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

        while([line rangeOfString:@"Hours:"].location == NSNotFound){
            line = [array objectAtIndex:i++];
        }    
         line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *lunchHours = line; //TODO - do something with this!! Other than check whether it's closed!!!
        if([lunchHours rangeOfString:@"Closed"].location == NSNotFound){
            while([line rangeOfString:@"---Dinner---"].location == NSNotFound){
                while([line rangeOfString:@"---Dinner---"].location == NSNotFound&&[line rangeOfString:@"Station:"].location == NSNotFound){
                        line = [array objectAtIndex:i++];
                }
                line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
               
                day = [day stringByAppendingFormat:@"<h3><em>%@</em></h3><p>",line];
                while([line rangeOfString:@"---Dinner---"].location == NSNotFound&&[line rangeOfString:@"Entrees:"].location == NSNotFound){
                    line = [array objectAtIndex:i++];
                }
                
                line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *entree = @"";
                 while([line rangeOfString:@"---Dinner---"].location == NSNotFound&&[line rangeOfString:@"Station:"].location == NSNotFound){
                     entree = [[entree stringByAppendingString:line] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        line = [array objectAtIndex:i++];
                                      }
                day = [day stringByAppendingFormat:@"%@</p><hr/>",entree];
                
                           } 
  
            day  = [day substringToIndex:[day length]-5];

            
            
        }
        else{
            day = [day stringByAppendingString:@"<p>No Lunch Listed</p>"];
        }
        
        day = [day stringByAppendingString:@"<h2><center><strong><u>Dinner</u></strong></center></h2>"];
        while([line rangeOfString:@"Hours:"].location == NSNotFound){
            line = [array objectAtIndex:i++];
        }    
        line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *dinnerHours = line; //TODO - do something with this!! Other than check whether it's closed!!!
        if([dinnerHours rangeOfString:@"Closed"].location == NSNotFound){
            while([line rangeOfString:@"------"].location == NSNotFound){
                while([line rangeOfString:@"------"].location == NSNotFound&&[line rangeOfString:@"Station:"].location == NSNotFound){
                    line = [array objectAtIndex:i++];
                }
                line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                day = [day stringByAppendingFormat:@"<h3><em>%@</em></h3><p>",line];
                while([line rangeOfString:@"------"].location == NSNotFound&&[line rangeOfString:@"Entrees:"].location == NSNotFound){
                    line = [array objectAtIndex:i++];
                }
                
                line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *entree = @"";
                while([line rangeOfString:@"------"].location == NSNotFound&&[line rangeOfString:@"Station:"].location == NSNotFound){
                    entree = [[entree stringByAppendingString:line] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    line = [array objectAtIndex:i++];
                }
                day = [day stringByAppendingFormat:@"%@</p><hr/>",entree];
                
                            
            } 
           
            day  = [day substringToIndex:[day length]-5];
           
            
            
        }
        else{
            day = [day stringByAppendingString:@"<p>No Dinner Listed</p>"];
        }
        day = [day stringByAppendingString:@"</body></html>"];
        [days insertObject:day atIndex:j];
    }
    self.results = [NSArray arrayWithArray:days];
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
    
    if(results == nil)
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
