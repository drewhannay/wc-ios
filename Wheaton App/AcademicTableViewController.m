//
//  AcademicTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/13/13.
//
//

#import "AcademicTableViewController.h"
#import "EventTableCell.h"

@interface AcademicTableViewController ()

@end

@implementation AcademicTableViewController

@synthesize calendar;


- (void)viewDidLoad
{
    [super viewDidLoad];

    cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar = [[NSMutableArray alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    [self loadCalendar];
}

- (void)loadCalendar
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_Academic]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData
{
    if (responseData == nil) {
        return;
    }
    
    // parse out the json data
    NSError *error;
    NSArray *eventsArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    [calendar removeAllObjects];
    
    for(NSDictionary *entry in eventsArray) {
        NSDate *entryDate = [NSDate dateWithTimeIntervalSince1970:
                             [[[entry objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue]];
        
        NSDateComponents *components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                        fromDate:entryDate];
        
        Boolean found = NO;
        for(NSMutableDictionary *category in calendar) {
            if([[category objectForKey:@"year"] intValue] == [components year]
               && [[category objectForKey:@"month"] intValue] == [components month]) {
                NSMutableArray *events = [category objectForKey:@"events"];
                [events addObject:entry];
                found = YES;
            }
        }
        if(found == NO) {
            NSMutableDictionary *category = [[NSMutableDictionary alloc] init];
            [category setObject:[NSString stringWithFormat:@"%d", [components year]] forKey:@"year"];
            [category setObject:[NSString stringWithFormat:@"%d", [components month]] forKey:@"month"];
            NSMutableArray *events = [[NSMutableArray alloc] init];
            [events addObject:entry];
            [category setObject:events forKey:@"events"];
            [calendar addObject:category];
        }
    }
    
    [self.tableView reloadData];
}

- (void)refreshView:(UIRefreshControl *)sender {
    [self loadCalendar];
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
    return [calendar count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [[calendar objectAtIndex:section] objectForKey:@"events"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    NSDictionary *entry = [calendar objectAtIndex:sectionIndex];
    int month = [[entry objectForKey:@"month"] intValue];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(month-1)];
    
    return [NSString stringWithFormat:@"%@ - %@", monthName, [entry objectForKey:@"year"]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"EventSingleCell";
    NSString *cellFileName = @"EventSingleLineView";
    
    NSDictionary *row = [[[calendar objectAtIndex:indexPath.section] objectForKey:@"events" ] objectAtIndex:indexPath.row];
    
    EventTableCell *cell = (EventTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellFileName owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[row objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"dd"];
    
    cell.titleLabel.text = [row objectForKey:@"title"];
    cell.dateLabel.text = [[dateFormatter stringFromDate:date] lowercaseString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
