//
//  DiningMenu.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "DiningMenu.h"


@implementation DiningMenu

@synthesize loadingView;
@synthesize webView;
@synthesize todayButton;
@synthesize prevButton;
@synthesize nextButton;
@synthesize results;


/**
 *Load the menu from the dropbox file
 *and prepare to display it.
 */
-(void) loadData
{
    //temporary array for the days
    NSMutableArray *days = [NSMutableArray arrayWithCapacity:7];
    
    //finds the correct index that representats "today"; -1 means none.
    todayIndex = -1;
    
    //catch all errors
    @try{
        NSError *error;
        
        //read from the public dropbox file        
        NSString *stuff = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/36045671/menu.txt"] encoding:NSUTF8StringEncoding error:&error];
        
        //array populated with URL contents - one line per array entry    
        NSArray *array = [stuff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        //i is a counter, to keep track of where we are in array.
        int i = 0;
        
        //the current line of text
        NSString *line = [array objectAtIndex:i++];
        
        //go through each of the days
        for(int j = 0;j<7;j++){
            
            //look for the marker, "Date:"
            while([line rangeOfString:@"Date:"].location == NSNotFound){
                line = [array objectAtIndex:i++];
            }
            
            //get the date from the string
            line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
            //format the start of the day correctly and add the date
            NSString *day = [NSString stringWithFormat: @"<html><head><style type=\"text/css\"> h1 { font-size: 1.1em; font-weight: bold;text-align: center; color:#CC6600; } h2 { font-size: 0.9em; } h3 { font-style:italic; font-size: 0.8em;}p { font-size: 0.7em; } </style></head><body><h1>%@</h1><h2><center><strong><u>Lunch</u></strong></center></h2>",line];
            
            //get the current date for reference
            NSDate *currentDateTime = [NSDate date];
            // Instantiate a NSDateFormatter
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // Set the dateFormatter format
            [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
            // Get the date time in NSString
            NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
            
            //check if we've found today yet - if so, change todayIndex to demonstrate this
            if([dateInString isEqualToString:line]){
                todayIndex = j;
            }
            
            //While we haven't found the hours yet
            while([line rangeOfString:@"Hours:"].location == NSNotFound){
                line = [array objectAtIndex:i++];
            }    
            
            //Now set line so it contains only the hours
            line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //store this for potential use later
            NSString *lunchHours = line; //TODO - do something with this!! Other than check whether it's closed!!!
            
            //if the cafeteria is not currently closed, get the lunch schedule for this dya
            if([lunchHours rangeOfString:@"Closed"].location == NSNotFound){
                while([line rangeOfString:@"---Dinner---"].location == NSNotFound){
                    while([line rangeOfString:@"---Dinner---"].location == NSNotFound&&[line rangeOfString:@"Station:"].location == NSNotFound){
                            line = [array objectAtIndex:i++];
                    }
                    line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    //Append the station name
                    day = [day stringByAppendingFormat:@"<h3><em>%@</em></h3><p>",line];
                    
                    //look for the entrees
                    while([line rangeOfString:@"---Dinner---"].location == NSNotFound&&[line rangeOfString:@"Entrees:"].location == NSNotFound){
                        line = [array objectAtIndex:i++];
                    }
                
                    line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    //add all the entrees to this day.
                    NSString *entree = @"";
                    while([line rangeOfString:@"---Dinner---"].location == NSNotFound&&[line rangeOfString:@"Station:"].location == NSNotFound){
                        entree = [[entree stringByAppendingString:line] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            line = [array objectAtIndex:i++];
                                      }
                    //finish off this station
                    day = [day stringByAppendingFormat:@"%@</p><hr/>",entree];
                
                           } 
                //get rid of the last <hr/> tag to remove an extra line.
                day  = [day substringToIndex:[day length]-5];

            
            
            }
    
            //if there was no lunch, inform the user.
            else{
                day = [day stringByAppendingString:@"<p>No Lunch Listed</p>"];
            }
        
            //Look for the dinner hours and begin this part of the day
            day = [day stringByAppendingString:@"<h2><center><strong><u>Dinner</u></strong></center></h2>"];
            while([line rangeOfString:@"Hours:"].location == NSNotFound){
                line = [array objectAtIndex:i++];
            }    
            line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //Now we have read in the hours for dinner
            NSString *dinnerHours = line; //TODO - do something with this!! Other than check whether it's closed!!!
            
            //As long as the dining hall is open, gather information about the stations
            if([dinnerHours rangeOfString:@"Closed"].location == NSNotFound){
                while([line rangeOfString:@"------"].location == NSNotFound){
                    //Look for the station name
                    while([line rangeOfString:@"------"].location == NSNotFound&&[line rangeOfString:@"Station:"].location == NSNotFound)
                    {
                        line = [array objectAtIndex:i++];
                    }
                    //Add the station name
                    line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                    day = [day stringByAppendingFormat:@"<h3><em>%@</em></h3><p>",line];
                    
                    //Look for the entrees
                    while([line rangeOfString:@"------"].location == NSNotFound&&[line rangeOfString:@"Entrees:"].location == NSNotFound)
                    {
                        line = [array objectAtIndex:i++];
                    }
                
                    
                    //Add all of the entrees
                    line = [[line substringFromIndex:[line rangeOfString:@":"].location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                    NSString *entree = @"";
                    while([line rangeOfString:@"------"].location == NSNotFound&&[line rangeOfString:@"Station:"].location == NSNotFound)
                    {
                        entree = [[entree stringByAppendingString:line] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        line = [array objectAtIndex:i++];
                    }
                    day = [day stringByAppendingFormat:@"%@</p><hr/>",entree];
                
                            
                } 
                //get rid of the last <hr/> tag
                day  = [day substringToIndex:[day length]-5];
           
            
            
            }
            //If there are no hours, inform the user
            else{
                day = [day stringByAppendingString:@"<p>No Dinner Listed</p>"];
            }
            //finish the day and add it to the temporary array
            day = [day stringByAppendingString:@"</body></html>"];
            [days insertObject:day atIndex:j];
        }
    }@catch (NSException *e) {
        //if any exception occurs, do nothing.
    }
   // todayIndex = -1; uncomment this line for error testing
    if(todayIndex == -1){
        //if we couldn't find today, replace the results array with a message informing the user no current menu is available, and set
        //todayIndex accordingly
        self.results = [NSArray arrayWithObject:@"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold;text-align: center; }</style></head><body><br/><br/><br/><br/><h1>No current cafe menu available</h1></body></html>"];
        todayIndex = 0;
    }
    
    else //if nothing went wrong and we found today, set the array.
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
        if(viewIndex<0)
            viewIndex = 0;
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
