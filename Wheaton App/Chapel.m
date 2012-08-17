//
//  Chapel.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "Chapel.h"

@implementation Chapel

@synthesize loadingView;
@synthesize webView;
@synthesize todayButton;
@synthesize prevButton;
@synthesize nextButton;
@synthesize results;

/**
 *Load the chapel schedule from
 *the dropbox file and prepare to display it.
 */
-(void) loadData
{
    todayIndex = -1;
    //To hold the results; one week per entry.
    NSMutableArray *tempResults = [NSMutableArray arrayWithCapacity:0];  

    @try{
        NSError *error;
    
        NSString *stuff = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/36045671/Chapel%20Schedule.txt"] encoding:NSUTF8StringEncoding error:&error];
        //array populated with URL contents - one line per array entry    
        NSArray *array = [stuff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        //i is a counter, to keep track of where we are in the array.
        int i = 0;
        //keep track of this rather than multiple method calls
        int length = [array count];
    
        //the current line.
        NSString *line = [array objectAtIndex:i++];
    
        //Skip the example text
        while(i<length && [line rangeOfString:@"-----"].location==NSNotFound) 
            line = [array objectAtIndex:i++]; 
        line = [array objectAtIndex:i++];
        //Start off the week properly
        NSString *weekStart = @"<html><head><style type=\"text/css\"> h1 { font-size: 1.1em; font-weight: bold;text-align: center; color:#CC6600; } h2 { font-size: 0.9em; } h3 { font-style:italic; font-size: 0.8em;}p { font-size: 0.7em; } </style></head><body>";
        //to make sure the week is ended correctly
        NSString *weekEnd = @"</body></html>";
        
        //keep track of the current week
        NSString *currentWeek = @"";
        //count which week we are in
        int numWeeks = 0;
        //main loop
        while(i<length&&[line rangeOfString:@"-----"].location==NSNotFound){
            
            NSString *text = @"";
        
            line = [array objectAtIndex:i++];
            //add information about the week to the text
            while(i<length && [line rangeOfString:@"-----"].location==NSNotFound){ 
                text = [text stringByAppendingString:line];
                line = [array objectAtIndex:i++];
            }
        
            if(i<length)
                line = [array objectAtIndex:i++]; 
            //time to add the day to the week. . .
            NSString *day = [self parseDay:text]; //parse the text to get a propery formatted day
            
            //if we can't add the day to the week, that means it's the end of the week
            if(![self addDay]){
                //if it's the end of the week, add it to the results list and clear the currentWeek.
                [tempResults addObject:[NSString stringWithFormat:@"%@%@%@",weekStart,currentWeek,weekEnd]];
                currentWeek = @"";
                NSDate *currentDateTime = [NSDate date];
                // Instantiate a NSDateFormatter
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                // Set the dateFormatter format
                [dateFormatter setDateFormat:@"yyyyMMdd"];
                // Get the date time in NSString
                NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
                int currentDate = [dateInString intValue];

                //if we haven't already found one, and the last day of the week is less than or is the current day,
                //we have found this week - set todayIndex and mark that we have found the right week
                if(!indexSet&&currentDate<=fullDay){
                    todayIndex = numWeeks;
                    indexSet = TRUE;
                }

                numWeeks++;
            
           
            }
            currentWeek = [currentWeek stringByAppendingString:day]; //either way, the day goes in the current week.
        }

        //keep track of the final week, which is otherwise not added normally.
        if(![currentWeek isEqualToString:@""]){
            [tempResults addObject:[NSString stringWithFormat:@"%@%@%@",weekStart,currentWeek,weekEnd]];
            NSDate *currentDateTime = [NSDate date];
            // Instantiate a NSDateFormatter
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // Set the dateFormatter format
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            // Get the date time in NSString
            NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
            int currentDate = [dateInString intValue];
        
            if(!indexSet&&currentDate<=fullDay){
                todayIndex = numWeeks;
                indexSet = TRUE;
            }

        }
    }@catch (NSException *e) {
        //if any exception is thrown, do nothing.
    }
    //todayIndex = -1; uncomment this line to test the empty chapel schedule case.
    if(todayIndex == -1){
        //if we never found this week, inform the user the chapel schedule is not yet available.
        self.results = [NSArray arrayWithObjects: @"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold;text-align: center; }</style></head><body><br/><br/><br/><br/><h1>The chapel schedule is not yet available. Check back soon!</h1></body></html>",nil];
        todayIndex = 0;
    }

    else //otherwise, set the results.
        self.results = [NSArray arrayWithArray:tempResults];
}

/**
 *Determine if we can add the current day to the week,
 * if it starts a new week.
 */
-(BOOL) addDay
{
   return prevDay<currDay;   //if the previous day of the week is less than the current day, we are still in the same week.
    //Otherwise the day cannot be added to teh current week.
}

/**
 *Parse a day from the schedule.
 *@param text The schedule to parse
 *@return The NSString html representation of the
 *day's schedule.
 **/
-(NSString *) parseDay:(NSString*)text
{
    NSString *temp;
    //Get special series, set variable so we can set the text color correctly.
    temp = [text substringFromIndex:[text rangeOfString:@"Special Series? (Y/N):"].location+22];
    temp = [temp substringToIndex:[temp rangeOfString:@"Description:"].location];
    temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    BOOL isSpecial = [temp isEqualToString:@"Y"]; //used to set the color of the text
    
    NSArray *daysOfWeek = [NSArray arrayWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",nil];
    NSString *day = @"";
    //get the date
    text = [text substringFromIndex:[text rangeOfString:@"Date:"].location+5];
    temp = [text substringToIndex:[text rangeOfString:@"Title"].location];
    temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for(int i = 0;i<7;i++){
        if([temp rangeOfString:[daysOfWeek objectAtIndex:i]].location!=NSNotFound){
            prevDay = currDay;
            currDay = i; //Find which number in the array the day is, and set prevDay and currDay.
            break;
        }
    }
    
    // Instantiate a NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    //[dateFormatter setDateFormat:@"yyyyMMd"];
    [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    // Get the date time in NSString
    NSDate *oldDate = [dateFormatter dateFromString:temp];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *newDate = [dateFormatter stringFromDate:oldDate];

    fullDay = [newDate intValue]; //set fullDay for use later.
    
    //add the date to the day
    day = [NSString stringWithFormat:@"<h1>%@</h1>",temp];
    
    //add color to the text if appropriate.
    if(isSpecial)
        day = [day stringByAppendingString:@"<span style=\"color:#000066\">"];
    
    //get the title
    text = [text substringFromIndex:[text rangeOfString:@"Title:"].location+6];
    temp = [text substringToIndex:[text rangeOfString:@"Speaker(s) [Optional]:"].location];
    day = [day stringByAppendingString:[NSString stringWithFormat:@"<h2>%@</h2>",[temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    //get speakers
    text = [text substringFromIndex:[text rangeOfString:@"Speaker(s) [Optional]:"].location+22];
    temp = [text substringToIndex:[text rangeOfString:@"Special Series? (Y/N):"].location];
    day = [day stringByAppendingString:[NSString stringWithFormat:@"<h3>%@</h3>",[temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    //Get description
    text = [text substringFromIndex:[text rangeOfString:@"Description:"].location+12];
    day = [day stringByAppendingString:[NSString stringWithFormat:@"<p>%@</p>",[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
   //end the span, if the text was colored.
    if(isSpecial)
        day = [day stringByAppendingString:@"</span>"];
    
    //add a line at the end of the day
    day = [day stringByAppendingString:@"<hr />"];

    return day;
    
}

-(IBAction) switchPage:(UIButton *)button
{
    if(button==nextButton)
    {
        viewIndex++;
        if(viewIndex>=[results count])
            viewIndex = [results count]-1;
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
    if(viewIndex<0)
        viewIndex = 0;
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
