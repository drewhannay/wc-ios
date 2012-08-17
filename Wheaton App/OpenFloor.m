//
//  OpenFloor.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "OpenFloor.h"


@implementation OpenFloor

@synthesize loadingView;
@synthesize webView;
@synthesize todayButton;
@synthesize prevButton;
@synthesize nextButton;
@synthesize results;


/**
 *Load the open floor schedule from
 *the dropbox file and prepare to display it.
 */
-(void) loadData
{
   //Temporary array to store results, since we don't know the size of the array yet
    NSMutableArray *temp = [NSMutableArray array];
    
    //Which location in the array represents today, if any. If none, todayIndex remains -1
    todayIndex = -1;
    
    //catch all errors
    @try{
        NSError *error;
        
        //Read in from the public dropbox file with the open floor schedule
        NSString *stuff = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/36045671/openfloor.txt"] encoding:NSUTF8StringEncoding error:&error];
        
        //array populated with URL contents - one line per array entry    
        NSArray *array = [stuff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        //the length of the array, so we don't have to recompute this every time.
        int length = [array count];
        //i is a counter, to keep track of where we are in array.
        int i = 0;
        
        //the current line of text.
        NSString *line = [array objectAtIndex:i++];
    
        //skip example text
        while(i<length&&[line rangeOfString:@"-----"].location == NSNotFound){
            line = [array objectAtIndex:i++];
        }
        //and the rest of the extra text
        line = [array objectAtIndex:i++];
        line = [array objectAtIndex:i++];
        line = [array objectAtIndex:i++];
   
        //keep track of the position in the temporary array for results.
        int j = 0;
    
        //go through the whole dropbox file
        while(i<length){
            //start off the day with this text for dispaly purposes
            NSString *text = @"<head><style type=\"text/css\"> h1 { font-size: 1.1em; font-weight: bold;text-align: center; color:#CC6600; } h2 { font-size: 0.9em; } h3 { font-style:italic; font-size: 0.8em;}p { font-size: 0.7em; } </style></head>";
            
            //look for the indication that the day has started
            while([line isEqualToString:@""]||([line rangeOfString:@"-----"].location!=NSNotFound&&i<length)){
                line = [array objectAtIndex:i++];
            }
            
            //skip the line of dashes
            line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //Now line contains the current date in the form Monday, July 12, 2011
            
            //get the current date for reference
            NSDate *currentDateTime = [NSDate date];
            // Instantiate a NSDateFormatter
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // Set the dateFormatter format
            [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
            // Get the date time in NSString
            NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];

            //compare the dates - if the line we read in is the same as the current date in the same format, we found today.
            if([dateInString isEqualToString:line]){
                todayIndex = j; //set todayIndex to reflect this
            }
        
            //add the date to the text to display
            text = [text stringByAppendingFormat:@"<h1>%@</h1>",line];
            
            //look for the open Fischer Floors tag
            while(i<length&&[line rangeOfString:@"Open Fischer Floors:"].location == NSNotFound){
                line = [array objectAtIndex:i++];
            }
            
            //add the open Fischer floor hours to the text to display
            text = [text stringByAppendingFormat:@"<h2>%@</h2>",[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            line = [array objectAtIndex:i++];
            
            //now look for the open Smith/Traber Floors tag
            while(i<length&&[line rangeOfString:@"Open Smith/Traber Floors:"].location == NSNotFound){
                line =[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                //don't add extra <br /> tags for an empty line!
                if(![line isEqualToString:@""])
                    text = [text stringByAppendingFormat:@"%@<br />",line]; //add <br /> tags between the hours of floors
                
                line = [array objectAtIndex:i++];
            }
            
            //add the Smith/Traber open floor hours to the text to display
            text = [text stringByAppendingFormat:@"<h2>%@</h2>",[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            line = [array objectAtIndex:i++];
        
        
            while(i<length&&[line rangeOfString:@"-----"].location == NSNotFound){
                
                //don't add extra <br /> tags!
                if(![[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
                    
                    //add <br /> tags between hours of floors 
                    text = [text stringByAppendingFormat:@"%@<br />",[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                
                }
                line = [array objectAtIndex:i++];
            }
            
            //finish off the html for the day
            text = [text stringByAppendingString:@"</body></html>"];
            
            //we've read in a complete day of open floor information, add this to the temporary array for storage 
            [temp addObject:text];
            
            //increment j to indicate the next position we will fill in temp.
            j++;
        
        
        }
    }@catch (NSException *e) {
        //if any exception occurs, do nothing.
    }
    //todayIndex = -1; uncomment this line for error-checking
    
    //if we never found today, notify the user than the floor schedule has not yet been posted. We do this by setting the results instance variable to contain a single day with this information; then point todayIndex to this position, which will be 0.
    if(todayIndex == -1){
        self.results = [NSArray arrayWithObject:@"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold;text-align: center; }</style></head><body><br/><br/><br/><br/><h1>The open floor schedule is not yet available. Check back soon!</h1></body></html>"];
        todayIndex = 0;
    }
    else
        self.results = [NSArray arrayWithArray:temp]; //if there were no problems, set self.results to be the temporary array.
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
