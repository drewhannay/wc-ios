//
//  EventsTopViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 9/8/13.
//
//

#import "EventsTopViewController.h"
#import "EventsTableCell.h"

@interface EventsTopViewController () 

@end

@implementation EventsTopViewController

@synthesize menuBtn, schedule, table;

- (void)viewWillAppear:(BOOL)animated
{
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(4, 0, 44, 44);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.menuBtn];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss z"];
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    schedule = [[NSMutableArray alloc] init];
    [self loadSchedule];    
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)loadSchedule
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_Events]];
        [self performSelectorOnMainThread:@selector(startParser:) withObject:data waitUntilDone:YES];
    });
}

- (void)startParser:(id)responseData
{
    if (responseData == nil) {
        return;
    }
    parser = [[NSXMLParser alloc] initWithData:responseData];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [schedule count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSDictionary *dictionary = [schedule objectAtIndex:sectionIndex];
    NSArray *array = [dictionary objectForKey:@"events"];
    return [array count];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    NSDictionary *entry = [schedule objectAtIndex:sectionIndex];
    int month = [[entry objectForKey:@"month"] intValue];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(month-1)];
    
    return [NSString stringWithFormat:@"%@ - %@", monthName, [entry objectForKey:@"year"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EventsTableCell *cell = (EventsTableCell *)[tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventsCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dictionary = [schedule objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"events"];
    NSDictionary *row = [array objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [row objectForKey:@"title"];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:[row objectForKey:@"date"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%d", [components day]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;    
    if ([element isEqualToString:@"item"]) {
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        date    = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        
        NSString *purifiedString = [date stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        purifiedString = [purifiedString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSDate *entryDate = [dateFormatter dateFromString:purifiedString];
        
        [item setObject:entryDate forKey:@"date"];
        [self addToMess:[item copy]];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"pubDate"]) {
        [date appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.table reloadData];
}

- (void)addToMess:(NSDictionary*)entry {
    
    NSDate *entryDate = [entry objectForKey:@"date"];
    
    NSDateComponents *components = [calendar
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:entryDate];
   
    Boolean found = NO;
    for(NSMutableDictionary *chunk in schedule) {
        if([[chunk objectForKey:@"year"] intValue] == [components year]
           && [[chunk objectForKey:@"month"] intValue] == [components month]) {
            NSMutableArray *events = [chunk objectForKey:@"events"];
            [events addObject:entry];
            found = YES;
        }
    }
    if(found == NO) {
        NSMutableDictionary *chunk = [[NSMutableDictionary alloc] init];
        [chunk setObject:[NSString stringWithFormat:@"%d", [components year]] forKey:@"year"];
        [chunk setObject:[NSString stringWithFormat:@"%d", [components month]] forKey:@"month"];
        NSMutableArray *events = [[NSMutableArray alloc] init];
        [events addObject:entry];
        [chunk setObject:events forKey:@"events"];
        [schedule addObject:chunk];
    }
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
