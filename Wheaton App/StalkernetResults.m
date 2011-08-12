//
//  StalkernetResults.m
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StalkernetResults.h"

@implementation StalkernetResults

@synthesize resultsList;
@synthesize image;
@synthesize searchParam;
@synthesize mainTableView;

-(void) loadData
{
    NSError *error;
    // NSString *string = [NSString stringWithContentsOfFile:@"Users/lemongirl/Desktop/search2.xml" encoding:NSUTF8StringEncoding error:&error];
    NSURL *url = [NSURL URLWithString:[@"http://intra.wheaton.edu/directory/whosnew/index.php?search_text=" stringByAppendingString:searchParam]];
   
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]; //put the real resultant URL here.
    if(string == nil){
        NSException *e = [NSException
                          exceptionWithName: @"Off campus"
                          reason: @"You must be connected to the campus internet"
                          userInfo: nil];
        @throw e; 
    }
       
    //array populated w;ith URL contents - one line per array entry    
    //NSArray *array = [stuff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    //i is a counter, to keep track of where we are in the array.
    NSMutableDictionary *temp_results = [NSMutableDictionary dictionaryWithCapacity:10];
    while([string rangeOfString:@"<match>"].location!=NSNotFound){
        NSString *match = @"";
        
        string = [string substringFromIndex:[string rangeOfString:@"<first_name>"].location+12];
        match = [string substringToIndex:[string rangeOfString:@"</first_name>"].location];
        if([match rangeOfString:@"Extra results"].location!=NSNotFound)
            break;
        
        string = [string substringFromIndex:[string rangeOfString:@"<last_name>"].location+11];
        NSString *lastName = [string substringToIndex:[string rangeOfString:@"</last_name>"].location];

        string = [string substringFromIndex:[string rangeOfString:@"<middle_name>"].location+13];
        NSString *middleName =[string substringToIndex:[string rangeOfString:@"</middle_name>"].location];
         
        
        string = [string substringFromIndex:[string rangeOfString:@"<preferred_first_name>"].location+22];
        NSString *preferredFirstName =[string substringToIndex:[string rangeOfString:@"</preferred_first_name>"].location];
        
        string = [string substringFromIndex:[string rangeOfString:@"<student_type>"].location+14];
        NSString *studentType = [string substringToIndex:[string rangeOfString:@"</student_type>"].location];
        
        string = [string substringFromIndex:[string rangeOfString:@"<year_entered>"].location+14];
        NSString *yearEntered = [string substringToIndex:[string rangeOfString:@"</year_entered>"].location];
        
        string = [string substringFromIndex:[string rangeOfString:@"<photo_file>"].location+12];
        NSString *photoFile = [@"http://intra.wheaton.edu/directory/whosnew/" stringByAppendingString:[string substringToIndex:[string rangeOfString:@"</photo_file>"].location]];

        preferredFirstName = [preferredFirstName isEqualToString:@""]?@"":[NSString stringWithFormat:@"(%@) ",preferredFirstName];
        match = [match stringByAppendingFormat:@" %@%@ %@, %@, %@",preferredFirstName,middleName,lastName,studentType,yearEntered];
        
        [temp_results setObject:photoFile forKey:match];
        
    }

    self.resultsList = [temp_results copy];
    
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
