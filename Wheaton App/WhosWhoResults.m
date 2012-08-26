//
//  WhosWhoResults.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "WhosWhoResults.h"
#import "WhosWhoTableViewCell.h"
#import "HomeScreen.h"

@implementation WhosWhoResults

@synthesize resultsList;
@synthesize searchResults;

-(void)fetchedImageData
{
    [resultsList reloadData];
}

#pragma mark - View lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        profileImages = [[NSMutableArray alloc] initWithCapacity:[searchResults count]];
        for (int i = 0; i < [searchResults count]; i++)
        {
            [profileImages addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[searchResults objectAtIndex:i] objectForKey:@"PhotoUrl"]]]];
            [self performSelectorOnMainThread:@selector(fetchedImageData) withObject:nil waitUntilDone:NO];
        }
    });
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *cellIdentifier = @"WhosWhoTableViewCell";

    // attempt to request the reusable cell
    WhosWhoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"WhosWhoTableViewCell" owner:nil options:nil];
        
        for (UIView *view in views)
        {
            if([view isKindOfClass:[UITableViewCell class]])
                cell = (WhosWhoTableViewCell *) view;
        }
    }

    [cell resetCell];

    NSDictionary *result = [searchResults objectAtIndex:indexPath.row];

    NSString *firstName = [result objectForKey:@"FirstName"];
    NSString *prefFirstName = [result objectForKey:@"PrefFirstName"];
    NSString *middleName = [result objectForKey:@"MiddleName"];
    NSString *lastName = [result objectForKey:@"LastName"];

    NSMutableString *fullName = [[NSMutableString alloc] initWithString:firstName];
    if (![self isNullOrEmpty:prefFirstName])
        [fullName appendFormat:@" \"%@\"", prefFirstName];
    if (![self isNullOrEmpty:middleName])
        [fullName appendFormat:@" %@", middleName];
    if (![self isNullOrEmpty:lastName])
        [fullName appendFormat:@" %@", lastName];

    [cell addLabelWithString:fullName];

    NSString *cpo = [result objectForKey:@"CPOBox"];
    if (![self isNullOrEmpty:cpo])
        [cell addLabelWithString:[NSString stringWithFormat:@"CPO %@", cpo]];

    if ([[result objectForKey:@"Type"] isEqualToString:@"1"])
        [cell addLabelWithString:@"Faculty/Staff"];
    else
        [cell addLabelWithString:@"Student"];

    NSString *classification = [result objectForKey:@"Classification"];
    if (![self isNullOrEmpty:classification])
        [cell addLabelWithString:classification];

    NSString *department = [result objectForKey:@"Dept"];
    if (![self isNullOrEmpty:department])
        [cell addLabelWithString:department];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([profileImages count] > indexPath.row)
        cell.imageView.image = [UIImage imageWithData:[profileImages objectAtIndex:indexPath.row]];

    return cell;
}

-(BOOL)isNullOrEmpty:(NSString *) string
{
    return [string isEqual:[NSNull null]] || [string isEqualToString:@""];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Results";
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString *email = [NSString stringWithFormat:@"mailto:%@",[[searchResults objectAtIndex:indexPath.row] objectForKey:@"Email"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

@end
