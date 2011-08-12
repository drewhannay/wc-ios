//
//  Chapel.m
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Chapel.h"

@implementation Chapel

@synthesize loadingView;
@synthesize webView;
@synthesize todayButton;
@synthesize prevButton;
@synthesize nextButton;
@synthesize results;

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
    NSString *weekEnd = @"</body></html>";
    NSString *currentWeek = @"";
        int numWeeks = 0;
    //main loop
    while(i<length&&[line rangeOfString:@"-----"].location==NSNotFound){
        NSString *text = @"";
        
        line = [array objectAtIndex:i++];
        
        while(i<length && [line rangeOfString:@"-----"].location==NSNotFound){ 
           text = [text stringByAppendingString:line];
           line = [array objectAtIndex:i++];
        }
        
        if(i<length)
            line = [array objectAtIndex:i++]; 
        //time to add the day to the week. . .
        NSString *day = [self parseDay:text];
        if(![self addDay:day]){
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

            if(!indexSet&&currentDate<=fullDay){
                todayIndex = numWeeks;
                indexSet = TRUE;
             }


            // Release the dateFormatter
            [dateFormatter release];
            numWeeks++;
            
           
        }
         currentWeek = [currentWeek stringByAppendingString:day]; //either way, the day goes in the current week.
    }

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
        [dateFormatter release];
       

    }
    }@catch (NSException *e) {
        self.results = [NSArray arrayWithObjects: @"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold;text-align: center; }</style></head><body><br/><br/><br/><br/><h1>The chapel schedule is not yet available. Check back soon!</h1></body></html>",nil];
        todayIndex = 0;
    }
    //todayIndex = -1; uncomment this line to test the empty chapel schedule case.
    if(todayIndex == -1){
        
        self.results = [NSArray arrayWithObjects: @"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold;text-align: center; }</style></head><body><br/><br/><br/><br/><h1>The chapel schedule is not yet available. Check back soon!</h1></body></html>",nil];
        todayIndex = 0;
    }

    else
        self.results = [NSArray arrayWithArray:tempResults];
}
-(BOOL) addDay:(NSString*)day
{
   return prevDay<currDay;   
}

-(NSString *) parseDay:(NSString*)text
{
    NSString *temp;
    //Get special series, set variable so we can set the text color correctly.
    temp = [text substringFromIndex:[text rangeOfString:@"Special Series? (Y/N):"].location+22];
    temp = [temp substringToIndex:[temp rangeOfString:@"Description:"].location];
    temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL isSpecial = [temp isEqualToString:@"Y"];
    
    NSArray *daysOfWeek = [NSArray arrayWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",nil];
    NSString *day = @"";
    //get the date
    text = [text substringFromIndex:[text rangeOfString:@"Date:"].location+5];
    temp = [text substringToIndex:[text rangeOfString:@"Title"].location];
    temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for(int i = 0;i<7;i++){
        if([temp rangeOfString:[daysOfWeek objectAtIndex:i]].location!=NSNotFound){
            prevDay = currDay;
            currDay = i;
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
    // Release the dateFormatter
    [dateFormatter release];
    fullDay = [newDate intValue];
   // NSLog(@"%d is the date",[date intValue]);
    day = [NSString stringWithFormat:@"<h1>%@</h1>",temp];
    
    //Somehow we need to set the color here, but I haven't worked that out yet.
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
    
    if(isSpecial)
        day = [day stringByAppendingString:@"</span>"];
    
    day = [day stringByAppendingString:@"<hr />"];

    return day;
    
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
