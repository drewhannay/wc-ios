//
//  ChapelTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import "ChapelTableViewController.h"
#import "MasterTabViewController.h"
#import "EventTableCell.h"

@interface ChapelTableViewController ()

@end

@implementation ChapelTableViewController

@synthesize schedule;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSchedule];
}

- (void)loadSchedule
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_Chapel]];
        NSArray *cachesDirList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDir = [cachesDirList objectAtIndex:0];
        if (data != nil) {
            [data writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"chapel.json"]] atomically:YES];
        } else {
            data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"chapel.json"]]];
        }
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [schedule count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSDictionary *dictionary = [schedule objectAtIndex:sectionIndex];
    NSArray *array = [dictionary objectForKey:@"speakers"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    return [[schedule objectAtIndex:sectionIndex] objectForKey:@"month"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"EventCell";
    NSString *cellFileName = @"EventSubtitleLineView";
    
    NSDictionary *dictionary = [schedule objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"speakers"];
    
    NSDictionary *row = [array objectAtIndex:indexPath.row];
    
    if([[row objectForKey:@"subtitle"] isEqualToString:@""]) {
        cellIdentifier = @"EventSingleCell";
        cellFileName = @"EventSingleLineView";
    }
    
    EventTableCell *cell = (EventTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellFileName owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = [row objectForKey:@"title"];
    cell.subtitleLabel.text = [row objectForKey:@"subtitle"];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [row objectForKey:@"date"]];
    
    if(todaySection == indexPath.section && todayRow == indexPath.row) {
        [cell.current setHidden:NO];
    } else {
        [cell.current setHidden:YES];
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


-(void)fetchedData:(id)responseData
{
    if (responseData == nil) {
        return;
    }
    NSError* error;
    NSDictionary *chapelDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* chapelArray = (NSArray*)chapelDictionary;
    
    self.schedule = [[NSMutableArray alloc] init];
    
    for (NSDictionary* month in chapelArray) {
        [schedule addObject:month];
    }
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:([components month]-1)];
    
    int scheduleSectionIndex = 0;
    int scheduleRowIndex = 0;
    int i;
    
    NSArray *scheduleSection;
    for(i = 0; i < [schedule count]; i++) {
        if([[[schedule objectAtIndex:i] objectForKey:@"month"] isEqualToString:monthName]) {
            scheduleSectionIndex = i;
            scheduleSection = [[schedule objectAtIndex:i] objectForKey:@"speakers"];
        }
    }
    for(i = 0; i < [scheduleSection count]; i++) {
        if([[[scheduleSection objectAtIndex:i] objectForKey:@"date"] intValue] < [components day]) {
            scheduleRowIndex = i;
        }
    }
    if(scheduleRowIndex + 1 < [scheduleSection count]) {
        scheduleRowIndex++;
    } else {
        scheduleRowIndex = 0;
    }
    
    todayRow = scheduleRowIndex;
    todaySection = scheduleSectionIndex;
    
    [self.tableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scheduleRowIndex inSection:scheduleSectionIndex];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
}

@end
