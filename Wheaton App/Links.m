//
//  Links.m
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Links.h"


@implementation Links

@synthesize linksList;

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
    [linksList release];
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
    //The path to the property list file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LinksList"
                                                     ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.linksList = dic;
    [dic release];
    
    
    
    
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
    }
    
    //---set the text to display for the cell---
    NSString *cellValue = [[[linksList allKeys] 
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
    return [[linksList allKeys] count];
}

-(NSString *) tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    //---return the string to be used as the table header---
    return @"Useful Links";
}

-(void) tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *toOpen = [[[linksList allKeys] 
                            sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
                           objectAtIndex:indexPath.row];
                        
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[linksList valueForKey:toOpen]]];
}

@end
