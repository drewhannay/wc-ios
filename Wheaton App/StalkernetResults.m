//
//  StalkernetResults.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "StalkernetResults.h"

@implementation StalkernetResults

@synthesize resultsList;
@synthesize image;
@synthesize searchParam;
@synthesize mainTableView;


/**
 *Load the matches from the dropbox file,
 *and prepare to display them.
 */
-(void) loadData
{

    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:[@"https://intra.wheaton.edu/whoswho/person/search?q=" stringByAppendingString:searchParam]];
   
    NSString *intraResults = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]; //put the real resultant URL here.
    
    //If something went wrong with accessing the url, they are probably not on campus - inform them they must be to use this feature.
    if(intraResults == nil){
        NSException *e = [NSException
                          exceptionWithName: @"Off campus"
                          reason: @"You must be connected to the campus internet"
                          userInfo: nil];
        @throw e; 
    }
       NSMutableDictionary *temp_results = [NSMutableDictionary dictionaryWithCapacity:10];
    @try{
        BOOL noResults = [intraResults rangeOfString:@"<span class=\"empty\">No results found.</span></div>"].location != NSNotFound;
        if(noResults) {
         NSException *e = [NSException
                           exceptionWithName:@"No results" 
                           reason:@"No results found." 
                           userInfo:nil];
            @throw e;
        }
        intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"div class=\"span-24\""].location+20];

        while(!([intraResults characterAtIndex:[intraResults rangeOfString:@"div id=\""].location + 8]=='f')){
           
            intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"src"].location];
            NSString* temp = @"";
            temp = [intraResults substringFromIndex:4];
            NSString* photoFile = [temp substringToIndex:[temp rangeOfString:@"/>"].location];
            photoFile = [photoFile stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
            intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"<div class=\"name bold\">"].location];
            //NOT a mistake - once to get past the div class, one for a href.
            intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@">"].location+1];
            intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@">"].location+1];
            
            NSString* firstName = [intraResults substringToIndex:[intraResults rangeOfString:@" "].location];
            firstName = [firstName stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            temp = [intraResults substringFromIndex:[intraResults rangeOfString:@" "].location+1];
            NSString* lastName = [temp substringToIndex:[temp rangeOfString:@"<"].location];
            lastName = [lastName stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];

           
            NSString* preferredFirstName = @"";
            int prefIndex = [intraResults rangeOfString:@"Preferred"].location;
            if(prefIndex!=NSNotFound && prefIndex<[intraResults rangeOfString:@"Type"].location){
                intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"</span>"].location+7];
                preferredFirstName = [intraResults substringToIndex:[intraResults rangeOfString:@"<br"].location];
                preferredFirstName = [preferredFirstName stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"<br"].location+6];
                intraResults = [intraResults stringByTrimmingCharactersInSet:
                                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            NSString* cpo = @"";
            int cpoIndex = [intraResults rangeOfString:@"CPO"].location;
            if(cpoIndex!=NSNotFound&&cpoIndex<[intraResults rangeOfString:@"Type"].location){
                intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"</span>"].location+7];
                cpo = [intraResults substringToIndex:[intraResults rangeOfString:@"<br"].location];
                cpo = [cpo stringByTrimmingCharactersInSet:
                                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"<br"].location+6];
                intraResults = [intraResults stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            }
            BOOL studentType = false;
            int student = [intraResults rangeOfString:@"Student"].location;
            int staffIndex = [intraResults rangeOfString:@"Faculty/Staff"].location;
            //student case
            if((student!=NSNotFound && student<staffIndex)||staffIndex == NSNotFound){
                studentType = true;
            }
            
            NSString *klazz = @"";
            int klazzIndex = [intraResults rangeOfString:@"Class"].location;
            if(klazzIndex!=NSNotFound&&klazzIndex<[intraResults rangeOfString:@"Type"].location){
                intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"</span>"].location+7];
                klazz = [intraResults substringToIndex:[intraResults rangeOfString:@"<br"].location];
                klazz = [klazz stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"<br"].location+6];
                intraResults = [intraResults stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            NSString *department = @"";
            int departmentIndex = [intraResults rangeOfString:@"Department"].location;
            if(departmentIndex!=NSNotFound&&departmentIndex<[intraResults rangeOfString:@"Type"].location){
                intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"</span>"].location+7];
                department = [intraResults substringToIndex:[intraResults rangeOfString:@"<br"].location];
                department = [department stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"<br"].location+6];
                intraResults = [intraResults stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];

            }
            
            
            intraResults = [intraResults substringFromIndex:[intraResults rangeOfString:@"div id=\""].location];
            
            NSString *match = firstName;
            if(![preferredFirstName isEqualToString:@""]){
                match = [match stringByAppendingFormat:@" (%@)",preferredFirstName];
            }
            match = [match stringByAppendingFormat:@" %@",lastName];
            if(studentType){
                match = [match stringByAppendingFormat:@",\n"];
                if(![cpo isEqualToString:@""])
                    match = [match stringByAppendingFormat:@"CPO:%@",cpo];
                if(![klazz isEqualToString:@""])
                    match = [match stringByAppendingFormat:@" %@",klazz];
                match = [match stringByAppendingFormat:@" Student"];
            }
            else{
                if(![department isEqualToString:@""])
                    match = [match stringByAppendingFormat:@"\n%@ Department",department];
                
            }
            [temp_results setObject:photoFile forKey:match];
        //well, some documenting is better than none? <- Alisa
         }   
    }@catch(NSException *n){
        //in case of exception, do nothing. 
    }


    self.resultsList = [temp_results copy]; //copy the results to results_list.
        
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
    [mainTableView release];
    [resultsList release];
    [image release];
    [searchParam release];
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

-(UITableViewCell *) tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //---try to get a reusable cell---
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //---create a new cell if no reusable cell is available---
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18.0];

    }
    
    //---set the text to display for the cell---

    NSString *cellValue = [[[self.resultsList allKeys] 
                            sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
                            objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//---set the number of rows in the table view---
-(NSInteger) tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.resultsList allKeys] count];
}

-(NSString *) tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    //---return the string to be used as the table header---
    return @"Results";
}

-(void) tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *toOpen = [[[resultsList allKeys] 
                         sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
                        objectAtIndex:indexPath.row];
    
    UIImage *tempImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[resultsList valueForKey:toOpen]]]];
    [image setImage:tempImage];
    [tempImage release];
}

@end
