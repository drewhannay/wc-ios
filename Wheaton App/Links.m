//
//  Links.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "Links.h"


@implementation Links

@synthesize linksList;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LinksList" ofType:@"plist"];
    linksList = [[NSDictionary alloc] initWithContentsOfFile:path];

    
    [super viewDidLoad];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    // attempt to request the reusable cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // set the text for the cell
    NSString *cellValue = [[[linksList allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:indexPath.row];

    cell.textLabel.text = cellValue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[linksList allKeys] count];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Useful Links";
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *toOpen = [[[linksList allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:indexPath.row];

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[linksList valueForKey:toOpen]]];
}

@end
