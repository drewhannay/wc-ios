//
//  ChapelTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import "ChapelTableViewController.h"
#import "EventTableCell.h"

@interface ChapelTableViewController ()

@end

@implementation ChapelTableViewController

@synthesize schedule;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    schedule = [[NSMutableArray alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self loadSchedule];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Opened Chapel" properties:@{}];
}

- (void)loadSchedule
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:c_Chapel parameters:@{@"limit":@"100"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *eventsArray = responseObject;
        
        for(NSDictionary *entry in eventsArray) {
            NSDate *entryDate = [NSDate dateWithTimeIntervalSince1970:
                                 [[[entry objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue]];
            
            NSDateComponents *components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                  fromDate:entryDate];
            
            Boolean found = NO;
            for(NSMutableDictionary *category in schedule) {
                if([[category objectForKey:@"year"] intValue] == [components year]
                   && [[category objectForKey:@"month"] intValue] == [components month]) {
                    NSMutableArray *events = [category objectForKey:@"events"];
                    [events addObject:entry];
                    found = YES;
                }
            }
            if(found == NO) {
                NSMutableDictionary *category = [[NSMutableDictionary alloc] init];
                [category setObject:[NSString stringWithFormat:@"%ld", (long)[components year]] forKey:@"year"];
                [category setObject:[NSString stringWithFormat:@"%ld", (long)[components month]] forKey:@"month"];
                NSMutableArray *events = [[NSMutableArray alloc] init];
                [events addObject:entry];
                [category setObject:events forKey:@"events"];
                [schedule addObject:category];
            }
        }
        [self.tableView reloadData];
        [self moveToCorrectRow];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)refreshView:(UIRefreshControl *)sender {
    [self loadSchedule];
    [sender endRefreshing];
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
    NSArray *array = [dictionary objectForKey:@"events"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    NSDictionary *entry = [schedule objectAtIndex:sectionIndex];
    int month = [[entry objectForKey:@"month"] intValue];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(month-1)];
    
    return [NSString stringWithFormat:@"%@", monthName];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"EventCell";
    NSString *cellFileName = @"EventSubtitleLineView";
    
    NSDictionary *dictionary = [schedule objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"events"];
    
    NSDictionary *row = [array objectAtIndex:indexPath.row];
    
    if ([[row objectForKey:@"description"] isEqualToString:@""]) {
        cellIdentifier = @"EventSingleCell";
        cellFileName = @"EventSingleLineView";
    }
    
    EventTableCell *cell = (EventTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellFileName owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = [row objectForKey:@"title"];
    cell.subtitleLabel.text = [row objectForKey:@"description"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[row objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"dd"];
    
    cell.dateLabel.text = [[dateFormatter stringFromDate:date] lowercaseString];
    
    if (todaySection == indexPath.section && todayRow == indexPath.row) {
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
    
    [headerView setBackgroundColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void) moveToCorrectRow
{
    
    int scheduleSectionIndex = 0;
    int scheduleRowIndex = 0;
    
    for (int i = 0; i < [schedule count]; i++) {
        NSArray *section = [[schedule objectAtIndex:i] objectForKey:@"events"];
        for (int j = 0; j < [section count]; j++) {
            if ([[[[section objectAtIndex:j] objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue] < [[NSDate date] timeIntervalSince1970]) {
                scheduleSectionIndex = i;
                scheduleRowIndex = j;
            }
        }
    }
    
    [self.tableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scheduleRowIndex inSection:scheduleSectionIndex];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];

}

@end
