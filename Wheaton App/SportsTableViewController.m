//
//  SportsTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/10/13.
//
//

#import "SportsTableViewController.h"
#import "SportTableCell.h"

@interface SportsTableViewController ()

@end

@implementation SportsTableViewController

@synthesize sportResults;
@synthesize displayResults = _displayResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sportResults = [[NSMutableDictionary alloc] init];
    
    [sportResults setObject:[[NSArray alloc] init] forKey:@"0"];
    [sportResults setObject:[[NSArray alloc] init] forKey:@"1"];
	
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_Sports]];
        [self performSelectorOnMainThread:@selector(fetchedDataToCome:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedDataToCome:(NSData *)responseData
{
    if (responseData == nil) {
        return;
    }
    
    NSError *error;
    [sportResults setObject:[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error]
                     forKey:@"1"];
    [self.tableView reloadData];
    
    NSString *completedSportsUrl = [NSString stringWithFormat:@"%@&direction=-1&pivot=before&limit=10",c_Sports];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: completedSportsUrl]];
        [self performSelectorOnMainThread:@selector(fetchedDataCompleted:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedDataCompleted:(NSData *)responseData
{
    if (responseData == nil) {
        return;
    }
    
    NSError *error;
    
    NSArray *pastSportsEvents = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSMutableArray *reversedEvents = [NSMutableArray arrayWithCapacity:[pastSportsEvents count]];
    NSEnumerator * reverseEnumerator = [pastSportsEvents reverseObjectEnumerator];
    for (id object in reverseEnumerator) {
        [reversedEvents addObject:object];
    }
    
    [sportResults setObject:reversedEvents forKey:@"0"];
    [self.tableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    if (sectionIndex == 0) {
        return @"Past";
    }
    return @"Upcoming";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake (10, 2, 200, 20)];
    label.text = sectionTitle;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [headerView addSubview:label];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sportResults objectForKey:[NSString stringWithFormat:@"%d", section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *result = [[sportResults objectForKey:[NSString stringWithFormat:@"%d", indexPath.section]] objectAtIndex:indexPath.row];
    NSDictionary *custom = [result objectForKey:@"custom"];
    NSDictionary *score = [custom objectForKey:@"score"];
    
    NSString *cellIdentifier = @"SportTableCell";
    
    if ([score count] > 0 && ![[score objectForKey:@"school"] isEqual: @""]) {
        cellIdentifier = @"SportScoreTableCell";
    }
    
    SportTableCell *cell = (SportTableCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[result objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue]];
    NSString *sport = (NSString *)[result objectForKey:@"title"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"MM/dd hh:mm a"];
    
    cell.time.text = [[dateFormatter stringFromDate:date] lowercaseString];
    
    [cell.sport setHidden:NO];
    if ([sport isEqualToString:@"Soccer"])
        cell.sport.image = [UIImage imageNamed:@"Soccer.png"];
    else if ([sport isEqualToString:@"Basketball"])
        cell.sport.image = [UIImage imageNamed:@"Basketball.png"];
    else if ([sport isEqualToString:@"Volleyball"])
        cell.sport.image = [UIImage imageNamed:@"Volleyball.png"];
    else if ([sport isEqualToString:@"Golf"])
        cell.sport.image = [UIImage imageNamed:@"Golf.png"];
    else if ([sport isEqualToString:@"Football"])
        cell.sport.image = [UIImage imageNamed:@"Football.png"];
    else if ([sport isEqualToString:@"Tennis"])
        cell.sport.image = [UIImage imageNamed:@"Tennis.png"];
    else if ([sport isEqualToString:@"Swimming"])
        cell.sport.image = [UIImage imageNamed:@"Swimming.png"];
    else
        [cell.sport setHidden:YES];
    
    cell.team.text = [NSString stringWithFormat:@"%@. %@", [[[custom objectForKey:@"gender"] substringToIndex:1] uppercaseString], [sport capitalizedString]];
    cell.opponent.text = [custom objectForKey:@"opponent"];
    
    if ([(NSNumber *)[custom objectForKey: @"home"] isEqual: @(YES)]) {
        [cell.home setHidden:FALSE];
    } else {
        [cell.home setHidden:TRUE];
    }

    if ([score count] > 0) {
        cell.scoreOpponent.text = [score objectForKey:@"other"];
        cell.scoreSchool.text = [score objectForKey:@"school"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
