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
    [resultsList release];
    [image release];
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

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //---Start our loading spinner---
    [NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
    
    //--This line is just for testing how the spinner looks---
    [NSThread sleepForTimeInterval:3];
    
//    if(self.results == nil)
//        [self loadData];
    
    //---Stop the spinner and continue on with launching the view---
    [NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];

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
    }
    
    //---set the text to display for the cell---
    NSString *cellValue = [[[resultsList allKeys] 
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
    return [[resultsList allKeys] count];
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
